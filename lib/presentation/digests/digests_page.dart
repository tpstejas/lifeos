// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/utils/logger.dart';

/// Digests page - Daily/weekly/monthly AI digests
class DigestsPage extends ConsumerStatefulWidget {
  const DigestsPage({super.key});

  @override
  ConsumerState<DigestsPage> createState() => _DigestsPageState();
}

class _DigestsPageState extends ConsumerState<DigestsPage> with LoggerMixin {
  final List<_Digest> _digests = [
    _Digest(
      period: DigestPeriod.daily,
      date: DateTime.now(),
      title: 'Daily Brief - Today',
      summary: '3 tasks due, 2 hackathons ending, 1 article to read',
      sections: [
        _DigestSection(
          title: 'Tasks',
          itemCount: 3,
          insight: '2 high-priority tasks due today',
        ),
        _DigestSection(
          title: 'Opportunities',
          itemCount: 2,
          insight: 'Firebase Hackathon ends in 2 days',
        ),
        _DigestSection(
          title: 'Learning',
          itemCount: 1,
          insight: 'Saved article about hybrid AI patterns',
        ),
      ],
    ),
    _Digest(
      period: DigestPeriod.weekly,
      date: DateTime.now().subtract(const Duration(days: 7)),
      title: 'Weekly Review',
      summary:
          'You saved 47 items. Completed 12 tasks. Top topics: AI, Internships',
      sections: [
        _DigestSection(
          title: 'Tasks Completed',
          itemCount: 12,
          insight: 'Great progress on hackathon applications',
        ),
        _DigestSection(
          title: 'Learning',
          itemCount: 15,
          insight: 'Focus on AI agents and Flutter this week',
        ),
        _DigestSection(
          title: 'Opportunities',
          itemCount: 8,
          insight: '3 new hackathons, 2 internship postings',
        ),
        _DigestSection(
          title: 'Patterns',
          itemCount: 0,
          insight: 'You collect learning items but rarely review them',
        ),
      ],
    ),
    _Digest(
      period: DigestPeriod.monthly,
      date: DateTime.now().subtract(const Duration(days: 30)),
      title: 'Monthly Synthesis',
      summary: 'Patterns: You collect but don\'t act on learning items',
      sections: [
        _DigestSection(
          title: 'Productivity',
          itemCount: 45,
          insight: 'Task completion rate: 73%',
        ),
        _DigestSection(
          title: 'Learning',
          itemCount: 62,
          insight: 'Only 12% of saved articles were read',
        ),
        _DigestSection(
          title: 'Opportunities',
          itemCount: 18,
          insight: 'Applied to 4, got 1 interview',
        ),
        _DigestSection(
          title: 'Recommendation',
          itemCount: 0,
          insight: 'Schedule weekly review time for learning items',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Digests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => logD('Refresh digests'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => logD('Digest settings'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _digests.length,
        itemBuilder: (context, index) => _DigestCard(
          digest: _digests[index],
          onTap: () => context.go(
              '/digests/${_digests[index].period.name}/${_formatDate(_digests[index].date)}'),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

enum DigestPeriod { daily, weekly, monthly }

class _Digest {
  const _Digest({
    required this.period,
    required this.date,
    required this.title,
    required this.summary,
    required this.sections,
  });

  final DigestPeriod period;
  final DateTime date;
  final String title;
  final String summary;
  final List<_DigestSection> sections;
}

class _DigestSection {
  const _DigestSection({
    required this.title,
    required this.itemCount,
    required this.insight,
  });

  final String title;
  final int itemCount;
  final String insight;
}

/// Digest card widget
class _DigestCard extends StatelessWidget {
  const _DigestCard({
    required this.digest,
    required this.onTap,
  });

  final _Digest digest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periodColor = _getPeriodColor(digest.period);

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
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: periodColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatPeriod(digest.period),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: periodColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(digest.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                digest.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                digest.summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: digest.sections
                    .map((section) => _DigestSectionChip(
                          title: section.title,
                          count: section.itemCount,
                          color: periodColor,
                        ))
                    .toList(),
              ),
            ],
          ),
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

/// Digest section chip
class _DigestSectionChip extends StatelessWidget {
  const _DigestSectionChip({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
