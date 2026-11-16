// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/data/local/database/app_database.dart';
import 'package:lifeos/data/local/database/daos/item_dao.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Local Item Repository Implementation
class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl(this._dao);

  final ItemDao _dao;

  @override
  Future<Item?> getById(String id) async {
    final data = await _dao.getItemById(id);
    return data != null ? _dao.toDomain(data) : null;
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
    final dataList = await _dao.getAllItems(
      userId: userId,
      collectionId: collectionId,
      type: type,
      isArchived: isArchived,
      isFavorite: isFavorite,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Stream<List<Item>> watchAll({
    String? userId,
    String? collectionId,
    ItemType? type,
    bool? isArchived,
  }) {
    return _dao
        .watchAllItems(
          userId: userId,
          collectionId: collectionId,
          type: type,
          isArchived: isArchived,
        )
        .map((dataList) => dataList.map(_dao.toDomain).toList());
  }

  @override
  Future<void> save(Item item) async {
    final companion = _dao.toCompanion(item);
    await _dao.upsertItem(companion);
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteItem(id);
  }

  @override
  Future<void> saveAll(List<Item> items) async {
    final companions = items.map(_dao.toCompanion).toList();
    await _dao.insertAllItems(companions);
  }

  @override
  Future<void> deleteAll(List<String> ids) async {
    await _dao.deleteAllItems(ids);
  }

  @override
  Future<List<Item>> search(String query, {int? limit}) async {
    final dataList = await _dao.searchItems(query, limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Item>> semanticSearch(
    List<double> queryEmbedding, {
    int? limit,
    double? threshold,
    String? collectionId,
  }) async {
    // Placeholder for vector search implementation
    // Will use sqlite-vec or similar for on-device semantic search
    final dataList = await _dao.getAllItems(
      userId: '', // Will be filled by caller
      collectionId: collectionId,
      limit: limit ?? 10,
    );
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Item>> getByCollection(String collectionId,
      {int? limit, int? offset}) async {
    final dataList = await _dao.getItemsByCollection(collectionId,
        limit: limit, offset: offset);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Item>> getFavorites({int? limit}) async {
    final dataList = await _dao.getFavorites(limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Item>> getRecent({int? limit = 20}) async {
    final dataList = await _dao.getRecentItems(limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Item>> getItemsNeedingEmbedding({int? limit}) async {
    final dataList = await _dao.getItemsNeedingEmbedding(limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<void> updateEmbedding(String id, List<double> embedding) async {
    await _dao.updateEmbedding(id, embedding);
  }

  @override
  Future<void> updateAiAnalysis(String id,
      {String? summary, List<String>? keyPoints}) async {
    await _dao.updateAiAnalysis(id, summary: summary, keyPoints: keyPoints);
  }

  @override
  Future<void> setArchived(String id, bool archived) async {
    await _dao.setArchived(id, archived);
  }

  @override
  Future<void> setFavorite(String id, bool favorite) async {
    await _dao.setFavorite(id, favorite);
  }

  @override
  Future<void> moveToCollection(String itemId, String collectionId) async {
    await _dao.moveToCollection(itemId, collectionId);
  }

  @override
  Future<Map<String, int>> getCountsByCollection(String userId) async {
    return _dao.getItemCountsByCollection(userId);
  }

  @override
  Future<List<Item>> getModifiedAfter(DateTime timestamp, {int? limit}) async {
    final dataList = await _dao.getItemsModifiedAfter(timestamp, limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }
}
