// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:drift/drift.dart';
import 'package:lifeos/data/local/database/app_database.dart';
import 'package:lifeos/domain/entities/collection.dart';

part 'collection_dao.g.dart';

@DriftAccessor(tables: [Collections])
class CollectionDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionDaoMixin {
  CollectionDao(super.db);

  /// Insert or update a collection
  Future<void> upsertCollection(CollectionsCompanion collection) =>
      into(collections).insertOnConflictUpdate(collection);

  /// Get collection by ID
  Future<CollectionData?> getCollectionById(String id) =>
      (select(collections)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get all collections for user
  Future<List<CollectionData>> getAllCollections({
    String? userId,
    bool includeSystem = true,
  }) {
    var query = select(collections);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (!includeSystem) {
      query = query..where((t) => t.isSystem.equals(false));
    }

    query = query..orderBy([(t) => OrderingTerm.asc(t.order)]);

    return query.get();
  }

  /// Stream all collections
  Stream<List<CollectionData>> watchAllCollections({String? userId}) {
    var query = select(collections);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }

    query = query..orderBy([(t) => OrderingTerm.asc(t.order)]);

    return query.watch();
  }

  /// Delete collection by ID
  Future<int> deleteCollection(String id) =>
      (delete(collections)..where((t) => t.id.equals(id))).go();

  /// Get default collection for user
  Future<CollectionData?> getDefaultCollection(String userId) =>
      (select(collections)
            ..where((t) => t.userId.equals(userId) & t.isDefault.equals(true)))
          .getSingleOrNull();

  /// Get system collections
  Future<List<CollectionData>> getSystemCollections(String userId) =>
      (select(collections)
            ..where((t) => t.userId.equals(userId) & t.isSystem.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.order)]))
          .get();

  /// Update item count
  Future<void> updateItemCount(String id, int count) =>
      (update(collections)..where((t) => t.id.equals(id)))
          .write(CollectionsCompanion(itemCount: Value(count)));

  /// Reorder collections
  Future<void> reorderCollections(List<String> orderedIds) =>
      transaction(() async {
        for (int i = 0; i < orderedIds.length; i++) {
          await (update(collections)..where((t) => t.id.equals(orderedIds[i])))
              .write(CollectionsCompanion(order: Value(i)));
        }
      });

  /// Convert domain Collection to database companion
  CollectionsCompanion toCompanion(Collection collection) =>
      CollectionsCompanion(
        id: Value(collection.id),
        userId: Value(collection.userId),
        name: Value(collection.name),
        description: Value(collection.description),
        icon: Value(collection.icon),
        color: Value(collection.color),
        parentId: Value(collection.parentId),
        order: Value(collection.order),
        isSystem: Value(collection.isSystem),
        isDefault: Value(collection.isDefault),
        createdAt: Value(collection.createdAt),
        updatedAt: Value(collection.updatedAt),
        itemCount: Value(collection.itemCount),
        metadata: Value(collection.metadata),
      );

  /// Convert database row to domain Collection
  Collection toDomain(CollectionData data) => Collection(
        id: data.id,
        userId: data.userId,
        name: data.name,
        description: data.description,
        icon: data.icon,
        color: data.color,
        parentId: data.parentId,
        order: data.order,
        isSystem: data.isSystem,
        isDefault: data.isDefault,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
        itemCount: data.itemCount,
        metadata: data.metadata,
      );
}
