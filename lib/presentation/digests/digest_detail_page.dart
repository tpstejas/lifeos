// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/domain/entities/enums.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/digest.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Digest detail page - View a specific AI digest
class DigestDetailPage extends ConsumerStatefulWidget {
  const DigestDetailPage({super.key, required this.period, required this.date});

  final String period;
  final String date;

  @override
  ConsumerState<DigestDetailPage> createState() => _DigestDetailPageState();
}

class _DigestDetailPageState extends ConsumerState<DigestDetailPage> with LoggerMixin {
  Digest? _digest;
  bool _isLoading = true;
  bool _isRegenerating = false;

  @override
  void initState() {
    super.initState();
    _loadDigest();
  }

  Future<void> _loadDigest() async {
    setState(() => _isLoading = true);
    try {
      final digestRepository = ref.read(digestRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final userId = authState.userId ?? 'anonymous';

      // Parse date
      final dateParts = widget.date.split('-');
      final date = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );

      // Parse period string to DigestPeriod enum
      final period = DigestPeriod.values.byName(widget.period);

      final digest = await digestRepository.getByDate(userId, period, date);

      if (mounted) {
        setState(() {
          _digest = digest;
          _isLoading = false;
        });
      }
    } catch (e) {
      logE('Failed to load digest', error: e);
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Failed to load digest');
      }
    }
  }

  Future<void> _regenerateDigest() async {
    if (_isRegenerating) return;

    setState(() => _isRegenerating = true);

    try {
      final digestRepository = ref.read(digestRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final userId = authState.userId ?? 'anonymous';

      final dateParts = widget.date.split('-');
      final date = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );

      final period = DigestPeriod.values.byName(widget.period);

      await digestRepository.generateDigest(
        userId: userId,
        period: period,
        date: date,
        source: InferenceSource.hybrid,
      );

      if (mounted) {
        _loadDigest();
        _showSnackBar('Digest regenerated!');
      }
    } catch (e) {
      logE('Failed to regenerate digest', error: e);
      if (mounted) {
        _showSnackBar('Failed to regenerate: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isRegenerating = false);
      }
    }
  }

  Future<void> _shareDigest() async {
    if (_digest == null) return;
    _showSnackBar('Share feature coming soon');
  }

  Future<void> _exportDigest() async {
    if (_digest == null) return;
    _showSnackBar('Export feature coming soon');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periodEnum = DigestPeriod.values.firstWhere(
      (p) => p.name == widget.period,
      orElse: () => DigestPeriod.daily,
    );
    final periodColor = _getPeriodColor(periodEnum);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('${_formatPeriod(periodEnum)} Digest')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_digest == null) {
      return Scaffold(
        appBar: AppBar(title: Text('${_formatPeriod(periodEnum)} Digest')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Digest not found'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _regenerateDigest,
                icon: const Icon(Icons.refresh),
                label: const Text('Generate Digest'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_digest!.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareDigest,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportDigest,
            tooltip: 'Export',
          ),
          IconButton(
            icon: _isRegenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRegenerating ? null : _regenerateDigest,
            tooltip: 'Regenerate',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with period and date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: periodColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _formatPeriod(periodEnum),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: periodColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatDate(_digest!.date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'v${_digest!.version}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _digest!.summary,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sections
            if (_digest!.sections.isNotEmpty) ...[
              Text(
                'Sections',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ..._digest!.sections.map((section) => _DigestSectionCard(
                    section: section,
                    color: periodColor,
                  )),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No sections in this digest',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Insights
            if (_digest!.keyInsights.isNotEmpty) ...[
              Text(
                'Key Insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _digest!.keyInsights
                        .map((insight) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    size: 20,
                                    color: periodColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      insight,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action items
            if (_digest!.actionItems.isNotEmpty) ...[
              Text(
                'Action Items',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _digest!.actionItems
                        .map((action) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      action,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPeriodColor(DigestPeriod period) {
    switch (period) {
      case DigestPeriod.daily:
        return Colors.blue;
      case DigestPeriod.weekly:
        return Colors.green;
      case DigestPeriod.monthly:
        return Colors.purple;
    }
  }

  String _formatPeriod(DigestPeriod period) {
    return period.name[0].toUpperCase() + period.name.substring(1);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Digest section card
class _DigestSectionCard extends StatelessWidget {
  const _DigestSectionCard({
    required this.section,
    required this.color,
  });

  final DigestSection section;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getSectionIcon(section.title),
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (section.itemCount > 0)
                        Text(
                          '${section.itemCount} items',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${section.itemCount}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (section.insight != null && section.insight!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.insights, size: 16, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        section.insight!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (section.items.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...section.items.take(3).map((itemId) => _DigestItemPreview(
                    title: itemId, // itemId is the item ID, would need to fetch actual item
                    snippet: '',
                    onTap: () => AppLogger.d('Digest item tapped: $itemId', tag: 'DigestDetailPage'),
                  )),
              if (section.items.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '+${section.items.length - 3} more items',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon(String title) {
    switch (title.toLowerCase()) {
      case 'tasks':
        return Icons.task;
      case 'learning':
        return Icons.school;
      case 'references':
        return Icons.book;
      case 'ideas':
        return Icons.lightbulb;
      case 'opportunities':
        return Icons.trending_up;
      case 'productivity':
        return Icons.analytics;
      case 'patterns':
        return Icons.psychology;
      case 'recommendation':
        return Icons.recommend;
      default:
        return Icons.folder;
    }
  }
}

/// Digest item preview
class _DigestItemPreview extends StatelessWidget {
  const _DigestItemPreview({
    required this.title,
    required this.snippet,
    required this.onTap,
  });

  final String title;
  final String snippet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (snippet.isNotEmpty)
                    Text(
                      snippet,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}