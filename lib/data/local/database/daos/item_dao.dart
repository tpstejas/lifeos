// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:lifeos/data/local/database/app_database.dart';
import 'package:lifeos/domain/entities/item.dart';

part 'item_dao.g.dart';

@DriftAccessor(tables: [Items])
class ItemDao extends DatabaseAccessor<AppDatabase> with _$ItemDaoMixin {
  ItemDao(super.db);

  /// Insert or update an item
  Future<void> upsertItem(ItemsCompanion item) =>
      into(items).insertOnConflictUpdate(item);

  /// Get item by ID
  Future<ItemData?> getItemById(String id) =>
      (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get all items with optional filters
  Future<List<ItemData>> getAllItems({
    String? userId,
    String? collectionId,
    ItemType? type,
    bool? isArchived,
    bool? isFavorite,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    var query = select(items);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (collectionId != null) {
      query = query..where((t) => t.collectionId.equals(collectionId));
    }
    if (type != null) {
      query = query..where((t) => t.type.equals(type.name));
    }
    if (isArchived != null) {
      query = query..where((t) => t.isArchived.equals(isArchived));
    }
    if (isFavorite != null) {
      query = query..where((t) => t.isFavorite.equals(isFavorite));
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((t) =>
            t.title.like('%$searchQuery%') |
            t.description.like('%$searchQuery%') |
            t.content.like('%$searchQuery%'));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    return query.get();
  }

  /// Stream all items for real-time updates
  Stream<List<ItemData>> watchAllItems({
    String? userId,
    String? collectionId,
    ItemType? type,
    bool? isArchived,
  }) {
    var query = select(items);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (collectionId != null) {
      query = query..where((t) => t.collectionId.equals(collectionId));
    }
    if (type != null) {
      query = query..where((t) => t.type.equals(type.name));
    }
    if (isArchived != null) {
      query = query..where((t) => t.isArchived.equals(isArchived));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    return query.watch();
  }

  /// Delete item by ID
  Future<int> deleteItem(String id) =>
      (delete(items)..where((t) => t.id.equals(id))).go();

  /// Bulk insert items
  Future<void> insertAllItems(List<ItemsCompanion> itemsList) => batch((batch) {
        batch.insertAllOnConflictUpdate(items, itemsList);
      });

  /// Bulk delete items
  Future<void> deleteAllItems(List<String> ids) => batch((batch) {
        for (final id in ids) {
          batch.deleteWhere(items, (t) => t.id.equals(id));
        }
      });

  /// Search items by text
  Future<List<ItemData>> searchItems(String query, {int? limit}) =>
      (select(items)
            ..where((t) =>
                t.title.like('%$query%') |
                t.description.like('%$query%') |
                t.content.like('%$query%'))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 50))
          .get();

  /// Get items by collection
  Future<List<ItemData>> getItemsByCollection(String collectionId,
          {int? limit, int? offset}) =>
      (select(items)
            ..where((t) => t.collectionId.equals(collectionId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 100, offset: offset))
          .get();

  /// Get favorite items
  Future<List<ItemData>> getFavorites({int? limit}) => (select(items)
        ..where((t) => t.isFavorite.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(limit ?? 50))
      .get();

  /// Get recent items
  Future<List<ItemData>> getRecentItems({int? limit = 20}) => (select(items)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(limit ?? 20))
      .get();

  /// Get items needing embedding
  Future<List<ItemData>> getItemsNeedingEmbedding({int? limit}) =>
      (select(items)
            ..where((t) => t.embedding.isNull() & t.content.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 100))
          .get();

  /// Search items by vector embedding similarity using sqlite-vec
  /// Returns items ordered by cosine similarity (highest first)
  Future<List<ItemData>> searchByEmbedding(
    List<double> queryEmbedding, {
    required String userId,
    String? collectionId,
    int? limit,
    double minSimilarity = 0.0,
  }) async {
    // TODO: Implement with sqlite-vec when available
    // For now, fall back to text search with a basic similarity filter
    // This will be replaced with actual vector search using:
    // SELECT * FROM items, vec_search(...) WHERE user_id = ? ORDER BY distance LIMIT ?

    var query = select(items)
      ..where((t) => t.userId.equals(userId) & t.embedding.isNotNull());

    if (collectionId != null) {
      query = query..where((t) => t.collectionId.equals(collectionId));
    }

    query = query
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit ?? 50);

    final results = await query.get();

    // Basic cosine similarity filtering in Dart (placeholder)
    // In production, this should be done in SQLite using sqlite-vec
    final scored = <(ItemData, double)>[];
    for (final item in results) {
      if (item.embedding != null) {
        final similarity = _cosineSimilarity(queryEmbedding, item.embedding!);
        if (similarity >= minSimilarity) {
          scored.add((item, similarity));
        }
      }
    }

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).take(limit ?? 50).toList();
  }

  /// Compute cosine similarity between two embeddings
  static double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;

    double dotProduct = 0;
    double normA = 0;
    double normB = 0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) return 0.0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }

  /// Update item embedding
  Future<void> updateEmbedding(String id, List<double> embedding) {
    return (update(items)..where((t) => t.id.equals(id)))
        .write(ItemsCompanion(embedding: Value(embedding)));
  }

  /// Update item AI analysis (summary and key points)
  Future<void> updateAiAnalysis(String id,
      {String? summary, List<String>? keyPoints}) {
    var companion = ItemsCompanion(
      updatedAt: Value(DateTime.now().toUtc()),
      version: Value(0), // Will be incremented by repository
    );
    if (summary != null) {
      companion = companion.copyWith(summary: Value(summary));
    }
    if (keyPoints != null) {
      companion = companion.copyWith(keyPoints: Value(keyPoints));
    }
    return (update(items)..where((t) => t.id.equals(id))).write(companion);
  }

  /// Archive/unarchive item
  Future<void> setArchived(String id, bool archived) =>
      (update(items)..where((t) => t.id.equals(id))).write(ItemsCompanion(
        isArchived: Value(archived),
        updatedAt: Value(DateTime.now().toUtc()),
      ));

  /// Favorite/unfavorite item
  Future<void> setFavorite(String id, bool favorite) =>
      (update(items)..where((t) => t.id.equals(id))).write(ItemsCompanion(
        isFavorite: Value(favorite),
        updatedAt: Value(DateTime.now().toUtc()),
      ));

  /// Move item to collection
  Future<void> moveToCollection(String itemId, String collectionId) =>
      (update(items)..where((t) => t.id.equals(itemId))).write(ItemsCompanion(
        collectionId: Value(collectionId),
        updatedAt: Value(DateTime.now().toUtc()),
      ));

  /// Get item count by collection for user
  Future<Map<String, int>> getItemCountsByCollection(String userId) async {
    final query = selectOnly(items)
      ..addColumns([items.collectionId, items.id.count()])
      ..where(items.userId.equals(userId) & items.isArchived.equals(false))
      ..groupBy([items.collectionId]);

    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(items.collectionId)!: row.read(items.id.count()) ?? 0
    };
  }

  /// Get items modified after timestamp (for sync)
  Future<List<ItemData>> getItemsModifiedAfter(DateTime timestamp,
          {int? limit}) =>
      (select(items)
            ..where((t) => t.updatedAt.isBiggerOrEqualValue(timestamp))
            ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)])
            ..limit(limit ?? 1000))
          .get();

  /// Convert domain Item to database companion
  ItemsCompanion toCompanion(Item item) => ItemsCompanion(
        id: Value(item.id),
        userId: Value(item.userId),
        type: Value(item.type),
        title: Value(item.title),
        description: Value(item.description),
        content: Value(item.content),
        sourceUrl: Value(item.sourceUrl),
        thumbnailUrl: Value(item.thumbnailUrl),
        filePath: Value(item.filePath),
        fileSize: Value(item.fileSize),
        mimeType: Value(item.mimeType),
        collectionId: Value(item.collectionId),
        tags: Value(item.tags),
        metadata: Value(item.metadata),
        createdAt: Value(item.createdAt),
        updatedAt: Value(item.updatedAt),
        embedding: Value(item.embedding),
        summary: Value(item.summary),
        keyPoints: Value(item.keyPoints),
        isArchived: Value(item.isArchived),
        isFavorite: Value(item.isFavorite),
        version: Value(item.version),
      );

  /// Convert database row to domain Item
  Item toDomain(ItemData data) => Item(
        id: data.id,
        userId: data.userId,
        type: data.type,
        title: data.title,
        description: data.description,
        content: data.content,
        sourceUrl: data.sourceUrl,
        thumbnailUrl: data.thumbnailUrl,
        filePath: data.filePath,
        fileSize: data.fileSize,
        mimeType: data.mimeType,
        collectionId: data.collectionId,
        tags: data.tags,
        metadata: data.metadata,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
        embedding: data.embedding,
        summary: data.summary,
        keyPoints: data.keyPoints,
        isArchived: data.isArchived,
        isFavorite: data.isFavorite,
        version: data.version,
      );
}
