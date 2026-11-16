// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/domain/entities/enums.dart';

/// AI model configuration
enum AIModel {
  /// On-device: Gemini Nano (text)
  geminiNanoText('gemini-nano-text', 'On-Device Text', true, false, 2048),

  /// On-device: Gemini Nano (multimodal)
  geminiNanoMultimodal(
      'gemini-nano-multimodal', 'On-Device Multimodal', true, false, 4096),

  /// Cloud: Gemini 1.5 Flash
  gemini15Flash('gemini-1.5-flash', 'Gemini 1.5 Flash', false, true, 1000000),

  /// Cloud: Gemini 1.5 Pro
  gemini15Pro('gemini-1.5-pro', 'Gemini 1.5 Pro', false, true, 2000000),

  /// Cloud: Gemini 2.0 Flash
  gemini20Flash('gemini-2.0-flash', 'Gemini 2.0 Flash', false, true, 1000000),

  /// Embedding: all-MiniLM-L6-v2 (384 dim)
  allMiniLML6v2('all-MiniLM-L6-v2', 'MiniLM L6 v2', true, false, 512),

  /// Embedding: BGE-small (384 dim)
  bgeSmall('bge-small-en-v1.5', 'BGE Small', true, false, 512);

  const AIModel(
    this.id,
    this.displayName,
    this.isOnDevice,
    this.isCloud,
    this.maxTokens,
  );

  final String id;
  final String displayName;
  final bool isOnDevice;
  final bool isCloud;
  final int maxTokens;
}

/// Inference preference
enum InferencePreference {
  /// Automatically choose best option
  auto,

  /// Prefer on-device, fallback to cloud
  preferOnDevice,

  /// Prefer cloud, fallback to on-device
  preferCloud,

  /// Force on-device only (privacy mode)
  forceOnDevice,

  /// Force cloud only (max capability)
  forceCloud,
}

/// AI request
class AIRequest {
  const AIRequest({
    required this.prompt,
    this.systemPrompt,
    this.context,
    this.model,
    this.temperature = 0.7,
    this.maxTokens,
    this.stream = false,
    this.metadata = const {},
  });

  final String prompt;
  final String? systemPrompt;
  final List<AIMessage>? context;
  final AIModel? model;
  final double temperature;
  final int? maxTokens;
  final bool stream;
  final Map<String, dynamic> metadata;
}

/// AI message
class AIMessage {
  const AIMessage({
    required this.role,
    required this.content,
    this.metadata = const {},
  });

  final AIMessageRole role;
  final String content;
  final Map<String, dynamic> metadata;
}

/// AI message role
enum AIMessageRole { system, user, assistant, tool }

/// AI response
class AIResponse {
  const AIResponse({
    required this.content,
    required this.model,
    required this.source,
    this.finishReason,
    this.usage,
    this.metadata = const {},
  });

  final String content;
  final AIModel model;
  final InferenceSource source;
  final String? finishReason;
  final AIUsage? usage;
  final Map<String, dynamic> metadata;
}

/// AI usage statistics
class AIUsage {
  const AIUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
}

/// AI capabilities
class AICapabilities {
  const AICapabilities({
    required this.supportsText,
    required this.supportsImages,
    required this.supportsAudio,
    required this.supportsVideo,
    required this.supportsStreaming,
    required this.supportsFunctionCalling,
    required this.maxContextTokens,
    required this.maxOutputTokens,
  });

  final bool supportsText;
  final bool supportsImages;
  final bool supportsAudio;
  final bool supportsVideo;
  final bool supportsStreaming;
  final bool supportsFunctionCalling;
  final int maxContextTokens;
  final int maxOutputTokens;
}

/// Model capabilities mapping
final Map<AIModel, AICapabilities> modelCapabilities = {
  AIModel.geminiNanoText: const AICapabilities(
    supportsText: true,
    supportsImages: false,
    supportsAudio: false,
    supportsVideo: false,
    supportsStreaming: true,
    supportsFunctionCalling: false,
    maxContextTokens: 2048,
    maxOutputTokens: 1024,
  ),
  AIModel.geminiNanoMultimodal: const AICapabilities(
    supportsText: true,
    supportsImages: true,
    supportsAudio: false,
    supportsVideo: false,
    supportsStreaming: true,
    supportsFunctionCalling: false,
    maxContextTokens: 4096,
    maxOutputTokens: 2048,
  ),
  AIModel.gemini15Flash: const AICapabilities(
    supportsText: true,
    supportsImages: true,
    supportsAudio: true,
    supportsVideo: true,
    supportsStreaming: true,
    supportsFunctionCalling: true,
    maxContextTokens: 1000000,
    maxOutputTokens: 8192,
  ),
  AIModel.gemini15Pro: const AICapabilities(
    supportsText: true,
    supportsImages: true,
    supportsAudio: true,
    supportsVideo: true,
    supportsStreaming: true,
    supportsFunctionCalling: true,
    maxContextTokens: 2000000,
    maxOutputTokens: 8192,
  ),
  AIModel.gemini20Flash: const AICapabilities(
    supportsText: true,
    supportsImages: true,
    supportsAudio: true,
    supportsVideo: true,
    supportsStreaming: true,
    supportsFunctionCalling: true,
    maxContextTokens: 1000000,
    maxOutputTokens: 8192,
  ),
  AIModel.allMiniLML6v2: const AICapabilities(
    supportsText: true,
    supportsImages: false,
    supportsAudio: false,
    supportsVideo: false,
    supportsStreaming: false,
    supportsFunctionCalling: false,
    maxContextTokens: 512,
    maxOutputTokens: 384,
  ),
  AIModel.bgeSmall: const AICapabilities(
    supportsText: true,
    supportsImages: false,
    supportsAudio: false,
    supportsVideo: false,
    supportsStreaming: false,
    supportsFunctionCalling: false,
    maxContextTokens: 512,
    maxOutputTokens: 384,
  ),
};
