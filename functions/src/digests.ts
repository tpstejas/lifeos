// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { VertexAI } from "@google-cloud/vertexai";

const db = admin.firestore();
const messaging = admin.messaging();

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
        maxOutputTokens: 4096,
        temperature: 0.4,
        topP: 0.9,
        topK: 40,
      },
    });
  }
  return generativeModel;
}

type DigestPeriod = "daily" | "weekly" | "monthly";

interface DigestItem {
  id: string;
  title: string;
  type: string;
  collectionId: string;
  summary?: string;
  keyPoints: string[];
  createdAt: admin.firestore.Timestamp;
  tags: string[];
}

interface DigestData {
  period: DigestPeriod;
  dateRange: { start: Date; end: Date };
  items: DigestItem[];
  summary: string;
  highlights: string[];
  actionItems: string[];
  generatedAt: Date;
}

/**
 * Get date range for a digest period
 */
function getDateRange(period: DigestPeriod, fromDate: Date = new Date()): { start: Date; end: Date } {
  const end = new Date(fromDate);
  end.setHours(23, 59, 59, 999);

  const start = new Date(fromDate);
  switch (period) {
    case "daily":
      start.setDate(start.getDate() - 1);
      start.setHours(0, 0, 0, 0);
      break;
    case "weekly":
      start.setDate(start.getDate() - 7);
      start.setHours(0, 0, 0, 0);
      break;
    case "monthly":
      start.setMonth(start.getMonth() - 1);
      start.setHours(0, 0, 0, 0);
      break;
  }

  return { start, end };
}

/**
 * Fetch user's items for a date range
 */
async function fetchItemsForPeriod(
  userId: string,
  period: DigestPeriod,
  date: Date
): Promise<DigestItem[]> {
  const { start, end } = getDateRange(period, date);

  const snapshot = await db
    .collection("users")
    .doc(userId)
    .collection("items")
    .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(start))
    .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(end))
    .where("isArchived", "==", false)
    .orderBy("createdAt", "desc")
    .limit(100)
    .get();

  return snapshot.docs.map((doc) => {
    const data = doc.data();
    return {
      id: doc.id,
      title: data.title || "Untitled",
      type: data.type || "note",
      collectionId: data.collectionId || "general",
      summary: data.summary,
      keyPoints: data.keyPoints || [],
      createdAt: data.createdAt,
      tags: data.tags || [],
    };
  });
}

/**
 * Build prompt for LLM to generate digest
 */
function buildDigestPrompt(
  period: DigestPeriod,
  items: DigestItem[],
  dateRange: { start: Date; end: Date }
): string {
  const periodLabel = period.charAt(0).toUpperCase() + period.slice(1);
  const dateStr = `${dateRange.start.toLocaleDateString()} - ${dateRange.end.toLocaleDateString()}`;

  if (items.length === 0) {
    return `Generate a ${periodLabel} digest for ${dateStr}.

The user had no new items captured during this period.

Provide a brief, encouraging message acknowledging this and suggesting they capture something tomorrow.`;
  }

  const itemsText = items
    .map((item, i) => {
      const keyPoints = item.keyPoints.length > 0
        ? `\n  Key Points: ${item.keyPoints.join("; ")}`
        : "";
      const summary = item.summary ? `\n  Summary: ${item.summary}` : "";
      return `${i + 1}. [${item.collectionId}] ${item.title} (${item.type})${summary}${keyPoints}`;
    })
    .join("\n\n");

  return `Generate a ${periodLabel.toLowerCase()} digest for ${dateStr}.

The user captured ${items.length} items during this period:

${itemsText}

Instructions:
- Write a concise executive summary (2-3 sentences) of what happened this period
- Identify 3-5 key highlights/themes from the items
- Extract 2-3 actionable items or follow-ups
- Tone: encouraging, insightful, personal
- Format as JSON with: { "summary": "...", "highlights": [...], "actionItems": [...] }`;
}

/**
 * Generate digest using LLM
 */
async function generateDigestWithLLM(
  period: DigestPeriod,
  items: DigestItem[],
  dateRange: { start: Date; end: Date }
): Promise<{ summary: string; highlights: string[]; actionItems: string[] }> {
  const prompt = buildDigestPrompt(period, items, dateRange);

  try {
    const model = getGenerativeModel();
    const result = await model.generateContent(prompt);
    const response = result.response.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!response) {
      throw new Error("Empty response from LLM");
    }

    const jsonMatch = response.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }

    return {
      summary: `You captured ${items.length} items this ${period}.`,
      highlights: items.slice(0, 3).map((i) => i.title),
      actionItems: ["Review your captures", "Organize into collections"],
    };
  } catch (error) {
    console.error("Error generating digest:", error);
    return {
      summary: `You captured ${items.length} items this ${period}.`,
      highlights: items.slice(0, 3).map((i) => i.title),
      actionItems: ["Review your captures", "Organize into collections"],
    };
  }
}

/**
 * Save digest to Firestore
 */
async function saveDigest(
  userId: string,
  digestData: DigestData
): Promise<string> {
  const digestRef = await db
    .collection("users")
    .doc(userId)
    .collection("digests")
    .add({
      ...digestData,
      dateRange: {
        start: admin.firestore.Timestamp.fromDate(digestData.dateRange.start),
        end: admin.firestore.Timestamp.fromDate(digestData.dateRange.end),
      },
      generatedAt: admin.firestore.Timestamp.fromDate(digestData.generatedAt),
    });

  return digestRef.id;
}

/**
 * Send push notification for digest
 */
async function sendDigestNotification(
  userId: string,
  period: DigestPeriod,
  digestId: string
): Promise<void> {
  try {
    const tokensSnap = await db
      .collection("users")
      .doc(userId)
      .collection("fcmTokens")
      .get();

    if (tokensSnap.empty) return;

    const tokens = tokensSnap.docs.map((doc) => doc.id);

    const periodLabel = period.charAt(0).toUpperCase() + period.slice(1);

    const message: admin.messaging.MulticastMessage = {
      tokens,
      notification: {
        title: `Your ${periodLabel} Digest is Ready`,
        body: `See what you captured and AI insights from the past ${period}.`,
      },
      data: {
        type: "digest",
        period,
        digestId,
      },
      android: {
        priority: "high",
      },
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
          },
        },
      },
    };

    await messaging.sendEachForMulticast(message);
    console.log(`Digest notification sent to ${tokens.length} devices for user ${userId}`);
  } catch (error) {
    console.error("Error sending digest notification:", error);
  }
}

/**
 * Main digest generation function
 */
async function generateDigest(
  period: DigestPeriod,
  context: functions.EventContext
): Promise<void> {
  console.log(`Generating ${period} digest`);

  const usersSnap = await db.collection("users").limit(500).get();

  for (const userDoc of usersSnap.docs) {
    const userId = userDoc.id;

    try {
      const items = await fetchItemsForPeriod(userId, period, new Date());
      const dateRange = getDateRange(period, new Date());
      const { summary, highlights, actionItems } = await generateDigestWithLLM(
        period,
        items,
        dateRange
      );

      const digestData: DigestData = {
        period,
        dateRange,
        items,
        summary,
        highlights,
        actionItems,
        generatedAt: new Date(),
      };

      const digestId = await saveDigest(userId, digestData);
      await sendDigestNotification(userId, period, digestId);

      console.log(`Generated ${period} digest ${digestId} for user ${userId}`);
    } catch (error) {
      console.error(`Failed to generate ${period} digest for user ${userId}:`, error);
    }
  }
}

/**
 * Daily digest - runs every morning at 7 AM
 */
export async function generateDailyDigest(
  context: functions.EventContext
): Promise<void> {
  await generateDigest("daily", context);
}

/**
 * Weekly digest - runs every Monday at 8 AM
 */
export async function generateWeeklyDigest(
  context: functions.EventContext
): Promise<void> {
  await generateDigest("weekly", context);
}

/**
 * Monthly digest - runs on the 1st of each month at 9 AM
 */
export async function generateMonthlyDigest(
  context: functions.EventContext
): Promise<void> {
  await generateDigest("monthly", context);
}

/**
 * Manual digest generation (callable from client)
 */
export const generateDigestManual = functions.https.onCall(
  async (data: { period: DigestPeriod }, context: functions.CallableContext) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const userId = context.auth.uid;
    const { period } = data;

    if (!["daily", "weekly", "monthly"].includes(period)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Period must be daily, weekly, or monthly"
      );
    }

    try {
      const items = await fetchItemsForPeriod(userId, period, new Date());
      const dateRange = getDateRange(period, new Date());
      const { summary, highlights, actionItems } = await generateDigestWithLLM(
        period,
        items,
        dateRange
      );

      const digestData: DigestData = {
        period,
        dateRange,
        items,
        summary,
        highlights,
        actionItems,
        generatedAt: new Date(),
      };

      const digestId = await saveDigest(userId, digestData);
      await sendDigestNotification(userId, period, digestId);

      return { success: true, digestId };
    } catch (error) {
      console.error("Manual digest generation failed:", error);
      throw new functions.https.HttpsError(
        "internal",
        `Failed to generate digest: ${error}`
      );
    }
  }
);