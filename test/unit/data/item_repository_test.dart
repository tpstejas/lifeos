// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';
import 'package:test/test.dart';

import 'fake_item_repository.dart';

void main() {
  group('ItemRepository (Fake Implementation)', () {
    late FakeItemRepository repository;
    late DateTime testDateTime;

    setUp(() {
      repository = FakeItemRepository();
      testDateTime = DateTime.now().toUtc();
    });

    Item createTestItem({
      String id = 'item-1',
      String userId = 'user-1',
      ItemType type = ItemType.note,
      String title = 'Test Item',
      String? description,
      String collectionId = 'default',
      List<String> tags = const [],
      bool isArchived = false,
      bool isFavorite = false,
      List<double>? embedding,
    }) {
      return Item(
        id: id,
        userId: userId,
        type: type,
        title: title,
        description: description,
        collectionId: collectionId,
        tags: tags,
        createdAt: testDateTime,
        updatedAt: testDateTime,
        embedding: embedding,
        isArchived: isArchived,
        isFavorite: isFavorite,
      );
    }

    test('getById returns item when exists', () async {
      final item = createTestItem(id: 'test-1');
      repository.addItem(item);

      final result = await repository.getById('test-1');

      expect(result, isNotNull);
      expect(result!.id, 'test-1');
      expect(result.title, 'Test Item');
    });

    test('getById returns null when not exists', () async {
      final result = await repository.getById('non-existent');
      expect(result, isNull);
    });

    test('getAll returns all items for user', () async {
      repository.addItem(createTestItem(id: '1', userId: 'user-1'));
      repository.addItem(createTestItem(id: '2', userId: 'user-1'));
      repository.addItem(createTestItem(id: '3', userId: 'user-2'));

      final results = await repository.getAll(userId: 'user-1');

      expect(results.length, 2);
      expect(results.map((e) => e.id).toSet(), {'1', '2'});
    });

    test('getAll filters by collectionId', () async {
      repository.addItem(createTestItem(id: '1', collectionId: 'col-a'));
      repository.addItem(createTestItem(id: '2', collectionId: 'col-b'));
      repository.addItem(createTestItem(id: '3', collectionId: 'col-a'));

      final results = await repository.getAll(collectionId: 'col-a');

      expect(results.length, 2);
      expect(results.every((e) => e.collectionId == 'col-a'), isTrue);
    });

    test('getAll filters by type', () async {
      repository.addItem(createTestItem(id: '1', type: ItemType.note));
      repository.addItem(createTestItem(id: '2', type: ItemType.link));
      repository.addItem(createTestItem(id: '3', type: ItemType.note));

      final results = await repository.getAll(type: ItemType.note);

      expect(results.length, 2);
      expect(results.every((e) => e.type == ItemType.note), isTrue);
    });

    test('getAll filters by isArchived', () async {
      repository.addItem(createTestItem(id: '1', isArchived: false));
      repository.addItem(createTestItem(id: '2', isArchived: true));
      repository.addItem(createTestItem(id: '3', isArchived: false));

      final results = await repository.getAll(isArchived: true);

      expect(results.length, 1);
      expect(results.first.id, '2');
    });

    test('getAll filters by isFavorite', () async {
      repository.addItem(createTestItem(id: '1', isFavorite: false));
      repository.addItem(createTestItem(id: '2', isFavorite: true));
      repository.addItem(createTestItem(id: '3', isFavorite: true));

      final results = await repository.getAll(isFavorite: true);

      expect(results.length, 2);
      expect(results.every((e) => e.isFavorite), isTrue);
    });

    test('getAll filters by searchQuery', () async {
      repository.addItem(createTestItem(id: '1', title: 'Dart Tutorial', tags: ['programming']));
      repository.addItem(createTestItem(id: '2', title: 'Flutter Guide', tags: ['mobile']));
      repository.addItem(createTestItem(id: '3', title: 'Python Basics', tags: ['programming']));

      final results = await repository.getAll(searchQuery: 'dart');

      expect(results.length, 1);
      expect(results.first.id, '1');
    });

    test('getAll searchQuery matches tags', () async {
      repository.addItem(createTestItem(id: '1', title: 'Item 1', tags: ['work']));
      repository.addItem(createTestItem(id: '2', title: 'Item 2', tags: ['personal']));
      repository.addItem(createTestItem(id: '3', title: 'Item 3', tags: ['work', 'urgent']));

      final results = await repository.getAll(searchQuery: 'work');

      expect(results.length, 2);
      expect(results.map((e) => e.id).toSet(), {'1', '3'});
    });

    test('getAll applies limit and offset', () async {
      repository.addItem(createTestItem(id: '1'));
      repository.addItem(createTestItem(id: '2'));
      repository.addItem(createTestItem(id: '3'));
      repository.addItem(createTestItem(id: '4'));
      repository.addItem(createTestItem(id: '5'));

      final page1 = await repository.getAll(limit: 2, offset: 0);
      final page2 = await repository.getAll(limit: 2, offset: 2);

      expect(page1.length, 2);
      expect(page2.length, 2);
      expect(page1.map((e) => e.id).toSet().intersection(page2.map((e) => e.id).toSet()), isEmpty);
    });

    test('getAll sorts by updatedAt descending', () async {
      final now = DateTime.now().toUtc();
      final item1 = createTestItem(id: '1', title: 'Oldest');
      final item2 = createTestItem(id: '2', title: 'Middle');
      final item3 = createTestItem(id: '3', title: 'Newest');

      // Manually set different timestamps
      repository.addItem(item1.copyWith(updatedAt: now.subtract(const Duration(days: 2))));
      repository.addItem(item2.copyWith(updatedAt: now.subtract(const Duration(days: 1))));
      repository.addItem(item3.copyWith(updatedAt: now));

      final results = await repository.getAll();

      expect(results[0].title, 'Newest');
      expect(results[1].title, 'Middle');
      expect(results[2].title, 'Oldest');
    });

    test('save adds new item', () async {
      final item = createTestItem(id: 'new-item');
      await repository.save(item);

      final result = await repository.getById('new-item');
      expect(result, isNotNull);
      expect(result!.title, 'Test Item');
    });

    test('save updates existing item', () async {
      final item = createTestItem(id: 'update-me', title: 'Original');
      repository.addItem(item);

      final updated = item.copyWith(title: 'Updated', version: 2);
      await repository.save(updated);

      final result = await repository.getById('update-me');
      expect(result!.title, 'Updated');
      expect(result.version, 2);
    });

    test('delete removes item', () async {
      repository.addItem(createTestItem(id: 'to-delete'));
      expect(await repository.getById('to-delete'), isNotNull);

      await repository.delete('to-delete');
      expect(await repository.getById('to-delete'), isNull);
    });

    test('saveAll adds multiple items', () async {
      final items = [
        createTestItem(id: '1'),
        createTestItem(id: '2'),
        createTestItem(id: '3'),
      ];
      await repository.saveAll(items);

      final results = await repository.getAll();
      expect(results.length, 3);
    });

    test('deleteAll removes multiple items', () async {
      repository.addItem(createTestItem(id: '1'));
      repository.addItem(createTestItem(id: '2'));
      repository.addItem(createTestItem(id: '3'));

      await repository.deleteAll(['1', '3']);

      final results = await repository.getAll();
      expect(results.length, 1);
      expect(results.first.id, '2');
    });

    test('search delegates to getAll with searchQuery', () async {
      repository.addItem(createTestItem(id: '1', title: 'Hello World'));
      repository.addItem(createTestItem(id: '2', title: 'Goodbye World'));
      repository.addItem(createTestItem(id: '3', title: 'Hello There'));

      final results = await repository.search('Hello');

      expect(results.length, 2);
      expect(results.map((e) => e.id).toSet(), {'1', '3'});
    });

    test('getByCollection returns items in collection', () async {
      repository.addItem(createTestItem(id: '1', collectionId: 'col-1'));
      repository.addItem(createTestItem(id: '2', collectionId: 'col-2'));
      repository.addItem(createTestItem(id: '3', collectionId: 'col-1'));

      final results = await repository.getByCollection('col-1');

      expect(results.length, 2);
      expect(results.every((e) => e.collectionId == 'col-1'), isTrue);
    });

    test('getFavorites returns only favorite items', () async {
      repository.addItem(createTestItem(id: '1', isFavorite: true));
      repository.addItem(createTestItem(id: '2', isFavorite: false));
      repository.addItem(createTestItem(id: '3', isFavorite: true));

      final results = await repository.getFavorites();

      expect(results.length, 2);
      expect(results.every((e) => e.isFavorite), isTrue);
    });

    test('getRecent returns recent items with default limit', () async {
      for (int i = 0; i < 25; i++) {
        repository.addItem(createTestItem(id: 'item-$i'));
      }

      final results = await repository.getRecent();

      expect(results.length, 20); // default limit
    });

    test('getItemsNeedingEmbedding returns items without embeddings', () async {
      repository.addItem(createTestItem(id: '1', embedding: [0.1, 0.2]));
      repository.addItem(createTestItem(id: '2', embedding: null));
      repository.addItem(createTestItem(id: '3', embedding: []));
      repository.addItem(createTestItem(id: '4', embedding: [0.3, 0.4]));

      final results = await repository.getItemsNeedingEmbedding();

      expect(results.length, 2);
      expect(results.map((e) => e.id).toSet(), {'2', '3'});
    });

    test('updateEmbedding updates item embedding', () async {
      final item = createTestItem(id: 'embed-me', embedding: null);
      repository.addItem(item);

      await repository.updateEmbedding('embed-me', [0.5, 0.6, 0.7]);

      final result = await repository.getById('embed-me');
      expect(result!.embedding, [0.5, 0.6, 0.7]);
    });

    test('updateAiAnalysis updates summary and keyPoints', () async {
      final item = createTestItem(id: 'analyze-me');
      repository.addItem(item);

      await repository.updateAiAnalysis('analyze-me',
          summary: 'AI Summary',
          keyPoints: ['Point 1', 'Point 2']);

      final result = await repository.getById('analyze-me');
      expect(result!.summary, 'AI Summary');
      expect(result.keyPoints, ['Point 1', 'Point 2']);
    });

    test('setArchived toggles archive status', () async {
      final item = createTestItem(id: 'archive-me', isArchived: false);
      repository.addItem(item);

      await repository.setArchived('archive-me', true);
      var result = await repository.getById('archive-me');
      expect(result!.isArchived, true);

      await repository.setArchived('archive-me', false);
      result = await repository.getById('archive-me');
      expect(result!.isArchived, false);
    });

    test('setFavorite toggles favorite status', () async {
      final item = createTestItem(id: 'fav-me', isFavorite: false);
      repository.addItem(item);

      await repository.setFavorite('fav-me', true);
      var result = await repository.getById('fav-me');
      expect(result!.isFavorite, true);

      await repository.setFavorite('fav-me', false);
      result = await repository.getById('fav-me');
      expect(result!.isFavorite, false);
    });

    test('moveToCollection changes item collection', () async {
      final item = createTestItem(id: 'move-me', collectionId: 'old-col');
      repository.addItem(item);

      await repository.moveToCollection('move-me', 'new-col');

      final result = await repository.getById('move-me');
      expect(result!.collectionId, 'new-col');
    });

    test('getCountsByCollection returns correct counts', () async {
      repository.addItem(createTestItem(id: '1', userId: 'user-1', collectionId: 'col-a'));
      repository.addItem(createTestItem(id: '2', userId: 'user-1', collectionId: 'col-a'));
      repository.addItem(createTestItem(id: '3', userId: 'user-1', collectionId: 'col-b'));
      repository.addItem(createTestItem(id: '4', userId: 'user-2', collectionId: 'col-a'));

      final counts = await repository.getCountsByCollection('user-1');

      expect(counts['col-a'], 2);
      expect(counts['col-b'], 1);
      expect(counts.containsKey('col-c'), isFalse);
    });

    test('getModifiedAfter returns items modified after timestamp', () async {
      // Use a fixed base time to avoid timing issues
      final baseTime = DateTime.parse('2024-01-15T12:00:00.000Z');
      final threshold = baseTime.subtract(const Duration(minutes: 90)); // 1.5 hours ago = 10:30

      // Create items directly with specific updatedAt timestamps
      final item1 = Item(
        id: '1',
        userId: 'user-1',
        type: ItemType.note,
        title: 'Item 1',
        collectionId: 'default',
        createdAt: baseTime.subtract(const Duration(hours: 3)),
        updatedAt: baseTime.subtract(const Duration(hours: 2)), // 10:00 - BEFORE threshold
      );
      final item2 = Item(
        id: '2',
        userId: 'user-1',
        type: ItemType.note,
        title: 'Item 2',
        collectionId: 'default',
        createdAt: baseTime.subtract(const Duration(hours: 2)),
        updatedAt: baseTime.subtract(const Duration(hours: 1)), // 11:00 - AFTER threshold
      );
      final item3 = Item(
        id: '3',
        userId: 'user-1',
        type: ItemType.note,
        title: 'Item 3',
        collectionId: 'default',
        createdAt: baseTime.subtract(const Duration(hours: 1)),
        updatedAt: baseTime, // 12:00 - AFTER threshold
      );

      repository.addItem(item1);
      repository.addItem(item2);
      repository.addItem(item3);

      final results = await repository.getModifiedAfter(threshold);

      expect(results.length, 2);
      expect(results.map((e) => e.id).toSet(), {'2', '3'});
    });
  });
}