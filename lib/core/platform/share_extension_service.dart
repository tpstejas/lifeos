// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/platform/share_extension.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Service to handle shared items from share extension
class ShareExtensionService {
  final ItemRepository _itemRepository;

  ShareExtensionService(this._itemRepository);

  /// Check for and process pending shared items
  /// Returns the number of items processed
  Future<int> processPendingSharedItems() async {
    final hasItems = await ShareExtensionChannel.hasPendingSharedItems();
    if (!hasItems) return 0;

    final sharedItems = await ShareExtensionChannel.getPendingSharedItems();
    if (sharedItems.isEmpty) return 0;

    int processedCount = 0;
    for (final sharedItem in sharedItems) {
      try {
        await _processSharedItem(sharedItem);
        processedCount++;
      } catch (e) {
        // Log error but continue processing other items
        print('ShareExtensionService: Failed to process shared item: $e');
      }
    }

    return processedCount;
  }

  Future<void> _processSharedItem(SharedItem sharedItem) async {
    final now = DateTime.now();
    final item = Item(
      id: 'shared_${now.millisecondsSinceEpoch}',
      userId: 'current_user', // Will be replaced with actual user ID
      type: _mapType(sharedItem.type),
      title: _generateTitle(sharedItem),
      description: sharedItem.text,
      content: sharedItem.text,
      sourceUrl: sharedItem.url,
      filePath: sharedItem.imagePath ?? sharedItem.fileURL,
      collectionId: _getCollectionForType(sharedItem.type),
      tags: _generateTags(sharedItem),
      metadata: {
        'source': sharedItem.source,
        'sharedAt': sharedItem.timestamp.toIso8601String(),
        'originalType': sharedItem.type,
      },
      createdAt: now,
      updatedAt: now,
      isArchived: false,
      isFavorite: false,
    );

    await _itemRepository.save(item);
  }

  ItemType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'link':
        return ItemType.link;
      case 'task':
        return ItemType.task;
      case 'image':
        return ItemType.image;
      case 'pdf':
        return ItemType.pdf;
      case 'file':
        return ItemType.other;
      case 'note':
      default:
        return ItemType.note;
    }
  }

  String _generateTitle(SharedItem sharedItem) {
    if (sharedItem.text != null && sharedItem.text!.isNotEmpty) {
      final text = sharedItem.text!.trim();
      if (text.length > 50) {
        return '${text.substring(0, 50)}...';
      }
      return text;
    }
    if (sharedItem.url != null) {
      return 'Shared Link';
    }
    if (sharedItem.imagePath != null) {
      return 'Shared Image';
    }
    if (sharedItem.fileURL != null) {
      return 'Shared File';
    }
    return 'Shared Item';
  }

  String _getCollectionForType(String type) {
    switch (type.toLowerCase()) {
      case 'task':
        return 'tasks';
      case 'link':
        return 'references';
      case 'pdf':
        return 'learning';
      case 'image':
        return 'references';
      case 'note':
      default:
        return 'inbox';
    }
  }

  List<String> _generateTags(SharedItem sharedItem) {
    final tags = <String>['shared'];
    
    if (sharedItem.type == 'task') {
      tags.addAll(['task', 'action-required']);
    }
    if (sharedItem.type == 'link') {
      tags.add('link');
    }
    if (sharedItem.type == 'pdf') {
      tags.add('pdf');
    }
    if (sharedItem.type == 'image') {
      tags.add('image');
    }
    
    return tags;
  }
}

/// Provider for ShareExtensionService
final shareExtensionServiceProvider = Provider<ShareExtensionService>((ref) {
  final itemRepository = ref.watch(itemRepositoryProvider);
  return ShareExtensionService(itemRepository);
});
