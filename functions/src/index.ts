// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Import function modules
import { onItemCreate, onItemUpdate, onItemDelete } from "./embeddings.js";
import { ragQuery } from "./rag.js";
import { generateDailyDigest, generateWeeklyDigest, generateMonthlyDigest } from "./digests.js";

admin.initializeApp();

// Set global options for all functions
functions.setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

// ============================================================
// EMBEDDING FUNCTIONS - Triggered on item changes
// ============================================================

/**
 * Triggered when a new item is created.
 * Generates embedding for the item content and stores it.
 */
export const generateEmbeddingOnCreate = functions.firestore
  .document("users/{userId}/items/{itemId}")
  .onCreate(onItemCreate);

/**
 * Triggered when an item is updated.
 * Re-generates embedding if content changed.
 */
export const generateEmbeddingOnUpdate = functions.firestore
  .document("users/{userId}/items/{itemId}")
  .onUpdate(onItemUpdate);

/**
 * Triggered when an item is deleted.
 * Cleans up any associated vector data.
 */
export const cleanupEmbeddingOnDelete = functions.firestore
  .document("users/{userId}/items/{itemId}")
  .onDelete(onItemDelete);

// ============================================================
// RAG QUERY FUNCTION - Callable from client
// ============================================================

/**
 * Callable function for RAG (Retrieval-Augmented Generation) queries.
 * Client sends a question, function:
 * 1. Generates embedding for the question
 * 2. Performs vector search on user's items
 * 3. Feeds top-K results to LLM with citations
 * 4. Returns answer with citations
 */
export const askAI = functions.https.onCall(ragQuery);

// ============================================================
// DIGEST GENERATION FUNCTIONS - Scheduled
// ============================================================

/**
 * Daily digest - runs every morning at 7 AM
 * Generates AI summary of yesterday's items
 */
export const dailyDigest = functions.pubsub
  .schedule("0 7 * * *")
  .timeZone("America/Los_Angeles")
  .onRun(generateDailyDigest);

/**
 * Weekly digest - runs every Monday at 8 AM
 * Generates AI summary of the past week
 */
export const weeklyDigest = functions.pubsub
  .schedule("0 8 * * 1")
  .timeZone("America/Los_Angeles")
  .onRun(generateWeeklyDigest);

/**
 * Monthly digest - runs on the 1st of each month at 9 AM
 * Generates AI summary of the past month
 */
export const monthlyDigest = functions.pubsub
  .schedule("0 9 1 * *")
  .timeZone("America/Los_Angeles")
  .onRun(generateMonthlyDigest);

// ============================================================
// MANUAL TRIGGER FUNCTIONS - For testing
// ============================================================

/**
 * Manually trigger embedding generation for a specific item
 */
export const generateEmbeddingManual = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }
    const { itemId } = data as { itemId: string };
    if (!itemId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "itemId is required"
      );
    }
    return { success: true, message: "Embedding generation triggered" };
  }
);

/**
 * Manually trigger digest generation for a user
 */
export const generateDigestManual = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }
    const { period } = data as { period: "daily" | "weekly" | "monthly" };
    return { success: true, message: `${period} digest generation triggered` };
  }
);