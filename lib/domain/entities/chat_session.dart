// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'chat_message.dart';

/// Chat session entity - Represents a conversation session
class ChatSession {
  const ChatSession({
    required this.id,
    required this.userId,
    required this.title,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.messageCount = 0,
    this.isPinned = false,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier
  final String id;

  /// Owner user ID
  final String userId;

  /// Session title (first user message or custom)
  final String title;

  /// Last message preview
  final String? lastMessagePreview;

  /// Last message timestamp
  final DateTime? lastMessageAt;

  /// Total message count
  final int messageCount;

  /// Whether session is pinned
  final bool isPinned;

  /// Additional metadata
  final Map<String, dynamic> metadata;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Create a copy with updated fields
  ChatSession copyWith({
    String? id,
    String? userId,
    String? title,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? messageCount,
    bool? isPinned,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
      isPinned: isPinned ?? this.isPinned,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create from JSON (for API/serialization)
  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      messageCount: json['messageCount'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'lastMessagePreview': lastMessagePreview,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'messageCount': messageCount,
      'isPinned': isPinned,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          lastMessagePreview == other.lastMessagePreview &&
          lastMessageAt == other.lastMessageAt &&
          messageCount == other.messageCount &&
          isPinned == other.isPinned &&
          _mapEquals(metadata, other.metadata) &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        title,
        lastMessagePreview,
        lastMessageAt,
        messageCount,
        isPinned,
        metadata,
        createdAt,
        updatedAt,
      ]);

  @override
  String toString() => 'ChatSession(id: $id, title: $title)';
}

/// Alias for MessageRole to support ChatRole naming
typedef ChatRole = MessageRole;

/// Helper function for map equality
bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}