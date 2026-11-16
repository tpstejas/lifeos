// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { VertexAI } from "@google-cloud/vertexai";

const db = admin.firestore();

// Vertex AI configuration
const PROJECT_ID = process.env.VERTEX_AI_PROJECT || "lifeos-hackathon";
const LOCATION = process.env.VERTEX_AI_LOCATION || "us-central1";

let vertexAI: VertexAI | null = null;
let generativeModel: any = null;

function getVertexAI(): VertexAI {
  if (!vertexAI) {
    vertexAI = new VertexAI({ project: PROJECT_ID, location: LOCATION });
  }
  return vertexAI;
}

function getGenerativeModel() {
  if (!generativeModel) {
    const vertex = getVertexAI();
    generativeModel = vertex.getGenerativeModel({
      model: "gemini-1.5-flash",
      generationConfig: {
        maxOutputTokens: 2048,
        temperature: 0.3,
        topP: 0.8,
        topK: 40,
      },
    });
  }
  return generativeModel;
}

interface RAGRequest {
  query: string;
  userId: string;
  topK?: number;
  minSimilarity?: number;
}

interface Citation {
  itemId: string;
  title: string;
  snippet: string;
  similarity: number;
}

interface RAGResponse {
  answer: string;
  citations: Citation[];
  source: "onDevice" | "cloud" | "hybrid";
}

/**
 * Compute cosine similarity between two vectors
 */
function cosineSimilarity(a: number[], b: number[]): number {
  if (a.length !== b.length) return 0;

  let dotProduct = 0;
  let normA = 0;
  let normB = 0;

  for (let i = 0; i < a.length; i++) {
    dotProduct += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }

  if (normA === 0 || normB === 0) return 0;

  return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
}

/**
 * Search user's items by vector similarity
 */
async function searchSimilarItems(
  userId: string,
  queryEmbedding: number[],
  topK: number = 10,
  minSimilarity: number = 0.6
): Promise<Citation[]> {
  try {
    // Fetch items with embeddings
    const snapshot = await db
      .collection("users")
      .doc(userId)
      .collection("items")
      .where("embedding", "!=", null)
      .limit(500) // Adjust based on user's item count
      .get();

    const items: Citation[] = [];

    for (const doc of snapshot.docs) {
      const data = doc.data();
      const embedding = data.embedding as number[];

      if (!embedding || embedding.length === 0) continue;

      const similarity = cosineSimilarity(queryEmbedding, embedding);

      if (similarity >= minSimilarity) {
        const snippet = (data.content || data.description || "").substring(0, 300);
        items.push({
          itemId: doc.id,
          title: data.title || "Untitled",
          snippet: snippet || data.summary || "No preview available",
          similarity,
        });
      }
    }

    // Sort by similarity descending and take top K
    return items
      .sort((a, b) => b.similarity - a.similarity)
      .slice(0, topK);
  } catch (error) {
    console.error("Error searching similar items:", error);
    return [];
  }
}

/**
 * Build context string from citations for LLM
 */
function buildContext(citations: Citation[]): string {
  if (citations.length === 0) {
    return "No relevant items found in the user's library.";
  }

  return citations
    .map((c, i) => {
      return `[Source ${i + 1}] ${c.title}\n${c.snippet}\n`;
    })
    .join("\n---\n");
}

/**
 * Generate answer using LLM with retrieved context
 */
async function generateAnswer(
  query: string,
  context: string,
  citations: Citation[]
): Promise<string> {
  const prompt = `You are LifeOS AI, a helpful assistant that answers questions based on the user's personal knowledge library.

User's Question: ${query}

Relevant Items from User's Library:
${context}

Instructions:
- Answer the question using ONLY the information from the provided sources
- If the sources don't contain enough information, say so honestly
- Cite sources using [Source X] format in your answer
- Be concise but thorough
- Write in a natural, conversational tone

Answer:`;

  try {
    const model = getGenerativeModel();
    const result = await model.generateContent(prompt);
    const response = result.response.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!response) {
      throw new Error("Empty response from LLM");
    }

    return response;
  } catch (error) {
    console.error("Error generating answer:", error);
    throw new Error(`Failed to generate answer: ${error}`);
  }
}

/**
 * Callable RAG query function
 * Client sends: { query, topK?, minSimilarity? }
 * Returns: { answer, citations[], source: "cloud" }
 */
export const ragQuery = functions.https.onCall(
  async (data: RAGRequest, context: functions.CallableContext): Promise<RAGResponse> => {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const userId = context.auth.uid;
    const { query, topK = 10, minSimilarity = 0.6 } = data;

    if (!query || query.trim().length === 0) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Query is required"
      );
    }

    console.log(`RAG query from user ${userId}: "${query}"`);

    try {
      // Step 1: Generate embedding for the query
      const queryEmbedding = await generateEmbedding(query);

      // Step 2: Search for similar items
      const citations = await searchSimilarItems(
        userId,
        queryEmbedding,
        topK,
        minSimilarity
      );

      console.log(`Found ${citations.length} relevant items`);

      // Step 3: Build context and generate answer
      const contextStr = buildContext(citations);
      const answer = await generateAnswer(query, contextStr, citations);

      // Step 4: Return response with citations
      return {
        answer,
        citations,
        source: "cloud",
      };
    } catch (error) {
      console.error("RAG query failed:", error);
      throw new functions.https.HttpsError(
        "internal",
        `Failed to process query: ${error}`
      );
    }
  }
);

/**
 * Generate embedding for a single text (re-exported for use by other functions)
 */
export async function generateEmbedding(text: string): Promise<number[]> {
  try {
    const vertex = getVertexAI();
    const model = vertex.getGenerativeModel({
      model: "text-embedding-004",
    });
    const result = await model.embedContent(text);
    const embedding = result.embedding?.values;
    if (!embedding || embedding.length === 0) {
      throw new Error("Empty embedding returned");
    }
    return embedding;
  } catch (error) {
    console.error("Error generating embedding:", error);
    throw new Error(`Failed to generate embedding: ${error}`);
  }
}