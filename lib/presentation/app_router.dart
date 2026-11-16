// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Re-exports the app router provider for main.dart compatibility
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/di/providers.dart';

/// Export the appRouterProvider for convenience
export 'package:lifeos/core/di/providers.dart' show appRouterProvider;

/// App router instance - delegates to the provider in providers.dart
/// This file exists for backwards compatibility with main.dart imports.
GoRouter createAppRouter() {
  // This is a placeholder - the actual router is created via appRouterProvider
  // which requires a ProviderContainer/Ref. In main.dart, we use ref.watch(appRouterProvider)
  // instead of importing a static router.
  throw UnimplementedError('Use ref.watch(appRouterProvider) in main.dart');
}
