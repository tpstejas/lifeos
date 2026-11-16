// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/remote/firestore_service.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/core/di/providers.dart';

/// Library page - Browse and search saved items
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> with LoggerMixin {
  String _selectedCollection = 'all';
  String _searchQuery = '';

  final List<String> _collections = [
    'all',
    'tasks',
    'learning',
    'references',
    'ideas',
    'opportunities',
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userId = authState.userId;

    // Watch items from Firestore
    final itemsAsync = ref.watch(itemsStreamProvider(userId ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _buildCollectionTabs(),
        ),
      ),
      body: _buildBody(itemsAsync),
      floatingActionButton: FloatingActionButton(
        onPressed: () => logD('Add item tapped'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCollectionTabs() {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _collections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final collection = _collections[index];
          final isSelected = collection == _selectedCollection;
          return FilterChip(
            label: Text(_formatCollectionName(collection)),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedCollection = collection),
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : null,
              fontWeight: isSelected ? FontWeight.w600 : null,
            ),
          );
        },
      ),
    );
  }

  String _formatCollectionName(String collection) {
    return collection[0].toUpperCase() + collection.substring(1);
  }

  Widget _buildBody(AsyncValue<List<Item>> itemsAsync) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search your library...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),

        // Items list
        Expanded(
          child: itemsAsync.when(
            data: (items) {
              // Apply filters
              var filteredItems = items.where((item) {
                // Collection filter
                if (_selectedCollection != 'all' &&
                    item.collectionId != _selectedCollection) {
                  return false;
                }
                // Search filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  if (!item.title.toLowerCase().contains(query) &&
                      !(item.description?.toLowerCase().contains(query) ??
                          false) &&
                      !(item.content?.toLowerCase().contains(query) ?? false) &&
                      !item.tags
                          .any((tag) => tag.toLowerCase().contains(query))) {
                    return false;
                  }
                }
                return true;
              }).toList();

              if (filteredItems.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return _LibraryItemCard(
                    title: item.title,
                    subtitle: item.description ?? item.content ?? '',
                    collection: item.collectionId,
                    tags: item.tags,
                    onTap: () => context.go('/library/item/${item.id}'),
                  );
                },
              );
            },
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No results found'
                  : 'Your library is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Capture something to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_searchQuery.isEmpty)
              FilledButton.icon(
                onPressed: () => logD('Add item tapped'),
                icon: const Icon(Icons.add),
                label: const Text('Add your first item'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load items',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.invalidate(itemsStreamProvider('')),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Library item card
class _LibraryItemCard extends StatelessWidget {
  const _LibraryItemCard({
    required this.title,
    required this.subtitle,
    required this.collection,
    required this.tags,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String collection;
  final List<String> tags;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final collectionColor = _getCollectionColor(collection);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: collectionColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      collection,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: collectionColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () =>
                        AppLogger.d('More options tapped', tag: 'LibraryPage'),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          visualDensity: VisualDensity.compact,
                          labelStyle: theme.textTheme.labelSmall,
                          side: BorderSide.none,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCollectionColor(String collection) {
    switch (collection) {
      case 'tasks':
        return Colors.blue;
      case 'learning':
        return Colors.green;
      case 'references':
        return Colors.purple;
      case 'ideas':
        return Colors.orange;
      case 'opportunities':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
