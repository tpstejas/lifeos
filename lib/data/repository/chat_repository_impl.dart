// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/data/local/database/daos/chat_dao.dart';
import 'package:lifeos/domain/entities/chat_message.dart';
import 'package:lifeos/domain/entities/chat_session.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Local Chat Repository Implementation
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._dao);

  final ChatDao _dao;

  @override
  Future<ChatMessage?> getById(String id) async {
    final data = await _dao.getMessageById(id);
    return data != null ? _dao.toMessageDomain(data) : null;
  }

  @override
  Future<List<ChatMessage>> getSessionMessages(String sessionId,
      {int? limit, int? offset}) async {
    final dataList =
        await _dao.getSessionMessages(sessionId, limit: limit, offset: offset);
    final messages = <ChatMessage>[];
    for (final data in dataList) {
      messages.add(_dao.toMessageDomain(data));
    }
    return messages;
  }

  @override
  Stream<List<ChatMessage>> watchSessionMessages(String sessionId) {
    return _dao.watchSessionMessages(sessionId).map((dataList) {
      final messages = <ChatMessage>[];
      for (final data in dataList) {
        messages.add(_dao.toMessageDomain(data));
      }
      return messages;
    });
  }

  @override
  Future<void> save(ChatMessage message) async {
    final companion = _dao.toMessageCompanion(message);
    await _dao.upsertMessage(companion);

    // Save citations
    await _dao.deleteCitationsForMessage(message.id);
    for (final citation in message.citations) {
      final citationCompanion = _dao.toCitationCompanion(citation, message.id);
      await _dao.insertCitation(citationCompanion);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteMessage(id);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _dao.deleteSessionMessages(sessionId);
  }

  @override
  Future<List<ChatSession>> getSessions(String userId, {int? limit}) async {
    final dataList = await _dao.getSessions(userId: userId, limit: limit);
    return dataList.map(_dao.toSessionDomain).toList();
  }

  @override
  Stream<List<ChatSession>> watchSessions(String userId) {
    return _dao
        .watchSessions(userId: userId)
        .map((dataList) => dataList.map(_dao.toSessionDomain).toList());
  }

  @override
  Future<void> saveSession(ChatSession session) async {
    final companion = _dao.toSessionCompanion(session);
    await _dao.upsertSession(companion);
  }

  @override
  Future<void> deleteSessionById(String id) async {
    await _dao.deleteSession(id);
  }

  // Alias methods for conversation_page.dart

  @override
  Future<List<ChatMessage>> getChatMessages(String sessionId,
      {int? limit, int? offset}) async {
    return getSessionMessages(sessionId, limit: limit, offset: offset);
  }

  @override
  Future<void> addChatMessage(ChatMessage message) async {
    await save(message);
  }

  @override
  Future<ChatSession?> getChatSession(String id) async {
    final data = await _dao.getSessionById(id);
    return data != null ? _dao.toSessionDomain(data) : null;
  }

  @override
  Future<void> updateChatSession(ChatSession session) async {
    await saveSession(session);
  }

  @override
  Future<void> deleteChatSession(String id) async {
    await deleteSessionById(id);
  }

  @override
  Future<void> updateStreaming(String messageId, bool isStreaming) async {
    await _dao.updateMessageStreaming(messageId, isStreaming);
  }

  @override
  Future<void> updateError(String messageId, String error) async {
    await _dao.updateMessageError(messageId, error);
  }
}
