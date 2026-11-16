// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/services.dart';

/// Data model for shared items from share extension
class SharedItem {
  final String? text;
  final String? url;
  final String? imagePath;
  final String? fileURL;
  final String type; // note, link, task, image, pdf, file
  final DateTime timestamp;
  final String source;

  SharedItem({
    this.text,
    this.url,
    this.imagePath,
    this.fileURL,
    required this.type,
    required this.timestamp,
    required this.source,
  });

  factory SharedItem.fromMap(Map<String, dynamic> map) {
    return SharedItem(
      text: map['text'] as String?,
      url: map['url'] as String?,
      imagePath: map['imagePath'] as String?,
      fileURL: map['fileURL'] as String?,
      type: map['type'] as String? ?? 'note',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        ((map['timestamp'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch),
      ),
      source: map['source'] as String? ?? 'share_extension',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'url': url,
      'imagePath': imagePath,
      'fileURL': fileURL,
      'type': type,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'source': source,
    };
  }
}

/// Platform channel for share extension communication
class ShareExtensionChannel {
  static const MethodChannel _channel = MethodChannel('com.lifeos.app/share_extension');

  /// Get all pending shared items from the share extension
  /// Returns a list of shared items and clears the shared storage
  static Future<List<SharedItem>> getPendingSharedItems() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getPendingSharedItems');
      return result.map((e) => SharedItem.fromMap(Map<String, dynamic>.from(e))).toList();
    } on PlatformException catch (e) {
      // Log error but return empty list to not block app startup
      print('ShareExtensionChannel: Failed to get shared items: ${e.message}');
      return [];
    }
  }

  /// Check if there are pending shared items (without retrieving them)
  static Future<bool> hasPendingSharedItems() async {
    try {
      final bool result = await _channel.invokeMethod('hasPendingSharedItems');
      return result;
    } on PlatformException catch (e) {
      print('ShareExtensionChannel: Failed to check pending items: ${e.message}');
      return false;
    }
  }

  /// Clear all pending shared items
  static Future<void> clearPendingSharedItems() async {
    try {
      await _channel.invokeMethod('clearPendingSharedItems');
    } on PlatformException catch (e) {
      print('ShareExtensionChannel: Failed to clear shared items: ${e.message}');
    }
  }
}
