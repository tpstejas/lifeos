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

/// Capture page - Create new items via voice, text, link, or file
class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({super.key, required this.captureType});

  final String captureType;

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> with LoggerMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  ItemSource _source = ItemSource.text;
  ItemStatus _status = ItemStatus.inbox;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _source = _getSourceFromType(widget.captureType);
    if (_source == ItemSource.link) {
      _urlController.text = 'https://';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _urlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  ItemSource _getSourceFromType(String type) {
    switch (type) {
      case 'voice':
        return ItemSource.voice;
      case 'link':
        return ItemSource.link;
      case 'file':
        return ItemSource.file;
      default:
        return ItemSource.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Capture: ${_source.name[0].toUpperCase()}${_source.name.substring(1)}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source indicator
            _SourceIndicator(source: _source),
            const SizedBox(height: 24),

            // Title field
            if (_source != ItemSource.voice) ...[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: _getTitleHint(),
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
            ],

            // Content/URL field based on source
            _buildContentField(),

            const SizedBox(height: 24),

            // Tags field
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'work, ideas, learning',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.tag),
              ),
            ),

            const SizedBox(height: 24),

            // Status selector
            Text(
              'Status',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<ItemStatus>(
              segments: const [
                ButtonSegment(
                  value: ItemStatus.inbox,
                  label: Text('Inbox'),
                  icon: Icon(Icons.inbox),
                ),
                ButtonSegment(
                  value: ItemStatus.active,
                  label: Text('Active'),
                  icon: Icon(Icons.check_circle_outline),
                ),
                ButtonSegment(
                  value: ItemStatus.archived,
                  label: Text('Archived'),
                  icon: Icon(Icons.archive),
                ),
              ],
              selected: {_status},
              onSelectionChanged: (selection) {
                setState(() => _status = selection.first);
              },
            ),

            const SizedBox(height: 24),

            // Quick actions
            if (_source == ItemSource.voice) ...[
              _VoiceRecorderPlaceholder(onRecordingComplete: _onVoiceRecordingComplete),
            ],
            if (_source == ItemSource.file) ...[
              _FilePickerPlaceholder(onFileSelected: _onFileSelected),
            ],
            if (_source == ItemSource.link) ...[
              _LinkPreviewPlaceholder(url: _urlController.text),
            ],
          ],
        ),
      ),
    );
  }

  String _getTitleHint() {
    switch (_source) {
      case ItemSource.text:
        return 'What\'s on your mind?';
      case ItemSource.link:
        return 'Article, video, or resource title';
      case ItemSource.file:
        return 'Document or image title';
      case ItemSource.voice:
        return '';
    }
  }

  Widget _buildContentField() {
    switch (_source) {
      case ItemSource.text:
        return TextField(
          controller: _contentController,
          decoration: const InputDecoration(
            labelText: 'Content',
            hintText: 'Write your note here...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 8,
          textCapitalization: TextCapitalization.sentences,
        );
      case ItemSource.link:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Why did you save this?',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        );
      case ItemSource.file:
        return TextField(
          controller: _contentController,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            hintText: 'Describe the file...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        );
      case ItemSource.voice:
        return const SizedBox.shrink();
    }
  }

  Future<void> _saveItem() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final url = _urlController.text.trim();
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    // Validation
    if (_source != ItemSource.voice && title.isEmpty) {
      _showSnackBar('Please enter a title');
      return;
    }
    if (_source == ItemSource.link && !url.startsWith('http')) {
      _showSnackBar('Please enter a valid URL');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(itemRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final userId = authState.userId ?? 'anonymous';

      // Map capture type to ItemType
      final itemType = _getItemTypeFromSource(_source);

      final item = Item(
        id: '', // Will be generated by repository
        userId: userId,
        type: itemType,
        title: title.isEmpty ? _getDefaultTitle(itemType) : title,
        description: content.isEmpty ? null : content,
        content: _source == ItemSource.link ? url : (content.isEmpty ? null : content),
        sourceUrl: _source == ItemSource.link ? url : null,
        collectionId: '', // Inbox items have empty collectionId
        tags: tags,
        metadata: {'source': _source.name},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.save(item);

      if (mounted) {
        _showSnackBar('Item saved!');
        context.pop();
      }
    } catch (e) {
      logE('Failed to save item', error: e);
      if (mounted) {
        _showSnackBar('Failed to save: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onVoiceRecordingComplete(String audioPath) {
    logD('Voice recording complete: $audioPath');
    // TODO: Implement voice transcription
    _contentController.text = '[Voice recording: $audioPath]';
  }

  void _onFileSelected(String filePath) {
    logD('File selected: $filePath');
    _contentController.text = '[File: $filePath]';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  ItemType _getItemTypeFromSource(ItemSource source) {
    switch (source) {
      case ItemSource.voice:
        return ItemType.audio;
      case ItemSource.link:
        return ItemType.link;
      case ItemSource.file:
        return ItemType.pdf; // Could be image, pdf, etc.
      case ItemSource.text:
      default:
        return ItemType.note;
    }
  }

  String _getDefaultTitle(ItemType type) {
    switch (type) {
      case ItemType.audio:
        return 'Voice Note ${DateTime.now().toString().substring(0, 16)}';
      case ItemType.link:
        return 'Link ${DateTime.now().toString().substring(0, 16)}';
      case ItemType.pdf:
        return 'File ${DateTime.now().toString().substring(0, 16)}';
      case ItemType.note:
      default:
        return 'Note ${DateTime.now().toString().substring(0, 16)}';
    }
  }
}

/// Source indicator widget
class _SourceIndicator extends StatelessWidget {
  const _SourceIndicator({required this.source});

  final ItemSource source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getSourceColor(source);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_getSourceIcon(source), color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            'Capturing as ${source.name}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSourceColor(ItemSource source) {
    switch (source) {
      case ItemSource.voice:
        return Colors.red;
      case ItemSource.link:
        return Colors.green;
      case ItemSource.file:
        return Colors.orange;
      case ItemSource.text:
      default:
        return Colors.blue;
    }
  }

  IconData _getSourceIcon(ItemSource source) {
    switch (source) {
      case ItemSource.voice:
        return Icons.mic;
      case ItemSource.link:
        return Icons.link;
      case ItemSource.file:
        return Icons.attach_file;
      case ItemSource.text:
      default:
        return Icons.edit;
    }
  }
}

/// Voice recorder placeholder
class _VoiceRecorderPlaceholder extends StatelessWidget {
  const _VoiceRecorderPlaceholder({required this.onRecordingComplete});

  final void Function(String) onRecordingComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.mic_none, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Voice Recording',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to start recording. Transcription will be added automatically.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => onRecordingComplete('voice_recording_${DateTime.now().millisecondsSinceEpoch}.m4a'),
              icon: const Icon(Icons.mic),
              label: const Text('Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}

/// File picker placeholder
class _FilePickerPlaceholder extends StatelessWidget {
  const _FilePickerPlaceholder({required this.onFileSelected});

  final void Function(String) onFileSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.attach_file, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'File Attachment',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a file, image, or document to attach.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onFileSelected('image_${DateTime.now().millisecondsSinceEpoch}.jpg'),
                    icon: const Icon(Icons.photo),
                    label: const Text('Image'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onFileSelected('document_${DateTime.now().millisecondsSinceEpoch}.pdf'),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Document'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Link preview placeholder
class _LinkPreviewPlaceholder extends StatelessWidget {
  const _LinkPreviewPlaceholder({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isValidUrl = url.startsWith('http') && url.length > 8;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Link Preview',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (isValidUrl) ...[
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.language,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fetching preview...',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          url,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Enter a valid URL to see preview',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}