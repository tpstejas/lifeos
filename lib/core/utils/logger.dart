// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// Application logger with different log levels
class AppLogger {
  static bool _initialized = false;
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  static void init({LogLevel minLevel = LogLevel.debug}) {
    _initialized = true;
    _minLevel = minLevel;
    debugPrint('📋 AppLogger initialized with min level: ${minLevel.name}');
  }

  static void _log(LogLevel level, String message,
      {Object? error, StackTrace? stackTrace, String? tag}) {
    if (!_initialized || level.index < _minLevel.index) return;

    final prefix = _getPrefix(level);
    final tagStr = tag != null ? '[$tag] ' : '';
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);

    final output = '$prefix $timestamp $tagStr$message';

    switch (level) {
      case LogLevel.verbose:
      case LogLevel.debug:
        debugPrint(output);
        break;
      case LogLevel.info:
        debugPrint(output);
        break;
      case LogLevel.warning:
        debugPrint(output);
        break;
      case LogLevel.error:
        debugPrint(output);
        if (error != null) debugPrint('  ⛔ Error: $error');
        if (stackTrace != null) debugPrint('  📍 Stack: $stackTrace');
        break;
    }
  }

  static String _getPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return '🔍 VERBOSE';
      case LogLevel.debug:
        return '🐛 DEBUG';
      case LogLevel.info:
        return 'ℹ️ INFO';
      case LogLevel.warning:
        return '⚠️ WARN';
      case LogLevel.error:
        return '❌ ERROR';
    }
  }

  static void v(String message, {String? tag}) =>
      _log(LogLevel.verbose, message, tag: tag);

  static void d(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag: tag);

  static void i(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag: tag);

  static void w(String message, {String? tag}) =>
      _log(LogLevel.warning, message, tag: tag);

  static void e(String message,
          {Object? error, StackTrace? stackTrace, String? tag}) =>
      _log(LogLevel.error, message,
          error: error, stackTrace: stackTrace, tag: tag);

  // Convenience methods for common tags
  static void ai(String message, {Object? error, StackTrace? stackTrace}) =>
      d(message, tag: 'AI');

  static void sync(String message, {Object? error, StackTrace? stackTrace}) =>
      i(message, tag: 'SYNC');

  static void storage(String message,
          {Object? error, StackTrace? stackTrace}) =>
      d(message, tag: 'STORAGE');

  static void network(String message,
          {Object? error, StackTrace? stackTrace}) =>
      d(message, tag: 'NETWORK');

  static void ui(String message, {Object? error, StackTrace? stackTrace}) =>
      d(message, tag: 'UI');

  static void auth(String message, {Object? error, StackTrace? stackTrace}) =>
      i(message, tag: 'AUTH');

  static void notification(String message,
          {Object? error, StackTrace? stackTrace}) =>
      i(message, tag: 'NOTIF');
}

enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}

/// Performance timer for measuring operation duration
class PerfTimer {
  final String name;
  final Stopwatch _stopwatch = Stopwatch();

  PerfTimer(this.name) {
    _stopwatch.start();
    AppLogger.d('⏱️ Started: $name', tag: 'PERF');
  }

  void stop({String? additionalInfo}) {
    _stopwatch.stop();
    final elapsed = _stopwatch.elapsedMilliseconds;
    final info = additionalInfo != null ? ' ($additionalInfo)' : '';
    AppLogger.d('⏱️ Finished: $name in ${elapsed}ms$info', tag: 'PERF');
  }

  int get elapsedMs => _stopwatch.elapsedMilliseconds;
}

/// Mixin for classes that want structured logging
mixin LoggerMixin {
  String get logTag => runtimeType.toString();

  void logV(String message) => AppLogger.v(message, tag: logTag);
  void logD(String message) => AppLogger.d(message, tag: logTag);
  void logI(String message) => AppLogger.i(message, tag: logTag);
  void logW(String message) => AppLogger.w(message, tag: logTag);
  void logE(String message, {Object? error, StackTrace? stackTrace}) =>
      AppLogger.e(message, error: error, stackTrace: stackTrace, tag: logTag);
}
