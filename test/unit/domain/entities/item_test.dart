// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/domain/entities/item.dart';
import 'package:test/test.dart';

void main() {
  group('Item Entity', () {
    late Item testItem;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime.now().toUtc();
      testItem = Item(
        id: 'test-id-123',
        userId: 'user-456',
        type: ItemType.note,
        title: 'Test Note',
        description: 'A test description',
        content: 'Full content of the note',
        sourceUrl: 'https://example.com',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        filePath: '/local/path/file.pdf',
        fileSize: 1024,
        mimeType: 'application/pdf',
        collectionId: 'collection-789',
        tags: ['tag1', 'tag2'],
        metadata: {'key': 'value'},
        createdAt: testDateTime,
        updatedAt: testDateTime,
        embedding: [0.1, 0.2, 0.3],
        summary: 'AI summary',
        keyPoints: ['point1', 'point2'],
        isArchived: false,
        isFavorite: true,
        version: 1,
      );
    });

    test('creates item with all fields', () {
      expect(testItem.id, 'test-id-123');
      expect(testItem.userId, 'user-456');
      expect(testItem.type, ItemType.note);
      expect(testItem.title, 'Test Note');
      expect(testItem.description, 'A test description');
      expect(testItem.content, 'Full content of the note');
      expect(testItem.sourceUrl, 'https://example.com');
      expect(testItem.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(testItem.filePath, '/local/path/file.pdf');
      expect(testItem.fileSize, 1024);
      expect(testItem.mimeType, 'application/pdf');
      expect(testItem.collectionId, 'collection-789');
      expect(testItem.tags, ['tag1', 'tag2']);
      expect(testItem.metadata, {'key': 'value'});
      expect(testItem.createdAt, testDateTime);
      expect(testItem.updatedAt, testDateTime);
      expect(testItem.embedding, [0.1, 0.2, 0.3]);
      expect(testItem.summary, 'AI summary');
      expect(testItem.keyPoints, ['point1', 'point2']);
      expect(testItem.isArchived, false);
      expect(testItem.isFavorite, true);
      expect(testItem.version, 1);
    });

    test('creates item with required fields only', () {
      final item = Item(
        id: 'minimal-id',
        userId: 'user-1',
        type: ItemType.link,
        title: 'Minimal Item',
        collectionId: 'default',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(item.id, 'minimal-id');
      expect(item.type, ItemType.link);
      expect(item.title, 'Minimal Item');
      expect(item.collectionId, 'default');
      expect(item.tags, isEmpty);
      expect(item.metadata, isEmpty);
      expect(item.isArchived, false);
      expect(item.isFavorite, false);
      expect(item.version, 1);
      expect(item.embedding, isNull);
      expect(item.summary, isNull);
      expect(item.keyPoints, isEmpty);
    });

    test('copyWith updates specified fields', () {
      final updated = testItem.copyWith(
        title: 'Updated Title',
        isFavorite: false,
        tags: ['new-tag'],
      );

      expect(updated.title, 'Updated Title');
      expect(updated.isFavorite, false);
      expect(updated.tags, ['new-tag']);
      // Unchanged fields remain the same
      expect(updated.id, testItem.id);
      expect(updated.userId, testItem.userId);
      expect(updated.type, testItem.type);
      expect(updated.description, testItem.description);
    });

    test('copyWith with null values keeps original', () {
      final updated = testItem.copyWith(title: null);

      expect(updated.title, testItem.title);
    });

    test('update creates new item with updated timestamp and incremented version', () {
      final before = DateTime.now().toUtc();
      final updated = testItem.update(
        title: 'New Title',
        description: 'New Description',
      );
      final after = DateTime.now().toUtc();

      expect(updated.title, 'New Title');
      expect(updated.description, 'New Description');
      expect(updated.version, testItem.version + 1);
      expect(updated.updatedAt.isAfter(before), isTrue);
      expect(updated.updatedAt.isBefore(after), isTrue);
      // Original item unchanged
      expect(testItem.title, 'Test Note');
      expect(testItem.version, 1);
    });

    test('fromJson and toJson roundtrip', () {
      final json = testItem.toJson();
      final fromJson = Item.fromJson(json);

      expect(fromJson.id, testItem.id);
      expect(fromJson.userId, testItem.userId);
      expect(fromJson.type, testItem.type);
      expect(fromJson.title, testItem.title);
      expect(fromJson.description, testItem.description);
      expect(fromJson.content, testItem.content);
      expect(fromJson.sourceUrl, testItem.sourceUrl);
      expect(fromJson.thumbnailUrl, testItem.thumbnailUrl);
      expect(fromJson.filePath, testItem.filePath);
      expect(fromJson.fileSize, testItem.fileSize);
      expect(fromJson.mimeType, testItem.mimeType);
      expect(fromJson.collectionId, testItem.collectionId);
      expect(fromJson.tags, testItem.tags);
      expect(fromJson.metadata, testItem.metadata);
      expect(fromJson.createdAt, testItem.createdAt);
      expect(fromJson.updatedAt, testItem.updatedAt);
      expect(fromJson.embedding, testItem.embedding);
      expect(fromJson.summary, testItem.summary);
      expect(fromJson.keyPoints, testItem.keyPoints);
      expect(fromJson.isArchived, testItem.isArchived);
      expect(fromJson.isFavorite, testItem.isFavorite);
      expect(fromJson.version, testItem.version);
    });

    test('equality works correctly', () {
      final item1 = Item(
        id: 'same-id',
        userId: 'user-1',
        type: ItemType.note,
        title: 'Title',
        collectionId: 'col-1',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final item2 = Item(
        id: 'same-id',
        userId: 'user-1',
        type: ItemType.note,
        title: 'Title',
        collectionId: 'col-1',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final item3 = Item(
        id: 'different-id',
        userId: 'user-1',
        type: ItemType.note,
        title: 'Title',
        collectionId: 'col-1',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
      expect(item1.hashCode, equals(item2.hashCode));
    });

    test('toString contains relevant info', () {
      final str = testItem.toString();
      expect(str, contains('test-id-123'));
      expect(str, contains('Test Note'));
      expect(str, contains('note'));
      expect(str, contains('collection-789'));
    });
  });

  group('ItemType', () {
    test('displayName returns correct values', () {
      expect(ItemType.note.displayName, 'Note');
      expect(ItemType.article.displayName, 'Article');
      expect(ItemType.link.displayName, 'Link');
      expect(ItemType.pdf.displayName, 'PDF');
      expect(ItemType.image.displayName, 'Image');
      expect(ItemType.audio.displayName, 'Audio');
      expect(ItemType.video.displayName, 'Video');
      expect(ItemType.task.displayName, 'Task');
      expect(ItemType.contact.displayName, 'Contact');
      expect(ItemType.event.displayName, 'Event');
      expect(ItemType.code.displayName, 'Code');
      expect(ItemType.other.displayName, 'Other');
    });
  });
}