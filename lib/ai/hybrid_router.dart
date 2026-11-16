// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'ai_models.dart';
import 'on_device_processor.dart';
import 'cloud_processor.dart';

/// Hybrid AI Router - Routes requests between on-device and cloud
class HybridAIRouter {
  HybridAIRouter({
    required OnDeviceProcessor onDeviceProcessor,
    required CloudProcessor cloudProcessor,
  })  : _onDevice = onDeviceProcessor,
        _cloud = cloudProcessor;

  final OnDeviceProcessor _onDevice;
  final CloudProcessor _cloud;

  /// Process request based on inference preference
  Future<AIResponse> process(
      AIRequest request, InferencePreference preference) async {
    final model = request.model ?? _selectModel(request, preference);

    switch (preference) {
      case InferencePreference.forceOnDevice:
        return _onDevice.process(request.copyWith(model: model));
      case InferencePreference.forceCloud:
        return _cloud.process(request.copyWith(model: model));
      case InferencePreference.preferOnDevice:
        return _tryOnDeviceFirst(request, model);
      case InferencePreference.preferCloud:
        return _tryCloudFirst(request, model);
      case InferencePreference.auto:
        return _autoRoute(request, model);
    }
  }

  /// Stream response
  Stream<String> stream(
      AIRequest request, InferencePreference preference) async* {
    final model = request.model ?? _selectModel(request, preference);

    switch (preference) {
      case InferencePreference.forceOnDevice:
        yield* _onDevice.stream(request.copyWith(model: model));
      case InferencePreference.forceCloud:
        yield* _cloud.stream(request.copyWith(model: model));
      case InferencePreference.preferOnDevice:
        try {
          yield* _onDevice.stream(request.copyWith(model: model));
        } catch (_) {
          yield* _cloud.stream(request.copyWith(model: model));
        }
      case InferencePreference.preferCloud:
        try {
          yield* _cloud.stream(request.copyWith(model: model));
        } catch (_) {
          yield* _onDevice.stream(request.copyWith(model: model));
        }
      case InferencePreference.auto:
        try {
          yield* _onDevice.stream(request.copyWith(model: model));
        } catch (_) {
          yield* _cloud.stream(request.copyWith(model: model));
        }
    }
  }

  AIModel _selectModel(AIRequest request, InferencePreference preference) {
    // If model explicitly specified, use it
    if (request.model != null) return request.model!;

    // Select based on preference and request complexity
    final capabilities = modelCapabilities;

    if (preference == InferencePreference.forceOnDevice ||
        preference == InferencePreference.preferOnDevice) {
      // Check if on-device model can handle the request
      if (_canHandleOnDevice(request)) {
        return AIModel.geminiNanoMultimodal;
      }
    }

    // Default to cloud for complex requests
    return AIModel.gemini15Flash;
  }

  bool _canHandleOnDevice(AIRequest request) {
    // Check token count estimate
    var estimatedTokens = request.prompt.length ~/ 4;
    if (request.context != null) {
      for (final msg in request.context!) {
        estimatedTokens += msg.content.length ~/ 4;
      }
    }

    // On-device models have limited context
    return estimatedTokens < 1500;
  }

  Future<AIResponse> _tryOnDeviceFirst(AIRequest request, AIModel model) async {
    try {
      return await _onDevice.process(request.copyWith(model: model));
    } catch (e) {
      return _cloud.process(request.copyWith(model: AIModel.gemini15Flash));
    }
  }

  Future<AIResponse> _tryCloudFirst(AIRequest request, AIModel model) async {
    try {
      return await _cloud.process(request.copyWith(model: model));
    } catch (e) {
      return _onDevice.process(request.copyWith(model: AIModel.geminiNanoText));
    }
  }

  Future<AIResponse> _autoRoute(AIRequest request, AIModel model) async {
    // Simple heuristic: use on-device for short, simple requests
    final estimatedTokens = request.prompt.length ~/ 4;
    final isComplex = estimatedTokens > 1000 ||
        request.systemPrompt != null ||
        (request.context?.length ?? 0) > 5;

    if (!isComplex && _onDevice.isAvailable) {
      return _onDevice.process(request.copyWith(model: AIModel.geminiNanoText));
    }

    return _cloud.process(request.copyWith(model: AIModel.gemini15Flash));
  }
}

/// Extension to add copyWith to AIRequest
extension AIRequestX on AIRequest {
  AIRequest copyWith({
    String? prompt,
    String? systemPrompt,
    List<AIMessage>? context,
    AIModel? model,
    double? temperature,
    int? maxTokens,
    bool? stream,
    Map<String, dynamic>? metadata,
  }) {
    return AIRequest(
      prompt: prompt ?? this.prompt,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      context: context ?? this.context,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      stream: stream ?? this.stream,
      metadata: metadata ?? this.metadata,
    );
  }
}
