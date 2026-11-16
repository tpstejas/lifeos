// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Application configuration manager
/// Handles environment-specific settings, feature flags, and user preferences
class AppConfig {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyInferencePreference = 'inference_preference';
  static const String _keySyncEnabled = 'sync_enabled';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  static SharedPreferences? _prefs;

  // Environment configuration
  static const bool isDebug = kDebugMode;
  static const bool isProfile = kProfileMode;
  static const bool isRelease = kReleaseMode;

  // Feature flags
  static const bool enableOnDeviceAI = true;
  static const bool enableCloudAI = true;
  static const bool enableHybridRouting = true;
  static const bool enableDigests = true;
  static const bool enableNotifications = true;
  static const bool enableShareExtension = true;
  static const bool enableOfflineMode = true;

  // API Configuration
  static const String firebaseAiLogicRegion = 'us-central1';
  static const int defaultEmbeddingDimension = 384; // For on-device embeddings
  static const int maxLocalItems = 10000;
  static const int maxEmbeddingCacheSize = 5000;

  // Sync Configuration
  static const Duration syncInterval = Duration(minutes: 15);
  static const Duration backgroundSyncInterval = Duration(hours: 1);
  static const int maxSyncBatchSize = 100;
  static const int maxRetryAttempts = 3;
  static const Duration retryBaseDelay = Duration(seconds: 2);

  // Notification Configuration
  static const String dailyDigestChannelId = 'daily_digest';
  static const String deadlineAlertChannelId = 'deadline_alerts';
  static const String followUpChannelId = 'follow_ups';
  static const String opportunityChannelId = 'opportunities';

  // AI Model Configuration
  static const String onDeviceModelName = 'gemini-nano';
  static const String cloudModelName = 'gemini-1.5-flash';
  static const String cloudProModelName = 'gemini-1.5-pro';
  static const int maxOnDeviceTokens = 2048;
  static const int maxCloudTokens = 8192;

  // Storage Configuration
  static const int maxCacheSizeBytes = 100 * 1024 * 1024; // 100MB
  static const int maxFileSizeBytes = 50 * 1024 * 1024; // 50MB
  static const Duration fileCacheExpiry = Duration(days: 30);

  // Initialize configuration
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    // Set defaults for first launch
    if (_prefs!.getBool(_keyFirstLaunch) ?? true) {
      await _setDefaults();
      await _prefs!.setBool(_keyFirstLaunch, false);
    }
  }

  static Future<void> _setDefaults() async {
    await _prefs!.setString(_keyThemeMode, ThemeMode.system.name);
    await _prefs!.setString(
      _keyInferencePreference,
      InferencePreference.auto.name,
    );
    await _prefs!.setBool(_keySyncEnabled, true);
    await _prefs!.setBool(_keyNotificationsEnabled, true);
    await _prefs!.setBool(_keyBiometricEnabled, false);
    await _prefs!.setBool(_keyOnboardingCompleted, false);
  }

  // Theme Mode
  static ThemeMode get themeMode {
    final value = _prefs?.getString(_keyThemeMode) ?? ThemeMode.system.name;
    return ThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs?.setString(_keyThemeMode, mode.name);
  }

  // Inference Preference
  static InferencePreference get inferencePreference {
    final value = _prefs?.getString(_keyInferencePreference) ??
        InferencePreference.auto.name;
    return InferencePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InferencePreference.auto,
    );
  }

  static Future<void> setInferencePreference(InferencePreference pref) async {
    await _prefs?.setString(_keyInferencePreference, pref.name);
  }

  // Sync Enabled
  static bool get syncEnabled => _prefs?.getBool(_keySyncEnabled) ?? true;

  static Future<void> setSyncEnabled(bool enabled) async {
    await _prefs?.setBool(_keySyncEnabled, enabled);
  }

  // Notifications Enabled
  static bool get notificationsEnabled =>
      _prefs?.getBool(_keyNotificationsEnabled) ?? true;

  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs?.setBool(_keyNotificationsEnabled, enabled);
  }

  // Biometric Enabled
  static bool get biometricEnabled =>
      _prefs?.getBool(_keyBiometricEnabled) ?? false;

  static Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs?.setBool(_keyBiometricEnabled, enabled);
  }

  // Onboarding
  static bool get onboardingCompleted =>
      _prefs?.getBool(_keyOnboardingCompleted) ?? false;

  static Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs?.setBool(_keyOnboardingCompleted, completed);
  }

  // Clear all user data (for testing or logout)
  static Future<void> clearAll() async {
    await _prefs?.clear();
    await _setDefaults();
  }
}

/// Inference preference for hybrid AI routing
enum InferencePreference {
  /// Automatically choose based on complexity and availability
  auto,

  /// Prefer on-device, fallback to cloud
  preferOnDevice,

  /// Prefer cloud, fallback to on-device
  preferCloud,

  /// Force on-device only (privacy mode)
  forceOnDevice,

  /// Force cloud only (maximum capability)
  forceCloud,
}

/// Theme data for the app
class AppTheme {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  const AppTheme({
    required this.lightTheme,
    required this.darkTheme,
    required this.themeMode,
  });

  AppTheme copyWith({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    ThemeMode? themeMode,
  }) {
    return AppTheme(
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
