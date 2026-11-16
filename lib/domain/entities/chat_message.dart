// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'enums.dart';

/// Chat message entity for RAG conversations
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    this.userId = 'anonymous',
    required this.timestamp,
    this.source = InferenceSource.hybrid,
    this.citations = const [],
    this.metadata = const {},
    this.isStreaming = false,
    this.error,
  });

  /// Unique identifier
  final String id;

  /// Owner user ID
  final String userId;

  /// Session/conversation ID
  final String sessionId;

  /// Message role
  final MessageRole role;

  /// Message content
  final String content;

  /// Timestamp (UTC)
  final DateTime timestamp;

  /// AI inference source
  final InferenceSource source;

  /// AI inference source (alias for source)
  InferenceSource get inferenceSource => source;

  /// Timestamp (UTC) (alias for timestamp)
  DateTime get createdAt => timestamp;

  /// Source citations
  final List<Citation> citations;

  /// Additional metadata (tokens used, latency, etc.)
  final Map<String, dynamic> metadata;

  /// Whether this message is still streaming
  final bool isStreaming;

  /// Error message if generation failed
  final String? error;

  /// Create a copy with updated fields
  ChatMessage copyWith({
    String? id,
    String? userId,
    String? sessionId,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    InferenceSource? source,
    List<Citation>? citations,
    Map<String, dynamic>? metadata,
    bool? isStreaming,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      citations: citations ?? this.citations,
      metadata: metadata ?? this.metadata,
      isStreaming: isStreaming ?? this.isStreaming,
      error: error ?? this.error,
    );
  }

  /// Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      userId: json['userId'] as String,
      sessionId: json['sessionId'] as String,
      role: MessageRole.values.byName(json['role'] as String),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      source:
          InferenceSource.values.byName(json['source'] as String? ?? 'hybrid'),
      citations: (json['citations'] as List<dynamic>?)
              ?.map((e) => Citation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      isStreaming: json['isStreaming'] as bool? ?? false,
      error: json['error'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sessionId': sessionId,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'source': source.name,
      'citations': citations.map((e) => e.toJson()).toList(),
      'metadata': metadata,
      'isStreaming': isStreaming,
      'error': error,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          sessionId == other.sessionId &&
          role == other.role &&
          content == other.content &&
          timestamp == other.timestamp &&
          source == other.source &&
          citations == other.citations &&
          _mapEquals(metadata, other.metadata) &&
          isStreaming == other.isStreaming &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        sessionId,
        role,
        content,
        timestamp,
        source,
        citations,
        metadata,
        isStreaming,
        error,
      );

  @override
  String toString() =>
      'ChatMessage(id: $id, role: $role, content: ${content.substring(0, 30)}...)';
}

/// Message role
enum MessageRole { user, assistant, system }

/// Citation for RAG responses
class Citation {
  const Citation({
    required this.itemId,
    required this.title,
    required this.snippet,
    this.score,
    this.metadata = const {},
  });

  /// Referenced item ID
  final String itemId;

  /// Item title
  final String title;

  /// Relevant snippet
  final String snippet;

  /// Relevance score (0-1)
  final double? score;

  /// Additional metadata
  final Map<String, dynamic> metadata;

  factory Citation.fromJson(Map<String, dynamic> json) {
    return Citation(
      itemId: json['itemId'] as String,
      title: json['title'] as String,
      snippet: json['snippet'] as String,
      score: (json['score'] as num?)?.toDouble(),
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'title': title,
      'snippet': snippet,
      'score': score,
      'metadata': metadata,
    };
  }
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
