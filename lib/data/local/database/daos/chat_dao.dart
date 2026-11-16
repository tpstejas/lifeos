// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:drift/drift.dart';
import 'package:lifeos/data/local/database/app_database.dart';
import 'package:lifeos/domain/entities/chat_message.dart';
import 'package:lifeos/domain/entities/chat_session.dart';

part 'chat_dao.g.dart';

@DriftAccessor(tables: [ChatMessages, ChatSessions, ChatCitations])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  // ===== Chat Sessions =====

  /// Insert or update a chat session
  Future<void> upsertSession(ChatSessionsCompanion session) =>
      into(chatSessions).insertOnConflictUpdate(session);

  /// Get chat session by ID
  Future<ChatSessionData?> getSessionById(String id) =>
      (select(chatSessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get all chat sessions for user
  Future<List<ChatSessionData>> getSessions({
    String? userId,
    int? limit,
    int? offset,
  }) {
    var query = select(chatSessions);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    return query.get();
  }

  /// Stream all chat sessions for user
  Stream<List<ChatSessionData>> watchSessions({String? userId}) {
    var query = select(chatSessions);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    return query.watch();
  }

  /// Delete chat session by ID
  Future<int> deleteSession(String id) =>
      (delete(chatSessions)..where((t) => t.id.equals(id))).go();

  /// Update session message count and preview
  Future<void> updateSessionStats(
          String id, int messageCount, String preview) =>
      (update(chatSessions)..where((t) => t.id.equals(id)))
          .write(ChatSessionsCompanion(
        messageCount: Value(messageCount),
        lastMessagePreview: Value(preview),
        updatedAt: Value(DateTime.now().toUtc()),
      ));

  // ===== Chat Messages =====

  /// Insert or update a chat message
  Future<void> upsertMessage(ChatMessagesCompanion message) =>
      into(chatMessages).insertOnConflictUpdate(message);

  /// Get chat message by ID
  Future<ChatMessageData?> getMessageById(String id) =>
      (select(chatMessages)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get all messages for a session
  Future<List<ChatMessageData>> getSessionMessages(String sessionId,
          {int? limit, int? offset}) =>
      (select(chatMessages)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.timestamp)])
            ..limit(limit ?? 100, offset: offset))
          .get();

  /// Stream messages for a session
  Stream<List<ChatMessageData>> watchSessionMessages(String sessionId) =>
      (select(chatMessages)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .watch();

  /// Delete message by ID
  Future<int> deleteMessage(String id) =>
      (delete(chatMessages)..where((t) => t.id.equals(id))).go();

  /// Delete all messages for a session
  Future<int> deleteSessionMessages(String sessionId) =>
      (delete(chatMessages)..where((t) => t.sessionId.equals(sessionId))).go();

  /// Update message streaming state
  Future<void> updateMessageStreaming(String id, bool isStreaming) =>
      (update(chatMessages)..where((t) => t.id.equals(id)))
          .write(ChatMessagesCompanion(isStreaming: Value(isStreaming)));

  /// Update message error
  Future<void> updateMessageError(String id, String error) =>
      (update(chatMessages)..where((t) => t.id.equals(id)))
          .write(ChatMessagesCompanion(error: Value(error)));

  /// Get user's recent messages
  Future<List<ChatMessageData>> getRecentMessages(String userId,
          {int? limit}) =>
      (select(chatMessages)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
            ..limit(limit ?? 50))
          .get();

  // ===== Chat Citations =====

  /// Insert citation
  Future<void> insertCitation(ChatCitationsCompanion citation) =>
      into(chatCitations).insertOnConflictUpdate(citation);

  /// Get citations for a message
  Future<List<ChatCitationData>> getCitationsForMessage(String messageId) =>
      (select(chatCitations)..where((t) => t.messageId.equals(messageId)))
          .get();

  /// Delete citations for a message
  Future<int> deleteCitationsForMessage(String messageId) =>
      (delete(chatCitations)..where((t) => t.messageId.equals(messageId))).go();

  /// Convert domain ChatSession to database companion
  ChatSessionsCompanion toSessionCompanion(ChatSession session) =>
      ChatSessionsCompanion(
        id: Value(session.id),
        userId: Value(session.userId),
        title: Value(session.title),
        createdAt: Value(session.createdAt),
        updatedAt: Value(session.updatedAt),
        messageCount: Value(session.messageCount),
        lastMessagePreview: Value(session.lastMessagePreview),
        metadata: Value(session.metadata),
      );

  /// Convert database row to domain ChatSession
  ChatSession toSessionDomain(ChatSessionData data) => ChatSession(
        id: data.id,
        userId: data.userId,
        title: data.title,
        lastMessagePreview: data.lastMessagePreview,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
        messageCount: data.messageCount,
        metadata: data.metadata,
      );

  /// Convert domain ChatMessage to database companion
  ChatMessagesCompanion toMessageCompanion(ChatMessage message) =>
      ChatMessagesCompanion(
        id: Value(message.id),
        userId: Value(message.userId),
        sessionId: Value(message.sessionId),
        role: Value(message.role),
        content: Value(message.content),
        timestamp: Value(message.timestamp),
        source: Value(message.source),
        metadata: Value(message.metadata),
        isStreaming: Value(message.isStreaming),
        error: Value(message.error),
      );

  /// Convert database row to domain ChatMessage
  ChatMessage toMessageDomain(ChatMessageData data) => ChatMessage(
        id: data.id,
        userId: data.userId,
        sessionId: data.sessionId,
        role: data.role,
        content: data.content,
        timestamp: data.timestamp,
        source: data.source,
        metadata: data.metadata,
        isStreaming: data.isStreaming,
        error: data.error,
      );

  /// Convert domain Citation to database companion
  ChatCitationsCompanion toCitationCompanion(
          Citation citation, String messageId) =>
      ChatCitationsCompanion(
        id: Value(citation.itemId),
        messageId: Value(messageId),
        itemId: Value(citation.itemId),
        title: Value(citation.title),
        snippet: Value(citation.snippet),
        score: Value(citation.score),
        metadata: Value(citation.metadata),
      );

  /// Convert database row to domain Citation
  Citation toCitationDomain(ChatCitationData data) => Citation(
        itemId: data.itemId,
        title: data.title,
        snippet: data.snippet,
        score: data.score ?? 0.0,
        metadata: data.metadata,
      );
}
