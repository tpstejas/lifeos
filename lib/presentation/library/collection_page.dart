// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/enums.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';
import 'package:lifeos/presentation/library/item_detail_page.dart';

/// Collection page - Browse items in a specific collection
class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key, required this.collection});

  final String collection;

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> with LoggerMixin {
  String _searchQuery = '';
  String _sortBy = 'updatedAt';
  bool _sortDescending = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userId = authState.userId;

    // Watch items from the repository
    final itemsAsync = ref.watch(itemsByCollectionProvider((userId: userId ?? '', collection: widget.collection)));

    return Scaffold(
      appBar: AppBar(
        title: Text(_formatCollectionName(widget.collection)),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in ${_formatCollectionName(widget.collection)}...',
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
                // Apply search filter
                var filteredItems = items.where((item) {
                  if (_searchQuery.isEmpty) return true;
                  final query = _searchQuery.toLowerCase();
                  return item.title.toLowerCase().contains(query) ||
                      (item.description?.toLowerCase().contains(query) ?? false) ||
                      (item.content?.toLowerCase().contains(query) ?? false) ||
                      item.tags.any((tag) => tag.toLowerCase().contains(query));
                }).toList();

                // Apply sort
                filteredItems.sort((a, b) {
                  int comparison = 0;
                  switch (_sortBy) {
                    case 'title':
                      comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
                      break;
                    case 'createdAt':
                      comparison = a.createdAt.compareTo(b.createdAt);
                      break;
                    case 'updatedAt':
                    default:
                      comparison = a.updatedAt.compareTo(b.updatedAt);
                      break;
                  }
                  return _sortDescending ? -comparison : comparison;
                });

                if (filteredItems.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _CollectionItemCard(
                      item: item,
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
      ),
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
              Icons.folder_open,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? 'No results found' : 'No items in this collection',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search'
                  : 'Capture something to add to this collection',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
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
              onPressed: () => ref.invalidate(itemsByCollectionProvider((userId: '', collection: widget.collection))),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort by'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Radio<String>(
                value: 'updatedAt',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                },
              ),
              title: const Text('Last Updated'),
              onTap: () {
                setState(() => _sortBy = 'updatedAt');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Radio<String>(
                value: 'createdAt',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                },
              ),
              title: const Text('Date Created'),
              onTap: () {
                setState(() => _sortBy = 'createdAt');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Radio<String>(
                value: 'title',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                },
              ),
              title: const Text('Title (A-Z)'),
              onTap: () {
                setState(() => _sortBy = 'title');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(
                  _sortDescending ? Icons.arrow_downward : Icons.arrow_upward,
                ),
                onPressed: () {
                  setState(() => _sortDescending = !_sortDescending);
                  Navigator.pop(context);
                },
              ),
              title: Text(_sortDescending ? 'Descending' : 'Ascending'),
              onTap: () {
                setState(() => _sortDescending = !_sortDescending);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Filter by'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Voice Notes'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter by source
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Links'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter by source
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Files'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter by source
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Text Notes'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter by source
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Active'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter by status
              },
            ),
            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('Inbox'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter by status
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archived'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter by status
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatCollectionName(String collection) {
    return collection[0].toUpperCase() + collection.substring(1);
  }
}

/// Collection item card
class _CollectionItemCard extends StatelessWidget {
  const _CollectionItemCard({
    required this.item,
    required this.onTap,
  });

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final collectionColor = _getCollectionColor(item.collectionId ?? '');

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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: collectionColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.collectionId ?? 'Uncategorized',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: collectionColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _SourceIndicator(type: item.type),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (item.description != null && item.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (item.content != null && item.content!.isNotEmpty)
                    _ContentTypeBadge(type: item.type),
                  const Spacer(),
                  Text(
                    _formatDate(item.updatedAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: item.tags
                      .take(5)
                      .map((tag) => Chip(
                            label: Text(tag),
                            visualDensity: VisualDensity.compact,
                            labelStyle: theme.textTheme.labelSmall,
                            side: BorderSide.none,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ))
                      .toList(),
                ),
                if (item.tags.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${item.tags.length - 5} more',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);
    final diff = itemDate.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 0 && diff <= 7) {
      return [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ][date.weekday - 1];
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Source indicator widget
class _SourceIndicator extends StatelessWidget {
  const _SourceIndicator({required this.type});

  final ItemType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getTypeColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(type), size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            type.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(ItemType type) {
    return type.color;
  }

  IconData _getTypeIcon(ItemType type) {
    return type.icon;
  }
}

/// Content type badge
class _ContentTypeBadge extends StatelessWidget {
  const _ContentTypeBadge({required this.type});

  final ItemType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getTypeColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(type), size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            type.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(ItemType type) {
    return type.color;
  }

  IconData _getTypeIcon(ItemType type) {
    return type.icon;
  }
}