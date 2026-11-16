// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/data/local/database/app_database.dart';
import 'package:lifeos/data/local/database/daos/item_dao.dart';
import 'package:lifeos/data/local/database/daos/collection_dao.dart';
import 'package:lifeos/data/local/database/daos/digest_dao.dart';
import 'package:lifeos/data/local/database/daos/chat_dao.dart';
import 'package:lifeos/data/local/database/daos/task_dao.dart';
import 'package:lifeos/data/local/database/daos/sync_dao.dart';
import 'package:lifeos/data/remote/auth_service.dart';
import 'package:lifeos/data/remote/firestore_service.dart' hide firestoreServiceProvider;
import 'package:lifeos/data/repository/item_repository_impl.dart';
import 'package:lifeos/data/repository/collection_repository_impl.dart';
import 'package:lifeos/data/repository/digest_repository_impl.dart';
import 'package:lifeos/data/repository/chat_repository_impl.dart';
import 'package:lifeos/data/repository/task_repository_impl.dart';
import 'package:lifeos/data/repository/user_repository_impl.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/entities/chat_message.dart';
import 'package:lifeos/domain/entities/chat_session.dart';
import 'package:lifeos/domain/entities/digest.dart';
import 'package:lifeos/domain/entities/task.dart';
import 'package:lifeos/domain/entities/user.dart';

/// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// DAO providers
final itemDaoProvider = Provider<ItemDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ItemDao(db);
});

final collectionDaoProvider = Provider<CollectionDao>((ref) {
  final db = ref.watch(databaseProvider);
  return CollectionDao(db);
});

final digestDaoProvider = Provider<DigestDao>((ref) {
  final db = ref.watch(databaseProvider);
  return DigestDao(db);
});

final chatDaoProvider = Provider<ChatDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ChatDao(db);
});

final taskDaoProvider = Provider<TaskDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskDao(db);
});

final syncDaoProvider = Provider<SyncDao>((ref) {
  final db = ref.watch(databaseProvider);
  return SyncDao(db);
});

/// Repository providers
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final dao = ref.watch(itemDaoProvider);
  return ItemRepositoryImpl(dao);
});

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  final dao = ref.watch(collectionDaoProvider);
  return CollectionRepositoryImpl(dao);
});

final digestRepositoryProvider = Provider<DigestRepository>((ref) {
  final dao = ref.watch(digestDaoProvider);
  return DigestRepositoryImpl(dao);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dao = ref.watch(chatDaoProvider);
  return ChatRepositoryImpl(dao);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dao = ref.watch(taskDaoProvider);
  return TaskRepositoryImpl(dao);
});

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserRepositoryImpl(authService, firestoreService);
});

/// Auth repository provider (wraps AuthService for convenience)
final authRepositoryProvider = Provider<AuthService>((ref) {
  return ref.watch(authServiceProvider);
});

/// Sync service provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final dao = ref.watch(syncDaoProvider);
  final itemRepo = ref.watch(itemRepositoryProvider);
  final collectionRepo = ref.watch(collectionRepositoryProvider);
  final taskRepo = ref.watch(taskRepositoryProvider);
  return SyncService(
    dao,
    itemRepo,
    collectionRepo,
    taskRepo,
  );
});

/// Stream providers for real-time data
/// Inbox items - items with no collection (empty collectionId)
final inboxItemsStreamProvider = StreamProvider.autoDispose.family<List<Item>, String>(
  (ref, userId) {
    if (userId.isEmpty) {
      return const Stream.empty();
    }
    final itemRepository = ref.watch(itemRepositoryProvider);
    // Watch items with empty collectionId (inbox items)
    return itemRepository.watchAll(
      userId: userId,
      collectionId: '', // Empty collectionId = inbox
    );
  },
);

/// Chat sessions stream provider
final chatSessionsStreamProvider = StreamProvider.autoDispose.family<List<ChatSession>, String>(
  (ref, userId) {
    if (userId.isEmpty) {
      return const Stream.empty();
    }
    final chatRepository = ref.watch(chatRepositoryProvider);
    return chatRepository.watchSessions(userId);
  },
);

/// Digests stream provider
final digestsStreamProvider = StreamProvider.autoDispose.family<List<Digest>, String>(
  (ref, userId) {
    if (userId.isEmpty) {
      return const Stream.empty();
    }
    final digestRepository = ref.watch(digestRepositoryProvider);
    return digestRepository.watchAll(userId: userId);
  },
);

/// Tasks stream provider
final tasksStreamProvider = StreamProvider.autoDispose.family<List<Task>, String>(
  (ref, userId) {
    if (userId.isEmpty) {
      return const Stream.empty();
    }
    final taskRepository = ref.watch(taskRepositoryProvider);
    return taskRepository.watchAll(userId: userId);
  },
);

/// Items by collection provider - watches items in a specific collection
final itemsByCollectionProvider = StreamProvider.autoDispose
    .family<List<Item>, ({String userId, String collection})>(
  (ref, params) {
    if (params.userId.isEmpty) {
      return const Stream.empty();
    }
    final itemRepository = ref.watch(itemRepositoryProvider);
    return itemRepository.watchAll(
      userId: params.userId,
      collectionId: params.collection,
    );
  },
);

/// Sync service
class SyncService {
  SyncService(
    this._syncDao,
    this._itemRepo,
    this._collectionRepo,
    this._taskRepo,
  );

  final SyncDao _syncDao;
  final ItemRepository _itemRepo;
  final CollectionRepository _collectionRepo;
  final TaskRepository _taskRepo;

  /// Enqueue a create operation
  Future<void> enqueueCreate<T>({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) async {
    await _syncDao.enqueueSync(
      _syncDao.createSyncCompanion(
        id: '${entityType}_$entityId',
        entityType: entityType,
        entityId: entityId,
        operation: SyncOperation.create,
        payload: payload,
      ),
    );
  }

  /// Enqueue an update operation
  Future<void> enqueueUpdate<T>({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) async {
    await _syncDao.enqueueSync(
      _syncDao.createSyncCompanion(
        id: '${entityType}_$entityId',
        entityType: entityType,
        entityId: entityId,
        operation: SyncOperation.update,
        payload: payload,
      ),
    );
  }

  /// Enqueue a delete operation
  Future<void> enqueueDelete<T>({
    required String entityType,
    required String entityId,
  }) async {
    await _syncDao.enqueueSync(
      _syncDao.createSyncCompanion(
        id: '${entityType}_$entityId',
        entityType: entityType,
        entityId: entityId,
        operation: SyncOperation.delete,
        payload: {'id': entityId},
      ),
    );
  }

  /// Process pending sync operations
  Future<void> processSyncQueue() async {
    final pending = await _syncDao.getPendingSync();
    for (final operation in pending) {
      try {
        await _processOperation(operation);
        await _syncDao.removeSync(operation.id);
      } catch (e) {
        await _syncDao.incrementRetryCount(operation.id);
        // Log error
      }
    }
  }

  Future<void> _processOperation(SyncQueueData operation) async {
    switch (operation.entityType) {
      case 'item':
        if (operation.operation == SyncOperation.create ||
            operation.operation == SyncOperation.update) {
          // TODO: Push to Firestore
        } else if (operation.operation == SyncOperation.delete) {
          // TODO: Delete from Firestore
        }
        break;
      case 'collection':
        // TODO: Push to Firestore
        break;
      case 'task':
        // TODO: Push to Firestore
        break;
    }
  }

  /// Get sync statistics
  Future<SyncStatistics> getSyncStatistics() async {
    return _syncDao.getSyncStatistics();
  }

  /// Clear old sync operations
  Future<void> clearOldSync({int maxAgeDays = 7}) async {
    await _syncDao.clearOldSync(maxAgeDays: maxAgeDays);
  }
}
