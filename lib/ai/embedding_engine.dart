// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'ai_models.dart';
import 'on_device_processor.dart';
import 'cloud_processor.dart';

/// Embedding engine for vector search using sqlite-vec
/// Supports both on-device (Transformers.js / MediaPipe) and cloud embeddings
class EmbeddingEngine {
  EmbeddingEngine({
    required OnDeviceProcessor onDeviceProcessor,
    required CloudProcessor cloudProcessor,
    this.defaultModel = AIModel.allMiniLML6v2,
    this.dimensions = 384,
  })  : _onDevice = onDeviceProcessor,
        _cloud = cloudProcessor;

  final OnDeviceProcessor _onDevice;
  final CloudProcessor _cloud;
  final AIModel defaultModel;
  final int dimensions;

  bool _initialized = false;

  /// Initialize the embedding engine
  Future<void> initialize() async {
    if (_initialized) return;

    // Try on-device first, fallback to cloud
    try {
      await _onDevice.initialize();
    } catch (_) {
      // On-device not available, will use cloud
    }

    try {
      await _cloud.initialize();
    } catch (_) {
      // Cloud not available
    }

    if (!_onDevice.isAvailable && !_cloud.isAvailable) {
      throw Exception('No embedding provider available');
    }

    _initialized = true;
  }

  /// Generate embedding for a single text
  Future<List<double>> embed(
    String text, {
    AIModel? model,
    InferencePreference preference = InferencePreference.auto,
  }) async {
    await initialize();

    final effectiveModel = model ?? defaultModel;

    switch (preference) {
      case InferencePreference.forceOnDevice:
        return _onDevice.embed(text);
      case InferencePreference.forceCloud:
        return _cloud.embed(text, model: effectiveModel);
      case InferencePreference.preferOnDevice:
        try {
          return await _onDevice.embed(text);
        } catch (_) {
          return _cloud.embed(text, model: effectiveModel);
        }
      case InferencePreference.preferCloud:
        try {
          return await _cloud.embed(text, model: effectiveModel);
        } catch (_) {
          return _onDevice.embed(text);
        }
      case InferencePreference.auto:
        if (_onDevice.isAvailable) {
          try {
            return await _onDevice.embed(text);
          } catch (_) {
            return _cloud.embed(text, model: effectiveModel);
          }
        }
        return _cloud.embed(text, model: effectiveModel);
    }
  }

  /// Generate embeddings for multiple texts (batch)
  Future<List<List<double>>> embedBatch(
    List<String> texts, {
    AIModel? model,
    InferencePreference preference = InferencePreference.auto,
  }) async {
    await initialize();

    final effectiveModel = model ?? defaultModel;

    switch (preference) {
      case InferencePreference.forceOnDevice:
        return _onDevice.embedBatch(texts);
      case InferencePreference.forceCloud:
        return _cloud.embedBatch(texts, model: effectiveModel);
      case InferencePreference.preferOnDevice:
        try {
          return await _onDevice.embedBatch(texts);
        } catch (_) {
          return _cloud.embedBatch(texts, model: effectiveModel);
        }
      case InferencePreference.preferCloud:
        try {
          return await _cloud.embedBatch(texts, model: effectiveModel);
        } catch (_) {
          return _onDevice.embedBatch(texts);
        }
      case InferencePreference.auto:
        if (_onDevice.isAvailable) {
          try {
            return await _onDevice.embedBatch(texts);
          } catch (_) {
            return _cloud.embedBatch(texts, model: effectiveModel);
          }
        }
        return _cloud.embedBatch(texts, model: effectiveModel);
    }
  }

  /// Compute cosine similarity between two embeddings
  static double cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must have same dimension');
    }

    double dotProduct = 0;
    double normA = 0;
    double normB = 0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) return 0;

    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }

  /// Find top-k most similar vectors from a list
  static List<int> topKSimilar(
    List<double> query,
    List<List<double>> candidates, {
    int k = 10,
    double minSimilarity = 0.0,
  }) {
    final similarities = <int, double>{};

    for (int i = 0; i < candidates.length; i++) {
      final sim = cosineSimilarity(query, candidates[i]);
      if (sim >= minSimilarity) {
        similarities[i] = sim;
      }
    }

    // Sort by similarity descending
    final sorted = similarities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(k).map((e) => e.key).toList();
  }

  /// Normalize embedding to unit length
  static List<double> normalize(List<double> embedding) {
    final norm = math.sqrt(embedding.fold(0.0, (sum, v) => sum + v * v));
    if (norm == 0) return embedding;
    return embedding.map((v) => v / norm).toList();
  }

  /// Chunk text for embedding (respects token limits)
  static List<String> chunkText(
    String text, {
    int maxTokens = 256,
    int overlap = 50,
  }) {
    // Rough token estimation: 1 token ≈ 4 chars
    final maxChars = maxTokens * 4;
    final overlapChars = overlap * 4;

    if (text.length <= maxChars) return [text];

    final chunks = <String>[];
    int start = 0;

    while (start < text.length) {
      int end = start + maxChars;
      if (end > text.length) end = text.length;

      // Try to break at sentence boundary
      if (end < text.length) {
        final lastPeriod = text.lastIndexOf('.', end);
        final lastNewline = text.lastIndexOf('\n', end);
        final breakPoint = math.max(lastPeriod, lastNewline);
        if (breakPoint > start + maxChars ~/ 2) {
          end = breakPoint + 1;
        }
      }

      chunks.add(text.substring(start, end).trim());
      start = end - overlapChars;
      if (start < 0) start = 0;
    }

    return chunks;
  }

  /// Get embedding dimensions for a model
  int getDimensions(AIModel model) {
    return modelCapabilities[model]?.maxOutputTokens ?? dimensions;
  }

  Future<void> dispose() async {
    await _onDevice.dispose();
    await _cloud.dispose();
    _initialized = false;
  }
}
