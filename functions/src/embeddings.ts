// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { VertexAI } from "@google-cloud/vertexai";

const db = admin.firestore();

// Vertex AI configuration - set via Firebase secrets
const PROJECT_ID = process.env.VERTEX_AI_PROJECT || "lifeos-hackathon";
const LOCATION = process.env.VERTEX_AI_LOCATION || "us-central1";

let vertexAI: VertexAI | null = null;
let embeddingModel: any = null;

function getVertexAI(): VertexAI {
  if (!vertexAI) {
    vertexAI = new VertexAI({ project: PROJECT_ID, location: LOCATION });
  }
  return vertexAI;
}

function getEmbeddingModel() {
  if (!embeddingModel) {
    const vertex = getVertexAI();
    embeddingModel = vertex.getGenerativeModel({
      model: "text-embedding-004",
    });
  }
  return embeddingModel;
}

/**
 * Generate embedding for a single text
 */
export async function generateEmbedding(text: string): Promise<number[]> {
  try {
    const model = getEmbeddingModel();
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

/**
 * Generate embeddings for multiple texts (batch)
 */
export async function generateEmbeddings(texts: string[]): Promise<number[][]> {
  try {
    const model = getEmbeddingModel();
    const results = await Promise.all(
      texts.map((text) => model.embedContent(text))
    );
    return results.map((r) => r.embedding?.values || []);
  } catch (error) {
    console.error("Error generating batch embeddings:", error);
    throw new Error(`Failed to generate batch embeddings: ${error}`);
  }
}

/**
 * Check if item content has changed significantly to warrant re-embedding
 */
function shouldRegenerateEmbedding(
  beforeData: admin.firestore.DocumentData | undefined,
  afterData: admin.firestore.DocumentData | undefined
): boolean {
  if (!beforeData || !afterData) return true;

  const beforeContent = beforeData.content || "";
  const afterContent = afterData.content || "";
  const beforeTitle = beforeData.title || "";
  const afterTitle = afterData.title || "";

  return beforeContent !== afterContent || beforeTitle !== afterTitle;
}

/**
 * Update item with embedding in Firestore
 */
async function updateItemEmbedding(
  userId: string,
  itemId: string,
  embedding: number[]
): Promise<void> {
  try {
    await db.collection("users").doc(userId).collection("items").doc(itemId).update({
      embedding: embedding,
      embeddingUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (error) {
    console.error("Error updating item embedding:", error);
    throw error;
  }
}

/**
 * Triggered when a new item is created
 */
export async function onItemCreate(
  snap: admin.firestore.QueryDocumentSnapshot,
  context: functions.EventContext
): Promise<void> {
  const { userId, itemId } = context.params;
  const itemData = snap.data();

  console.log(`Generating embedding for new item: ${itemId} for user: ${userId}`);

  try {
    const textToEmbed = [
      itemData.title,
      itemData.description,
      itemData.content,
      ...(itemData.tags || []),
      ...(itemData.keyPoints || []),
    ]
      .filter(Boolean)
      .join("\n\n");

    if (!textToEmbed.trim()) {
      console.log("No content to embed, skipping");
      return;
    }

    const embedding = await generateEmbedding(textToEmbed);
    await updateItemEmbedding(userId, itemId, embedding);
    console.log(`Embedding generated and stored for item: ${itemId}`);
  } catch (error) {
    console.error(`Failed to generate embedding for item ${itemId}:`, error);
  }
}

/**
 * Triggered when an item is updated
 */
export async function onItemUpdate(
  change: functions.Change<admin.firestore.QueryDocumentSnapshot>,
  context: functions.EventContext
): Promise<void> {
  const { userId, itemId } = context.params;
  const beforeData = change.before.data();
  const afterData = change.after.data();

  console.log(`Checking if embedding needs update for item: ${itemId}`);

  try {
    if (!shouldRegenerateEmbedding(beforeData, afterData)) {
      console.log("Content unchanged, skipping embedding regeneration");
      return;
    }

    const textToEmbed = [
      afterData.title,
      afterData.description,
      afterData.content,
      ...(afterData.tags || []),
      ...(afterData.keyPoints || []),
    ]
      .filter(Boolean)
      .join("\n\n");

    if (!textToEmbed.trim()) {
      console.log("No content to embed, skipping");
      return;
    }

    const embedding = await generateEmbedding(textToEmbed);
    await updateItemEmbedding(userId, itemId, embedding);
    console.log(`Embedding updated for item: ${itemId}`);
  } catch (error) {
    console.error(`Failed to update embedding for item ${itemId}:`, error);
  }
}

/**
 * Triggered when an item is deleted
 */
export async function onItemDelete(
  snap: admin.firestore.QueryDocumentSnapshot,
  context: functions.EventContext
): Promise<void> {
  const { userId, itemId } = context.params;

  console.log(`Item deleted: ${itemId} for user: ${userId}`);

  try {
    console.log(`Cleanup completed for deleted item: ${itemId}`);
  } catch (error) {
    console.error(`Error during embedding cleanup for ${itemId}:`, error);
  }
}