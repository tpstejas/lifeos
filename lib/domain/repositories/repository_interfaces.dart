// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/domain/entities/enums.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/entities/collection.dart';
import 'package:lifeos/domain/entities/digest.dart';
import 'package:lifeos/domain/entities/chat_message.dart';
import 'package:lifeos/domain/entities/chat_session.dart';
import 'package:lifeos/domain/entities/task.dart';
import 'package:lifeos/domain/entities/user.dart';

/// Item repository interface
abstract interface class ItemRepository {
  /// Get item by ID
  Future<Item?> getById(String id);

  /// Get all items for user (with optional filters)
  Future<List<Item>> getAll({
    String? userId,
    String? collectionId,
    ItemType? type,
    bool? isArchived,
    bool? isFavorite,
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// Stream all items for real-time updates
  Stream<List<Item>> watchAll({
    String? userId,
    String? collectionId,
    ItemType? type,
    bool? isArchived,
  });

  /// Save item (create or update)
  Future<void> save(Item item);

  /// Delete item
  Future<void> delete(String id);

  /// Bulk save items
  Future<void> saveAll(List<Item> items);

  /// Bulk delete items
  Future<void> deleteAll(List<String> ids);

  /// Search items by text
  Future<List<Item>> search(String query, {int? limit});

  /// Semantic search using embeddings
  Future<List<Item>> semanticSearch(
    List<double> queryEmbedding, {
    int? limit,
    double? threshold,
    String? collectionId,
  });

  /// Get items by collection
  Future<List<Item>> getByCollection(String collectionId,
      {int? limit, int? offset});

  /// Get favorite items
  Future<List<Item>> getFavorites({int? limit});

  /// Get recent items
  Future<List<Item>> getRecent({int? limit = 20});

  /// Get items needing embedding
  Future<List<Item>> getItemsNeedingEmbedding({int? limit});

  /// Update item embedding
  Future<void> updateEmbedding(String id, List<double> embedding);

  /// Update item summary and key points
  Future<void> updateAiAnalysis(String id,
      {String? summary, List<String>? keyPoints});

  /// Archive/unarchive item
  Future<void> setArchived(String id, bool archived);

  /// Favorite/unfavorite item
  Future<void> setFavorite(String id, bool favorite);

  /// Move item to collection
  Future<void> moveToCollection(String itemId, String collectionId);

  /// Get item count by collection
  Future<Map<String, int>> getCountsByCollection(String userId);

  /// Get items modified after timestamp (for sync)
  Future<List<Item>> getModifiedAfter(DateTime timestamp, {int? limit});
}

/// Collection repository interface
abstract interface class CollectionRepository {
  /// Get collection by ID
  Future<Collection?> getById(String id);

  /// Get all collections for user
  Future<List<Collection>> getAll({String? userId, bool includeSystem = true});

  /// Stream all collections
  Stream<List<Collection>> watchAll({String? userId});

  /// Save collection
  Future<void> save(Collection collection);

  /// Delete collection
  Future<void> delete(String id);

  /// Get default collection
  Future<Collection?> getDefault(String userId);

  /// Get system collections
  Future<List<Collection>> getSystemCollections(String userId);

  /// Update item count
  Future<void> updateItemCount(String id, int count);

  /// Reorder collections
  Future<void> reorder(List<String> orderedIds);
}

/// Digest repository interface
abstract interface class DigestRepository {
  /// Get digest by ID
  Future<Digest?> getById(String id);

  /// Get digest by ID (alias for getById)
  Future<Digest?> getDigest(String id) => getById(id);

  /// Get digests for user
  Future<List<Digest>> getAll({
    String? userId,
    DigestPeriod? period,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
  });

  /// Stream digests
  Stream<List<Digest>> watchAll({String? userId, DigestPeriod? period});

  /// Save digest
  Future<void> save(Digest digest);

  /// Delete digest
  Future<void> delete(String id);

  /// Get latest digest for period
  Future<Digest?> getLatest(String userId, DigestPeriod period);

  /// Get digest for specific date
  Future<Digest?> getByDate(String userId, DigestPeriod period, DateTime date);

  /// Generate a new digest using AI
  Future<Digest> generateDigest({
    required String userId,
    required DigestPeriod period,
    required DateTime date,
    required InferenceSource source,
  });
}

/// Chat repository interface
abstract interface class ChatRepository {
  /// Get message by ID
  Future<ChatMessage?> getById(String id);

  /// Get messages for session
  Future<List<ChatMessage>> getSessionMessages(String sessionId,
      {int? limit, int? offset});

  /// Get messages for session (alias for getSessionMessages)
  Future<List<ChatMessage>> getChatMessages(String sessionId,
      {int? limit, int? offset});

  /// Stream session messages
  Stream<List<ChatMessage>> watchSessionMessages(String sessionId);

  /// Save message
  Future<void> save(ChatMessage message);

  /// Add chat message (alias for save)
  Future<void> addChatMessage(ChatMessage message);

  /// Delete message
  Future<void> delete(String id);

  /// Delete session messages
  Future<void> deleteSession(String sessionId);

  /// Get all sessions for user
  Future<List<ChatSession>> getSessions(String userId, {int? limit});

  /// Get session by ID
  Future<ChatSession?> getChatSession(String id);

  /// Stream sessions
  Stream<List<ChatSession>> watchSessions(String userId);

  /// Save session
  Future<void> saveSession(ChatSession session);

  /// Update session (alias for saveSession)
  Future<void> updateChatSession(ChatSession session);

  /// Delete session
  Future<void> deleteSessionById(String id);

  /// Delete chat session (alias for deleteSessionById)
  Future<void> deleteChatSession(String id);

  /// Update message streaming status
  Future<void> updateStreaming(String messageId, bool isStreaming);

  /// Update message error
  Future<void> updateError(String messageId, String error);
}

/// Task repository interface
abstract interface class TaskRepository {
  /// Get task by ID
  Future<Task?> getById(String id);

  /// Get task by ID (alias for getById)
  Future<Task?> getTask(String id) => getById(id);

  /// Get all tasks for user
  Future<List<Task>> getAll({
    String? userId,
    String? collectionId,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
    bool? overdueOnly,
    int? limit,
    int? offset,
  });

  /// Stream all tasks
  Stream<List<Task>> watchAll({
    String? userId,
    String? collectionId,
    TaskStatus? status,
  });

  /// Save task (create or update)
  Future<void> save(Task task);

  /// Create task (alias for save)
  Future<void> createTask(Task task) => save(task);

  /// Update task (alias for save)
  Future<void> updateTask(Task task) => save(task);

  /// Delete task
  Future<void> delete(String id);

  /// Delete task (alias for delete)
  Future<void> deleteTask(String id) => delete(id);

  /// Bulk save tasks
  Future<void> saveAll(List<Task> tasks);

  /// Get overdue tasks
  Future<List<Task>> getOverdue({String? userId, int? limit});

  /// Get tasks due today
  Future<List<Task>> getDueToday({String? userId});

  /// Get tasks due this week
  Future<List<Task>> getDueThisWeek({String? userId});

  /// Get tasks by status
  Future<List<Task>> getByStatus(TaskStatus status,
      {String? userId, int? limit});

  /// Get upcoming tasks
  Future<List<Task>> getUpcoming({String? userId, int? limit = 10});

  /// Get task statistics
  Future<TaskStatistics> getStatistics(String userId);

  /// Complete task
  Future<void> complete(String id);

  /// Update task status
  Future<void> updateStatus(String id, TaskStatus status);

  /// Get tasks needing reminders
  Future<List<Task>> getTasksNeedingReminders(DateTime now);

  /// Get tasks modified after timestamp (for sync)
  Future<List<Task>> getModifiedAfter(DateTime timestamp, {int? limit});
}

/// Task statistics
class TaskStatistics {
  const TaskStatistics({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.overdue,
    required this.dueToday,
    required this.dueThisWeek,
    required this.byPriority,
    required this.byCollection,
  });

  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final int overdue;
  final int dueToday;
  final int dueThisWeek;
  final Map<TaskPriority, int> byPriority;
  final Map<String, int> byCollection;
}

/// User repository interface
abstract interface class UserRepository {
  /// Get user by ID
  Future<User?> getUser(String userId);

  /// Get current user (from auth)
  Future<User?> getCurrentUser();

  /// Create or update user
  Future<void> saveUser(User user);

  /// Update user
  Future<void> updateUser(User user);

  /// Delete user
  Future<void> deleteUser(String userId);

  /// Stream user changes
  Stream<User?> watchUser(String userId);
}
