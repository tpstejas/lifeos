// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/utils/logger.dart';

/// Tasks page - Task management with calendar view
class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> with LoggerMixin {
  _TaskFilter _filter = _TaskFilter.all;
  final List<_Task> _tasks = [
    _Task(
      id: '1',
      title: 'Apply for Firebase Hackathon',
      description: 'Submit project by Nov 30',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      collection: 'opportunities',
    ),
    _Task(
      id: '2',
      title: 'Review saved articles on AI agents',
      description: '3 articles in learning collection',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.medium,
      status: TaskStatus.inProgress,
      collection: 'learning',
    ),
    _Task(
      id: '3',
      title: 'Set up Flutter development environment',
      description: 'Install Flutter, configure Firebase',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
      status: TaskStatus.overdue,
      collection: 'tasks',
    ),
    _Task(
      id: '4',
      title: 'Prepare demo video for submission',
      description: 'Record 3-minute demo',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      collection: 'tasks',
    ),
    _Task(
      id: '5',
      title: 'Research Google internship opportunities',
      description: 'Find 2025 summer internships',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      priority: TaskPriority.low,
      status: TaskStatus.pending,
      collection: 'opportunities',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton<_TaskFilter>(
            initialValue: _filter,
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: _TaskFilter.all, child: Text('All')),
              const PopupMenuItem(
                  value: _TaskFilter.today, child: Text('Today')),
              const PopupMenuItem(
                  value: _TaskFilter.thisWeek, child: Text('This Week')),
              const PopupMenuItem(
                  value: _TaskFilter.overdue, child: Text('Overdue')),
              const PopupMenuItem(
                  value: _TaskFilter.completed, child: Text('Completed')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => logD('Calendar view tapped'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          _StatsBar(tasks: _tasks),

          // Tasks list
          Expanded(
            child: filteredTasks.isEmpty
                ? _EmptyState(filter: _filter)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _TaskCard(
                      task: filteredTasks[index],
                      onTap: () =>
                          context.go('/tasks/${filteredTasks[index].id}'),
                      onToggle: () => _toggleTask(filteredTasks[index]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/tasks/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  List<_Task> _getFilteredTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekEnd = today.add(const Duration(days: 7));

    return _tasks.where((task) {
      switch (_filter) {
        case _TaskFilter.all:
          return true;
        case _TaskFilter.today:
          return task.dueDate != null &&
              task.dueDate!.year == today.year &&
              task.dueDate!.month == today.month &&
              task.dueDate!.day == today.day;
        case _TaskFilter.thisWeek:
          return task.dueDate != null &&
              task.dueDate!.isAfter(today.subtract(const Duration(days: 1))) &&
              task.dueDate!.isBefore(weekEnd);
        case _TaskFilter.overdue:
          return task.dueDate != null &&
              task.dueDate!.isBefore(today) &&
              task.status != TaskStatus.done;
        case _TaskFilter.completed:
          return task.status == TaskStatus.done;
      }
    }).toList();
  }

  void _toggleTask(_Task task) {
    logD('Toggle task: ${task.id}');
  }
}

enum _TaskFilter { all, today, thisWeek, overdue, completed }

enum TaskPriority { none, low, medium, high, urgent }

enum TaskStatus { pending, inProgress, done, overdue }

class _Task {
  const _Task({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.priority,
    required this.status,
    required this.collection,
  });

  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String collection;
}

/// Stats bar widget
class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.tasks});

  final List<_Task> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final overdue = tasks
        .where((t) =>
            t.dueDate != null &&
            t.dueDate!.isBefore(todayDate) &&
            t.status != TaskStatus.done)
        .length;
    final dueToday = tasks
        .where((t) =>
            t.dueDate != null &&
            t.dueDate!.year == todayDate.year &&
            t.dueDate!.month == todayDate.month &&
            t.dueDate!.day == todayDate.day &&
            t.status != TaskStatus.done)
        .length;
    final completed = tasks.where((t) => t.status == TaskStatus.done).length;
    final pending = tasks.where((t) => t.status != TaskStatus.done).length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: _StatItem(
                  label: 'Overdue', value: overdue, color: Colors.red)),
          Expanded(
              child: _StatItem(
                  label: 'Today', value: dueToday, color: Colors.orange)),
          Expanded(
              child: _StatItem(
                  label: 'Pending', value: pending, color: Colors.blue)),
          Expanded(
              child: _StatItem(
                  label: 'Done', value: completed, color: Colors.green)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Task card widget
class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  final _Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        task.status != TaskStatus.done;

    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.urgent:
      case TaskPriority.high:
        priorityColor = Colors.red;
        break;
      case TaskPriority.medium:
        priorityColor = Colors.orange;
        break;
      case TaskPriority.low:
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

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
                  // Checkbox
                  Checkbox(
                    value: task.status == TaskStatus.done,
                    onChanged: (_) => onToggle(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 8),
                  // Priority indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: priorityColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: task.status == TaskStatus.done
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.done
                            ? theme.colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                  ),
                  // Overdue badge
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'OVERDUE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Description
              if (task.description.isNotEmpty)
                Text(
                  task.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 8),
              // Meta row
              Row(
                children: [
                  if (task.dueDate != null) ...[
                    Icon(
                      Icons.event,
                      size: 14,
                      color: isOverdue
                          ? Colors.red
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(task.dueDate!),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isOverdue
                            ? Colors.red
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isOverdue ? FontWeight.w600 : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.collection,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    final diff = taskDate.difference(today).inDays;

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
    return '${date.day}/${date.month}';
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});

  final _TaskFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String message;
    IconData icon;

    switch (filter) {
      case _TaskFilter.today:
        message = 'No tasks due today 🎉';
        icon = Icons.event_available;
        break;
      case _TaskFilter.thisWeek:
        message = 'Nothing scheduled this week';
        icon = Icons.calendar_month;
        break;
      case _TaskFilter.overdue:
        message = 'No overdue tasks!';
        icon = Icons.check_circle;
        break;
      case _TaskFilter.completed:
        message = 'No completed tasks yet';
        icon = Icons.task_alt;
        break;
      default:
        message = 'No tasks yet. Create your first task!';
        icon = Icons.add_task;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
