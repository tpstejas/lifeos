// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/ai/ai_models.dart';
import 'package:lifeos/domain/entities/enums.dart';

/// On-device AI processor using MediaPipe Tasks / Transformers.js
class OnDeviceProcessor {
  OnDeviceProcessor();

  bool _initialized = false;
  String? _error;

  bool get isAvailable => _initialized && _error == null;

  String? get lastError => _error;

  /// Initialize on-device models
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // TODO: Initialize MediaPipe Tasks GenAI
      // - Load Gemini Nano model from assets
      // - Initialize Transformers.js for embeddings
      // - Load all-MiniLM-L6-v2 for embeddings

      _initialized = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _initialized = false;
    }
  }

  /// Process request on-device
  Future<AIResponse> process(AIRequest request) async {
    await initialize();

    if (!isAvailable) {
      throw Exception('On-device AI not available: $_error');
    }

    final model = request.model ?? AIModel.geminiNanoText;
    final capabilities = modelCapabilities[model]!;

    // Validate request against model capabilities
    if (request.prompt.length > capabilities.maxContextTokens * 4) {
      throw Exception('Prompt too long for on-device model');
    }

    // TODO: Actual inference with MediaPipe Tasks
    // For now, return mock response
    await Future.delayed(const Duration(milliseconds: 500));

    return AIResponse(
      content: '[On-Device] ${_generateMockResponse(request.prompt)}',
      model: model,
      source: InferenceSource.onDevice,
      finishReason: 'stop',
      usage: AIUsage(
        promptTokens: request.prompt.length ~/ 4,
        completionTokens: 100,
        totalTokens: (request.prompt.length ~/ 4) + 100,
      ),
    );
  }

  /// Stream response on-device
  Stream<String> stream(AIRequest request) async* {
    await initialize();

    if (!isAvailable) {
      throw Exception('On-device AI not available: $_error');
    }

    // TODO: Actual streaming with MediaPipe Tasks
    // For now, yield mock response in chunks
    final response = _generateMockResponse(request.prompt);
    final words = response.split(' ');

    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 50));
      yield '$word ';
    }
  }

  /// Generate embeddings on-device
  Future<List<double>> embed(String text) async {
    await initialize();

    if (!isAvailable) {
      throw Exception('On-device AI not available: $_error');
    }

    // TODO: Actual embedding with Transformers.js / all-MiniLM-L6-v2
    // For now, return mock embedding (384 dims)
    await Future.delayed(const Duration(milliseconds: 100));

    return List.generate(
        384, (i) => (i * 0.01 + text.hashCode * 0.001).toDouble());
  }

  /// Generate embeddings for multiple texts
  Future<List<List<double>>> embedBatch(List<String> texts) async {
    final embeddings = <List<double>>[];
    for (final text in texts) {
      embeddings.add(await embed(text));
    }
    return embeddings;
  }

  String _generateMockResponse(String prompt) {
    if (prompt.toLowerCase().contains('summary') ||
        prompt.toLowerCase().contains('summarize')) {
      return 'This is a mock summary generated on-device. The actual implementation would use Gemini Nano to summarize your content.';
    }
    if (prompt.toLowerCase().contains('task') ||
        prompt.toLowerCase().contains('todo')) {
      return 'Here are the tasks extracted from your content: 1. Review the document 2. Create action items 3. Set deadlines.';
    }
    return 'On-device response: I understand your request about "${prompt.substring(0, 30)}...". This is a mock response from Gemini Nano running locally on your device.';
  }

  /// Release resources
  Future<void> dispose() async {
    // TODO: Release MediaPipe resources
    _initialized = false;
  }
}
