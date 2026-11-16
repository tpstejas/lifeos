// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/item.dart';

/// Inbox page - Main capture screen
class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<InboxPage> with LoggerMixin {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final inboxItemsAsync = ref.watch(inboxItemsStreamProvider(authState.userId ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => logD('Search tapped'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => logD('Filter tapped'),
          ),
        ],
      ),
      body: inboxItemsAsync.when(
        data: (items) => _buildBody(items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading inbox: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(inboxItemsStreamProvider(authState.userId ?? '')),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCaptureOptions,
        icon: const Icon(Icons.add),
        label: const Text('Capture'),
      ),
    );
  }

  Widget _buildBody(List<Item> items) {
    return CustomScrollView(
      slivers: [
        // Quick capture section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _QuickCaptureCard(
              onVoiceTap: () => _navigateToCapture('voice'),
              onTextTap: () => _navigateToCapture('text'),
              onLinkTap: () => _navigateToCapture('link'),
              onFileTap: () => _navigateToCapture('file'),
            ),
          ),
        ),

        // Inbox items
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: items.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Inbox is empty',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Capture something to get started',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _InboxItemCard(
                      title: item.title,
                      subtitle: '${_formatTimeAgo(item.createdAt)} • ${item.type.displayName}',
                      source: item.type.displayName,
                      onTap: () => _navigateToItem(item),
                    );
                  },
                ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now().toUtc();
    final diff = now.difference(dateTime.toUtc());

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showCaptureOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _CaptureOptionsSheet(
        onVoice: () => _navigateToCapture('voice'),
        onText: () => _navigateToCapture('text'),
        onLink: () => _navigateToCapture('link'),
        onFile: () => _navigateToCapture('file'),
      ),
    );
  }

  void _navigateToCapture(String type) {
    Navigator.pop(context);
    context.go('/inbox/capture/$type');
  }

  void _navigateToItem(Item item) {
    context.go('/library/item/${item.id}');
  }
}

/// Quick capture card widget
class _QuickCaptureCard extends StatelessWidget {
  const _QuickCaptureCard({
    required this.onVoiceTap,
    required this.onTextTap,
    required this.onLinkTap,
    required this.onFileTap,
  });

  final VoidCallback onVoiceTap;
  final VoidCallback onTextTap;
  final VoidCallback onLinkTap;
  final VoidCallback onFileTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Capture',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _CaptureAction(
                  icon: Icons.mic,
                  label: 'Voice',
                  color: Colors.red,
                  onTap: onVoiceTap,
                ),
                _CaptureAction(
                  icon: Icons.edit,
                  label: 'Text',
                  color: Colors.blue,
                  onTap: onTextTap,
                ),
                _CaptureAction(
                  icon: Icons.link,
                  label: 'Link',
                  color: Colors.green,
                  onTap: onLinkTap,
                ),
                _CaptureAction(
                  icon: Icons.attach_file,
                  label: 'File',
                  color: Colors.orange,
                  onTap: onFileTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureAction extends StatelessWidget {
  const _CaptureAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inbox item card
class _InboxItemCard extends StatelessWidget {
  const _InboxItemCard({
    required this.title,
    required this.subtitle,
    required this.source,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String source;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color sourceColor;
    IconData sourceIcon;

    switch (source) {
      case 'Voice':
        sourceColor = Colors.red;
        sourceIcon = Icons.mic;
        break;
      case 'Link':
        sourceColor = Colors.green;
        sourceIcon = Icons.link;
        break;
      default:
        sourceColor = Colors.blue;
        sourceIcon = Icons.edit;
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: sourceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(sourceIcon, color: sourceColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  source,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Capture options bottom sheet
class _CaptureOptionsSheet extends StatelessWidget {
  const _CaptureOptionsSheet({
    required this.onVoice,
    required this.onText,
    required this.onLink,
    required this.onFile,
  });

  final VoidCallback onVoice;
  final VoidCallback onText;
  final VoidCallback onLink;
  final VoidCallback onFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Capture Something',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _CaptureActionSheet(
                  icon: Icons.mic,
                  label: 'Voice Note',
                  color: Colors.red,
                  onTap: onVoice,
                ),
                _CaptureActionSheet(
                  icon: Icons.edit,
                  label: 'Text Note',
                  color: Colors.blue,
                  onTap: onText,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _CaptureActionSheet(
                  icon: Icons.link,
                  label: 'Save Link',
                  color: Colors.green,
                  onTap: onLink,
                ),
                _CaptureActionSheet(
                  icon: Icons.attach_file,
                  label: 'File/Photo',
                  color: Colors.orange,
                  onTap: onFile,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CaptureActionSheet extends StatelessWidget {
  const _CaptureActionSheet({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
