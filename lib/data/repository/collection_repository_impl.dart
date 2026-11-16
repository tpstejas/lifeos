// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/data/local/database/daos/collection_dao.dart';
import 'package:lifeos/domain/entities/collection.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Local Collection Repository Implementation
class CollectionRepositoryImpl implements CollectionRepository {
  CollectionRepositoryImpl(this._dao);

  final CollectionDao _dao;

  @override
  Future<Collection?> getById(String id) async {
    final data = await _dao.getCollectionById(id);
    return data != null ? _dao.toDomain(data) : null;
  }

  @override
  Future<List<Collection>> getAll(
      {String? userId, bool includeSystem = true}) async {
    final dataList = await _dao.getAllCollections(
        userId: userId, includeSystem: includeSystem);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Stream<List<Collection>> watchAll({String? userId}) {
    return _dao
        .watchAllCollections(userId: userId)
        .map((dataList) => dataList.map(_dao.toDomain).toList());
  }

  @override
  Future<void> save(Collection collection) async {
    final companion = _dao.toCompanion(collection);
    await _dao.upsertCollection(companion);
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteCollection(id);
  }

  @override
  Future<Collection?> getDefault(String userId) async {
    final data = await _dao.getDefaultCollection(userId);
    return data != null ? _dao.toDomain(data) : null;
  }

  @override
  Future<List<Collection>> getSystemCollections(String userId) async {
    final dataList = await _dao.getSystemCollections(userId);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<void> updateItemCount(String id, int count) async {
    await _dao.updateItemCount(id, count);
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    await _dao.reorderCollections(orderedIds);
  }
}
