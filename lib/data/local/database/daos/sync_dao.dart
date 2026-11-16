// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:drift/drift.dart';
import 'package:lifeos/data/local/database/app_database.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncQueue, AppSettings])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  // ===== Sync Queue =====

  /// Add operation to sync queue
  Future<void> enqueueSync(SyncQueueCompanion operation) =>
      into(syncQueue).insertOnConflictUpdate(operation);

  /// Get pending sync operations
  Future<List<SyncQueueData>> getPendingSync({int? limit}) => (select(syncQueue)
        ..where((t) => t.retryCount.isSmallerThanValue(5))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
        ..limit(limit ?? 100))
      .get();

  /// Get sync operation by ID
  Future<SyncQueueData?> getSyncById(String id) =>
      (select(syncQueue)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Mark sync operation as attempted
  Future<void> markSyncAttempted(String id, {String? error}) =>
      (update(syncQueue)..where((t) => t.id.equals(id)))
          .write(SyncQueueCompanion(
        retryCount: Value(0), // Will be incremented by repo
        lastAttemptAt: Value(DateTime.now().toUtc()),
        error: Value(error),
      ));

  /// Increment retry count
  Future<void> incrementRetryCount(String id) {
    return transaction(() async {
      final op = await getSyncById(id);
      if (op != null) {
        await (update(syncQueue)..where((t) => t.id.equals(id)))
            .write(SyncQueueCompanion(
          retryCount: Value(op.retryCount + 1),
          lastAttemptAt: Value(DateTime.now().toUtc()),
        ));
      }
    });
  }

  /// Remove completed sync operation
  Future<int> removeSync(String id) =>
      (delete(syncQueue)..where((t) => t.id.equals(id))).go();

  /// Clear all completed/failed sync operations
  Future<void> clearOldSync({int maxAgeDays = 7}) {
    final cutoff = DateTime.now().toUtc().subtract(Duration(days: maxAgeDays));
    return (delete(syncQueue)
          ..where((t) =>
              t.createdAt.isSmallerThanValue(cutoff) &
              (t.retryCount.isBiggerOrEqualValue(5) | t.error.isNotNull())))
        .go();
  }

  /// Get sync queue statistics
  Future<SyncStatistics> getSyncStatistics() async {
    final pendingQuery = selectOnly(syncQueue)
      ..addColumns([syncQueue.id.count()])
      ..where(syncQueue.retryCount.isSmallerThanValue(5));
    final pending =
        (await pendingQuery.getSingle()).read(syncQueue.id.count()) ?? 0;

    final failedQuery = selectOnly(syncQueue)
      ..addColumns([syncQueue.id.count()])
      ..where(syncQueue.retryCount.isBiggerOrEqualValue(5));
    final failed =
        (await failedQuery.getSingle()).read(syncQueue.id.count()) ?? 0;

    final processingQuery = selectOnly(syncQueue)
      ..addColumns([syncQueue.id.count()])
      ..where(syncQueue.lastAttemptAt.isNotNull() &
          syncQueue.retryCount.isSmallerThanValue(5));
    final processing =
        (await processingQuery.getSingle()).read(syncQueue.id.count()) ?? 0;

    return SyncStatistics(
      pending: pending,
      processing: processing,
      failed: failed,
    );
  }

  // ===== App Settings =====

  /// Get setting value
  Future<String?> getSetting(String key) async {
    final result = await (select(appSettings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return result?.value.toString();
  }

  /// Set setting value
  Future<void> setSetting(String key, dynamic value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion(
          key: Value(key),
          value: Value(value),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

  /// Get all settings
  Future<Map<String, dynamic>> getAllSettings() async {
    final rows = await select(appSettings).get();
    return {for (final row in rows) row.key: row.value};
  }

  /// Create sync queue companion
  SyncQueueCompanion createSyncCompanion({
    required String id,
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required Map<String, dynamic> payload,
  }) =>
      SyncQueueCompanion(
        id: Value(id),
        entityType: Value(entityType),
        entityId: Value(entityId),
        operation: Value(operation),
        payload: Value(payload),
        retryCount: Value(0),
        createdAt: Value(DateTime.now().toUtc()),
      );
}

/// Sync statistics
class SyncStatistics {
  const SyncStatistics({
    required this.pending,
    required this.processing,
    required this.failed,
  });

  final int pending;
  final int processing;
  final int failed;

  int get total => pending + processing + failed;
}
