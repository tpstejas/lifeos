// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/entities/enums.dart';

/// Firestore service - handles all Firestore operations for Items
class FirestoreService with LoggerMixin {
  FirestoreService(this._firestore);

  final FirebaseFirestore _firestore;

  /// Get the user's items collection reference
  CollectionReference<Map<String, dynamic>> _userItemsCollection(
      String userId) {
    return _firestore.collection('users').doc(userId).collection('items');
  }

  /// Get the user's digests collection reference
  CollectionReference<Map<String, dynamic>> _userDigestsCollection(
      String userId) {
    return _firestore.collection('users').doc(userId).collection('digests');
  }

  /// Get the user's tasks collection reference
  CollectionReference<Map<String, dynamic>> _userTasksCollection(
      String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  /// Get the user's conversations collection reference
  CollectionReference<Map<String, dynamic>> _userConversationsCollection(
      String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations');
  }

  // ==================== ITEMS ====================

  /// Stream of all items for the current user (real-time)
  Stream<List<Item>> listenToItems(String userId) {
    logD('Starting items listener for user: $userId');
    return _userItemsCollection(userId)
        .orderBy('updatedAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      final items =
          snapshot.docs.map((doc) => _itemFromFirestore(doc)).toList();
      logD('Items updated: ${items.length} items');
      return items;
    }).handleError((error) {
      logE('Items listener error', error: error);
    });
  }

  /// Get items once (for initial load or offline)
  Future<List<Item>> getItems(String userId, {int limit = 100}) async {
    try {
      logD('Fetching items for user: $userId');
      final snapshot = await _userItemsCollection(userId)
          .orderBy('updatedAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.map(_itemFromFirestore).toList();
    } on FirebaseException catch (e) {
      logE('Failed to fetch items', error: e);
      rethrow;
    }
  }

  /// Add a new item
  Future<void> addItem(String userId, Item item) async {
    try {
      logD('Adding item: ${item.id} for user: $userId');
      await _userItemsCollection(userId)
          .doc(item.id)
          .set(_itemToFirestore(item));
      logD('Item added successfully');
    } on FirebaseException catch (e) {
      logE('Failed to add item', error: e);
      rethrow;
    }
  }

  /// Update an existing item
  Future<void> updateItem(String userId, Item item) async {
    try {
      logD('Updating item: ${item.id} for user: $userId');
      await _userItemsCollection(userId)
          .doc(item.id)
          .update(_itemToFirestore(item));
      logD('Item updated successfully');
    } on FirebaseException catch (e) {
      logE('Failed to update item', error: e);
      rethrow;
    }
  }

  /// Delete an item
  Future<void> deleteItem(String userId, String itemId) async {
    try {
      logD('Deleting item: $itemId for user: $userId');
      await _userItemsCollection(userId).doc(itemId).delete();
      logD('Item deleted successfully');
    } on FirebaseException catch (e) {
      logE('Failed to delete item', error: e);
      rethrow;
    }
  }

  /// Search items by text (simple substring search on title/description)
  Future<List<Item>> searchItems(String userId, String query) async {
    if (query.trim().isEmpty) return [];

    try {
      logD('Searching items for user: $userId, query: $query');
      final lowercaseQuery = query.toLowerCase();

      // Firestore doesn't support full-text search natively without extensions
      // This is a simple approach - fetch recent items and filter locally
      // For production, use Algolia, Meilisearch, or Firestore vector search
      final snapshot = await _userItemsCollection(userId)
          .orderBy('updatedAt', descending: true)
          .limit(200)
          .get();

      final results = snapshot.docs
          .map(_itemFromFirestore)
          .where((item) =>
              item.title.toLowerCase().contains(lowercaseQuery) ||
              (item.description?.toLowerCase().contains(lowercaseQuery) ??
                  false) ||
              (item.content?.toLowerCase().contains(lowercaseQuery) ?? false) ||
              item.tags
                  .any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
          .take(50)
          .toList();

      logD('Search found ${results.length} results');
      return results;
    } on FirebaseException catch (e) {
      logE('Search failed', error: e);
      rethrow;
    }
  }

  // ==================== CONVERSION HELPERS ====================

  Map<String, dynamic> _itemToFirestore(Item item) {
    return {
      'id': item.id,
      'userId': item.userId,
      'type': item.type.name,
      'title': item.title,
      'description': item.description,
      'content': item.content,
      'sourceUrl': item.sourceUrl,
      'thumbnailUrl': item.thumbnailUrl,
      'filePath': item.filePath,
      'fileSize': item.fileSize,
      'mimeType': item.mimeType,
      'collectionId': item.collectionId,
      'tags': item.tags,
      'metadata': item.metadata,
      'createdAt': Timestamp.fromDate(item.createdAt.toUtc()),
      'updatedAt': Timestamp.fromDate(item.updatedAt.toUtc()),
      'embedding': item.embedding,
      'summary': item.summary,
      'keyPoints': item.keyPoints,
      'isArchived': item.isArchived,
      'isFavorite': item.isFavorite,
      'version': item.version,
    };
  }

  Item _itemFromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Item(
      id: data['id'] as String,
      userId: data['userId'] as String,
      type: ItemType.values.byName(data['type'] as String),
      title: data['title'] as String,
      description: data['description'] as String?,
      content: data['content'] as String?,
      sourceUrl: data['sourceUrl'] as String?,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      filePath: data['filePath'] as String?,
      fileSize: data['fileSize'] as int?,
      mimeType: data['mimeType'] as String?,
      collectionId: data['collectionId'] as String,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      metadata: (data['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      embedding:
          (data['embedding'] as List<dynamic>?)?.cast<double>()?.toList(),
      summary: data['summary'] as String?,
      keyPoints: (data['keyPoints'] as List<dynamic>?)?.cast<String>() ?? [],
      isArchived: data['isArchived'] as bool? ?? false,
      isFavorite: data['isFavorite'] as bool? ?? false,
      version: data['version'] as int? ?? 1,
    );
  }

  // ==================== USERS ====================

  /// Get the users collection reference
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Get user document reference
  DocumentReference<Map<String, dynamic>> _userDoc(String userId) =>
      _usersCollection.doc(userId);

  /// Get user from Firestore
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      logD('Fetching user: $userId');
      final doc = await _userDoc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } on FirebaseException catch (e) {
      logE('Failed to fetch user', error: e);
      rethrow;
    }
  }

  /// Save user to Firestore
  Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      final userId = userData['id'] as String;
      logD('Saving user: $userId');
      await _userDoc(userId).set(userData);
      logD('User saved successfully');
    } on FirebaseException catch (e) {
      logE('Failed to save user', error: e);
      rethrow;
    }
  }

  /// Update user in Firestore
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      logD('Updating user: $userId');
      await _userDoc(userId).update(userData);
      logD('User updated successfully');
    } on FirebaseException catch (e) {
      logE('Failed to update user', error: e);
      rethrow;
    }
  }

  /// Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      logD('Deleting user: $userId');
      await _userDoc(userId).delete();
      logD('User deleted successfully');
    } on FirebaseException catch (e) {
      logE('Failed to delete user', error: e);
      rethrow;
    }
  }

  /// Watch user changes
  Stream<Map<String, dynamic>?> watchUser(String userId) {
    logD('Starting user listener for: $userId');
    return _userDoc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return doc.data();
      }
      return null;
    }).handleError((error) {
      logE('User listener error', error: error);
    });
  }
}

/// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(FirebaseFirestore.instance);
});
