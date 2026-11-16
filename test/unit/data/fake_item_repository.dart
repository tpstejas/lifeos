// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Fake implementation of ItemRepository for testing
class FakeItemRepository implements ItemRepository {
  final Map<String, Item> _items = {};

  @override
  Future<Item?> getById(String id) async {
    return _items[id];
  }

  @override
  Future<List<Item>> getAll({
    String? userId,
    String? collectionId,
    ItemType? type,
    bool? isArchived,
    bool? isFavorite,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    var results = _items.values.toList();

    if (userId != null) {
      results = results.where((i) => i.userId == userId).toList();
    }
    if (collectionId != null) {
      results = results.where((i) => i.collectionId == collectionId).toList();
    }
    if (type != null) {
      results = results.where((i) => i.type == type).toList();
    }
    if (isArchived != null) {
      results = results.where((i) => i.isArchived == isArchived).toList();
    }
    if (isFavorite != null) {
      results = results.where((i) => i.isFavorite == isFavorite).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      results = results
          .where((i) =>
              i.title.toLowerCase().contains(query) ||
              (i.description?.toLowerCase().contains(query) ?? false) ||
              (i.content?.toLowerCase().contains(query) ?? false) ||
              i.tags.any((tag) => tag.toLowerCase().contains(query)))
          .toList();
    }

    // Sort by updatedAt descending
    results.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (offset != null && offset > 0) {
      results = results.skip(offset).toList();
    }
    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }

    return results;
  }

  @override
  Stream<List<Item>> watchAll({
    String? userId,
    String? collectionId,
    ItemType? type,
    bool? isArchived,
  }) async* {
    yield await getAll(
      userId: userId,
      collectionId: collectionId,
      type: type,
      isArchived: isArchived,
    );
  }

  @override
  Future<void> save(Item item) async {
    _items[item.id] = item;
  }

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  @override
  Future<void> saveAll(List<Item> items) async {
    for (final item in items) {
      _items[item.id] = item;
    }
  }

  @override
  Future<void> deleteAll(List<String> ids) async {
    for (final id in ids) {
      _items.remove(id);
    }
  }

  @override
  Future<List<Item>> search(String query, {int? limit}) async {
    return getAll(searchQuery: query, limit: limit);
  }

  @override
  Future<List<Item>> semanticSearch(
    List<double> queryEmbedding, {
    int? limit,
    double? threshold,
    String? collectionId,
  }) async {
    // Simple fallback - return recent items
    return getAll(collectionId: collectionId, limit: limit ?? 10);
  }

  @override
  Future<List<Item>> getByCollection(String collectionId,
      {int? limit, int? offset}) async {
    return getAll(collectionId: collectionId, limit: limit, offset: offset);
  }

  @override
  Future<List<Item>> getFavorites({int? limit}) async {
    return getAll(isFavorite: true, limit: limit);
  }

  @override
  Future<List<Item>> getRecent({int? limit = 20}) async {
    return getAll(limit: limit);
  }

  @override
  Future<List<Item>> getItemsNeedingEmbedding({int? limit}) async {
    var results = _items.values
        .where((i) => i.embedding == null || i.embedding!.isEmpty)
        .toList();
    results.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    if (limit != null) {
      results = results.take(limit).toList();
    }
    return results;
  }

  @override
  Future<void> updateEmbedding(String id, List<double> embedding) async {
    final item = _items[id];
    if (item != null) {
      _items[id] = item.copyWith(embedding: embedding);
    }
  }

  @override
  Future<void> updateAiAnalysis(String id,
      {String? summary, List<String>? keyPoints}) async {
    final item = _items[id];
    if (item != null) {
      _items[id] = item.copyWith(summary: summary, keyPoints: keyPoints);
    }
  }

  @override
  Future<void> setArchived(String id, bool archived) async {
    final item = _items[id];
    if (item != null) {
      _items[id] = item.copyWith(isArchived: archived);
    }
  }

  @override
  Future<void> setFavorite(String id, bool favorite) async {
    final item = _items[id];
    if (item != null) {
      _items[id] = item.copyWith(isFavorite: favorite);
    }
  }

  @override
  Future<void> moveToCollection(String itemId, String collectionId) async {
    final item = _items[itemId];
    if (item != null) {
      _items[itemId] = item.copyWith(collectionId: collectionId);
    }
  }

  @override
  Future<Map<String, int>> getCountsByCollection(String userId) async {
    final counts = <String, int>{};
    for (final item in _items.values) {
      if (item.userId == userId) {
        counts[item.collectionId] = (counts[item.collectionId] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Future<List<Item>> getModifiedAfter(DateTime timestamp, {int? limit}) async {
    var results = _items.values
        .where((i) => i.updatedAt.isAfter(timestamp))
        .toList();
    results.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    if (limit != null) {
      results = results.take(limit).toList();
    }
    return results;
  }

  /// Helper to add items for testing
  void addItem(Item item) => _items[item.id] = item;

  /// Helper to clear all items
  void clear() => _items.clear();
}