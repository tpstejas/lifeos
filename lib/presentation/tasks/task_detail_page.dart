// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/task.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';
import 'package:lifeos/presentation/tasks/create_task_page.dart';

/// Task detail page - View and manage a specific task
class TaskDetailPage extends ConsumerStatefulWidget {
  const TaskDetailPage({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> with LoggerMixin {
  Task? _task;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(taskRepositoryProvider);
      final task = await repository.getTask(widget.taskId);
      if (mounted) {
        setState(() {
          _task = task;
          _isLoading = false;
        });
      }
    } catch (e) {
      logE('Failed to load task', error: e);
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Failed to load task');
      }
    }
  }

  Future<void> _deleteTask() async {
    if (_task == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && _task != null) {
      try {
        final repository = ref.read(taskRepositoryProvider);
        await repository.deleteTask(_task!.id);
        if (mounted) {
          context.pop();
          _showSnackBar('Task deleted');
        }
      } catch (e) {
        logE('Failed to delete task', error: e);
        if (mounted) {
          _showSnackBar('Failed to delete: $e');
        }
      }
    }
  }

  Future<void> _toggleComplete() async {
    if (_task == null) return;

    try {
      final repository = ref.read(taskRepositoryProvider);
      final newStatus = _task!.status == TaskStatus.done
          ? TaskStatus.pending
          : TaskStatus.done;
      final updatedTask = _task!.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      await repository.updateTask(updatedTask);
      if (mounted) {
        setState(() => _task = updatedTask);
        _showSnackBar(newStatus == TaskStatus.done ? 'Task completed!' : 'Task marked as pending');
      }
    } catch (e) {
      logE('Failed to update task', error: e);
      if (mounted) {
        _showSnackBar('Failed to update: $e');
      }
    }
  }

  void _editTask() {
    context.push('/tasks/create', extra: _task);
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
        appBar: AppBar(title: const Text('Task Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Detail')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Task not found'),
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

    final isOverdue = _task!.dueDate != null &&
        _task!.dueDate!.isBefore(DateTime.now()) &&
        _task!.status != TaskStatus.done;
    final priorityColor = _getPriorityColor(_task!.priority);

    return Scaffold(
      appBar: AppBar(
        title: Text(_task!.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editTask();
                  break;
                case 'delete':
                  _deleteTask();
                  break;
                case 'duplicate':
                  _duplicateTask();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'), contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'duplicate', child: ListTile(leading: Icon(Icons.content_copy), title: Text('Duplicate'), contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete', style: TextStyle(color: Colors.red)), contentPadding: EdgeInsets.zero)),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and priority header
            Row(
              children: [
                // Status button
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _toggleComplete,
                    icon: Icon(
                      _task!.status == TaskStatus.done
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                    ),
                    label: Text(
                      _task!.status == TaskStatus.done ? 'Completed' : 'Mark Complete',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _task!.status == TaskStatus.done
                          ? Colors.green.withValues(alpha: 0.1)
                          : theme.colorScheme.primaryContainer,
                      foregroundColor: _task!.status == TaskStatus.done
                          ? Colors.green
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPriorityIcon(_task!.priority),
                        color: priorityColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _task!.priority.name.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: priorityColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Overdue badge
            if (isOverdue)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'This task is overdue!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Description
            if (_task!.description != null && _task!.description!.isNotEmpty) ...[
              Text(
                'Description',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _task!.description!,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
            ],

            // Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_task!.dueDate != null) ...[
                      _DetailRow(
                        icon: Icons.event,
                        label: 'Due',
                        value: _formatDueDate(_task!.dueDate!),
                        valueColor: isOverdue ? Colors.red : null,
                      ),
                      const SizedBox(height: 12),
                    ],

                    _DetailRow(
                      icon: Icons.folder,
                      label: 'Collection',
                      value: _task!.collectionId ?? 'Uncategorized',
                    ),
                    const SizedBox(height: 12),

                    _DetailRow(
                      icon: Icons.flag,
                      label: 'Status',
                      value: _formatStatus(_task!.status),
                      valueColor: _getStatusColor(_task!.status),
                    ),
                    const SizedBox(height: 12),

                    _DetailRow(
                      icon: Icons.priority_high,
                      label: 'Priority',
                      value: _task!.priority.name.toUpperCase(),
                      valueColor: priorityColor,
                    ),
                    const SizedBox(height: 12),

                    if (_task!.tags.isNotEmpty) ...[
                      _DetailRow(
                        icon: Icons.tag,
                        label: 'Tags',
                        value: '',
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _task!.tags
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (_task!.reminders.isNotEmpty) ...[
                      _DetailRow(
                        icon: Icons.notifications,
                        label: 'Reminders',
                        value: '',
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _task!.reminders
                            .map((r) => Chip(
                                  label: Text(_formatReminder(r)),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: theme.colorScheme.primaryContainer,
                                  labelStyle: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                    ],

                    _DetailRow(
                      icon: Icons.calendar_today,
                      label: 'Created',
                      value: _formatDateTime(_task!.createdAt),
                    ),
                    const SizedBox(height: 12),

                    _DetailRow(
                      icon: Icons.update,
                      label: 'Updated',
                      value: _formatDateTime(_task!.updatedAt),
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

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return Icons.warning;
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.arrow_downward;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.cancelled:
        return Colors.grey;
      case TaskStatus.overdue:
        return Colors.red;
    }
  }

  String _formatStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.overdue:
        return 'Overdue';
    }
  }

  String _formatReminder(TaskReminder reminder) {
    switch (reminder.trigger.type) {
      case ReminderTriggerType.atTime:
        return 'At scheduled time';
      case ReminderTriggerType.atDueTime:
        return 'At due time';
      case ReminderTriggerType.beforeDue:
        final minutes = reminder.trigger.offsetMinutes ?? 15;
        return '$minutes min before';
      case ReminderTriggerType.hoursBefore:
        final hours = (reminder.trigger.offsetMinutes ?? 60) ~/ 60;
        return '$hours hour${hours > 1 ? 's' : ''} before';
      case ReminderTriggerType.daysBefore:
        final days = (reminder.trigger.offsetMinutes ?? 1440) ~/ 1440;
        return '$days day${days > 1 ? 's' : ''} before';
      case ReminderTriggerType.daily:
        return 'Daily at scheduled time';
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    final diff = taskDate.difference(today).inDays;

    String dateStr;
    if (diff == 0) {
      dateStr = 'Today';
    } else if (diff == 1) {
      dateStr = 'Tomorrow';
    } else if (diff == -1) {
      dateStr = 'Yesterday';
    } else if (diff > 0 && diff <= 7) {
      dateStr = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ][date.weekday - 1];
    } else {
      dateStr = '${date.day}/${date.month}/${date.year}';
    }

    if (date.hour != 0 || date.minute != 0) {
      dateStr += ' at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return dateStr;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _duplicateTask() {
    if (_task == null) return;
    context.push('/tasks/create', extra: _task!.copyWith(
      id: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: TaskStatus.pending,
    ));
  }
}

/// Detail row widget
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}