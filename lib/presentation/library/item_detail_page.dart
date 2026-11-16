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

/// Item detail page - View and edit a single item
class ItemDetailPage extends ConsumerStatefulWidget {
  const ItemDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends ConsumerState<ItemDetailPage> with LoggerMixin {
  Item? _item;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  bool _isArchived = false;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _loadItem() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(itemRepositoryProvider);
      final item = await repository.getById(widget.itemId);
      if (mounted) {
        setState(() {
          _item = item;
          if (item != null) {
            _titleController.text = item.title;
            _descriptionController.text = item.description ?? '';
            _contentController.text = item.content ?? '';
            _tags = item.tags;
            _tagsController.text = item.tags.join(', ');
            _isArchived = item.isArchived;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      logE('Failed to load item', error: e);
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Failed to load item');
      }
    }
  }

  Future<void> _saveItem() async {
    if (_item == null) return;

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(itemRepositoryProvider);
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final updatedItem = _item!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        content: _contentController.text.trim().isEmpty
            ? null
            : _contentController.text.trim(),
        isArchived: _isArchived,
        tags: tags,
        updatedAt: DateTime.now(),
      );

      await repository.save(updatedItem);

      if (mounted) {
        setState(() {
          _item = updatedItem;
          _tags = tags;
          _isEditing = false;
          _isSaving = false;
        });
        _showSnackBar('Item saved!');
      }
    } catch (e) {
      logE('Failed to save item', error: e);
      if (mounted) {
        setState(() => _isSaving = false);
        _showSnackBar('Failed to save: $e');
      }
    }
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && _item != null) {
      try {
        final repository = ref.read(itemRepositoryProvider);
        await repository.delete(_item!.id);
        if (mounted) {
          context.pop();
          _showSnackBar('Item deleted');
        }
      } catch (e) {
        logE('Failed to delete item', error: e);
        if (mounted) {
          _showSnackBar('Failed to delete: $e');
        }
      }
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item Detail')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Item not found'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _isEditing
            ? TextField(
                controller: _titleController,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
              )
            : Text(_item!.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (!_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEdit,
              tooltip: 'Edit',
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') _deleteItem();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            TextButton(
              onPressed: _isSaving ? null : () {
                setState(() => _isEditing = false);
                _loadItem(); // Reset to original
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: _isSaving ? null : _saveItem,
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Archived badge
            _ArchivedBadge(isArchived: _item!.isArchived, onChanged: _isEditing ? (v) => setState(() => _isArchived = v) : null),
            const SizedBox(height: 16),

            // Description
            if (_item!.description != null && _item!.description!.isNotEmpty) ...[
              _buildSection(
                'Description',
                _isEditing
                    ? TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add description...',
                        ),
                        maxLines: 3,
                      )
                    : Text(_item!.description!, style: theme.textTheme.bodyLarge),
              ),
              const SizedBox(height: 16),
            ],

            // Content
            if (_item!.content != null && _item!.content!.isNotEmpty) ...[
              _buildSection(
                'Content',
                _isEditing
                    ? TextField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add content...',
                        ),
                        maxLines: 5,
                      )
                    : _buildContentDisplay(_item!),
              ),
              const SizedBox(height: 16),
            ],

            // Tags
            _buildSection(
              'Tags',
              _isEditing
                  ? TextField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'work, ideas, learning',
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
            ),
            const SizedBox(height: 16),

            // Metadata
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metadata',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _MetadataRow(
                      label: 'Source',
                      value: _item!.type.displayName,
                      icon: _getSourceIcon(_item!.type),
                    ),
                    _MetadataRow(
                      label: 'Created',
                      value: _formatDateTime(_item!.createdAt),
                      icon: Icons.calendar_today,
                    ),
                    _MetadataRow(
                      label: 'Updated',
                      value: _formatDateTime(_item!.updatedAt),
                      icon: Icons.update,
                    ),
                    if (_item!.collectionId != null)
                      _MetadataRow(
                        label: 'Collection',
                        value: _item!.collectionId!,
                        icon: Icons.folder,
                      ),
                    if (_item!.embedding != null)
                      _MetadataRow(
                        label: 'Embedding',
                        value: 'Generated (${_item!.embedding!.length} dims)',
                        icon: Icons.psychology,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildContentDisplay(Item item) {
    final theme = Theme.of(context);
    final isLink = item.type == ItemType.link;

    if (isLink) {
      return InkWell(
        onTap: () => _launchUrl(item.content!),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.link, color: theme.colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open Link',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      item.content!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: SelectableText(
        item.content!,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  IconData _getSourceIcon(ItemType type) {
    switch (type) {
      case ItemType.audio:
        return Icons.mic;
      case ItemType.link:
        return Icons.link;
      case ItemType.pdf:
      case ItemType.image:
        return Icons.attach_file;
      case ItemType.note:
      default:
        return Icons.edit;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _launchUrl(String url) async {
    // TODO: Implement URL launching
    logD('Launch URL: $url');
  }
}

/// Archived badge widget
class _ArchivedBadge extends StatelessWidget {
  const _ArchivedBadge({
    required this.isArchived,
    this.onChanged,
  });

  final bool isArchived;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(
          value: false,
          label: Text('Active'),
          icon: Icon(Icons.check_circle_outline),
        ),
        ButtonSegment(
          value: true,
          label: Text('Archived'),
          icon: Icon(Icons.archive),
        ),
      ],
      selected: {isArchived},
      onSelectionChanged: onChanged != null
          ? (selection) => onChanged!(selection.first)
          : null,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.primaryContainer;
          }
          return theme.colorScheme.surfaceContainerHighest;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.onPrimaryContainer;
          }
          return theme.colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }
}

/// Metadata row widget
class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}