// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:lifeos/ai/ai_layer.dart';
import 'package:lifeos/ai/on_device_processor.dart';
import 'package:lifeos/ai/cloud_processor.dart' hide InferencePreference;
import 'package:lifeos/data/local/database/daos/item_dao.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/core/config/app_config.dart' hide InferencePreference;
import 'package:lifeos/ai/ai_models.dart';

/// On-device processor provider
final onDeviceProcessorProvider = Provider<OnDeviceProcessor>((ref) {
  final processor = OnDeviceProcessor();
  ref.onDispose(() => processor.dispose());
  return processor;
});

/// Cloud processor provider
final cloudProcessorProvider = Provider<CloudProcessor>((ref) {
  final processor = CloudProcessor();
  ref.onDispose(() => processor.dispose());
  return processor;
});

/// Hybrid AI router provider
final hybridRouterProvider = Provider<HybridAIRouter>((ref) {
  final onDevice = ref.watch(onDeviceProcessorProvider);
  final cloud = ref.watch(cloudProcessorProvider);
  return HybridAIRouter(
    onDeviceProcessor: onDevice,
    cloudProcessor: cloud,
  );
});

/// Embedding engine provider
final embeddingEngineProvider = Provider<EmbeddingEngine>((ref) {
  final onDevice = ref.watch(onDeviceProcessorProvider);
  final cloud = ref.watch(cloudProcessorProvider);
  return EmbeddingEngine(
    onDeviceProcessor: onDevice,
    cloudProcessor: cloud,
  );
});

/// RAG service provider
final ragServiceProvider = Provider<RAGService>((ref) {
  final router = ref.watch(hybridRouterProvider);
  final embeddingEngine = ref.watch(embeddingEngineProvider);
  final itemDao = ref.watch(itemDaoProvider);
  return RAGService(
    router: router,
    embeddingEngine: embeddingEngine,
    itemDao: itemDao,
  );
});

/// Inference preference notifier
class InferencePreferenceNotifier extends Notifier<InferencePreference> {
  @override
  InferencePreference build() => InferencePreference.auto;

  void setPreference(InferencePreference preference) {
    state = preference;
  }
}

/// Inference preference provider (user configurable)
final inferencePreferenceProvider =
    NotifierProvider<InferencePreferenceNotifier, InferencePreference>(
        InferencePreferenceNotifier.new);

/// AI initialization provider (initializes all AI components)
final aiInitializationProvider = FutureProvider<void>((ref) async {
  // Initialize on-device processor
  final onDevice = ref.watch(onDeviceProcessorProvider);
  await onDevice.initialize();

  // Initialize cloud processor
  final cloud = ref.watch(cloudProcessorProvider);
  await cloud.initialize();

  // Initialize embedding engine
  final embeddingEngine = ref.watch(embeddingEngineProvider);
  await embeddingEngine.initialize();
});
