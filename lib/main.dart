// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide UncontrolledProviderScope;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/config/app_config.dart';
import 'core/di/providers.dart';
import 'core/platform/share_extension_service.dart';
import 'core/utils/logger.dart';
import 'data/remote/auth_service.dart';
import 'firebase_options.dart';
import 'presentation/app_router.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize app configuration
  await AppConfig.initialize();

  // Create a temporary ProviderScope to process shared items before the app runs
  final container = ProviderContainer();
  try {
    final shareService = container.read(shareExtensionServiceProvider);
    final processedCount = await shareService.processPendingSharedItems();
    if (processedCount > 0) {
      AppLogger.i('Processed $processedCount shared items from share extension');
    }

    // Auto-sign in anonymously for guest access (no login required)
    final authService = container.read(authServiceProvider);
    try {
      await authService.signInAnonymously();
      AppLogger.i('Auto-signed in anonymously for guest access');
    } catch (e) {
      AppLogger.e('Anonymous sign-in failed, continuing without auth', error: e);
    }
  } catch (e) {
    AppLogger.e('Failed to process shared items', error: e);
  } finally {
    container.dispose();
  }

  // Run the app with Riverpod ProviderScope
  runApp(
    ProviderScope(
      overrides: [
        // Override providers for testing or different environments if needed
      ],
      child: const LifeOSApp(),
    ),
  );
}

/// Main application widget
class LifeOSApp extends ConsumerWidget {
  const LifeOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'LifeOS',
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          // Prevent system font scaling from breaking layout
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
