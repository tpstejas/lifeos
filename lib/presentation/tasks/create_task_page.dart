// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/task.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Create task page
class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key, this.taskToEdit});

  final Task? taskToEdit;

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> with LoggerMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.pending;
  String _collection = 'tasks';
  List<String> _reminders = [];
  bool _isSaving = false;

  final List<String> _collections = [
    'tasks',
    'learning',
    'references',
    'ideas',
    'opportunities',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description ?? '';
      _dueDate = widget.taskToEdit!.dueDate;
      _priority = widget.taskToEdit!.priority;
      _status = widget.taskToEdit!.status;
      _collection = widget.taskToEdit!.collectionId ?? 'tasks';
      // Convert TaskReminder objects to simple string identifiers for UI
      _reminders = widget.taskToEdit!.reminders
          .map((r) => _reminderToString(r))
          .toList();
      if (_dueDate != null) {
        _dueTime = TimeOfDay.fromDateTime(_dueDate!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null && mounted) {
      setState(() => _dueDate = date);
    }
  }

  Future<void> _selectDueTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (time != null && mounted) {
      setState(() => _dueTime = time);
    }
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showSnackBar('Please enter a title');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(taskRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final userId = authState.userId ?? 'anonymous';

      DateTime? combinedDueDate;
      if (_dueDate != null && _dueTime != null) {
        combinedDueDate = DateTime(
          _dueDate!.year,
          _dueDate!.month,
          _dueDate!.day,
          _dueTime!.hour,
          _dueTime!.minute,
        );
      }

      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      // Convert string reminders to TaskReminder objects
      final reminderObjects = _reminders.map(_stringToReminder).toList();

      if (widget.taskToEdit != null) {
        // Update existing task
        final updatedTask = widget.taskToEdit!.copyWith(
          title: title,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dueDate: combinedDueDate,
          priority: _priority,
          status: _status,
          collectionId: _collection,
          tags: tags,
          reminders: reminderObjects,
          updatedAt: DateTime.now(),
        );
        await repository.updateTask(updatedTask);
      } else {
        // Create new task
        final task = Task(
          id: '',
          userId: userId,
          title: title,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dueDate: combinedDueDate,
          priority: _priority,
          status: _status,
          collectionId: _collection,
          tags: tags,
          reminders: reminderObjects,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await repository.createTask(task);
      }

      if (mounted) {
        _showSnackBar(widget.taskToEdit != null ? 'Task updated!' : 'Task created!');
        context.pop();
      }
    } catch (e) {
      logE('Failed to save task', error: e);
      if (mounted) {
        _showSnackBar('Failed to save: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _addReminder() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ...[
                ('At time of task', 'at_time'),
                ('15 minutes before', '15min'),
                ('1 hour before', '1h'),
                ('1 day before', '1d'),
                ('Custom...', 'custom'),
              ].map((option) => ListTile(
                    title: Text(option.$1),
                    onTap: () {
                      Navigator.pop(context);
                      if (option.$2 == 'custom') {
                        _addCustomReminder();
                      } else {
                        setState(() {
                          if (!_reminders.contains(option.$2)) {
                            _reminders.add(option.$2);
                          }
                        });
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _addCustomReminder() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Reminder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., 30min, 2h, 3d',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                setState(() {
                  if (!_reminders.contains(value)) {
                    _reminders.add(value);
                  }
                }
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeReminder(String reminder) {
    setState(() => _reminders.remove(reminder));
  }

  String _formatReminder(String reminder) {
    switch (reminder) {
      case 'at_time':
        return 'At scheduled time';
      case '15min':
        return '15 minutes before';
      case '1h':
        return '1 hour before';
      case '1d':
        return '1 day before';
      default:
        return reminder;
    }
  }

  /// Convert TaskReminder to simple string identifier for UI
  String _reminderToString(TaskReminder reminder) {
    switch (reminder.trigger.type) {
      case ReminderTriggerType.atTime:
        return 'at_time';
      case ReminderTriggerType.atDueTime:
        return 'at_due';
      case ReminderTriggerType.beforeDue:
        final minutes = reminder.trigger.offsetMinutes ?? 15;
        return '${minutes}min';
      case ReminderTriggerType.hoursBefore:
        final hours = (reminder.trigger.offsetMinutes ?? 60) ~/ 60;
        return '${hours}h';
      case ReminderTriggerType.daysBefore:
        final days = (reminder.trigger.offsetMinutes ?? 1440) ~/ 1440;
        return '${days}d';
      case ReminderTriggerType.daily:
        return 'daily';
    }
  }

  /// Convert simple string identifier to TaskReminder
  TaskReminder _stringToReminder(String reminder) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    switch (reminder) {
      case 'at_time':
        return TaskReminder(
          id: id,
          trigger: const ReminderTrigger(type: ReminderTriggerType.atTime),
        );
      case 'at_due':
        return TaskReminder(
          id: id,
          trigger: const ReminderTrigger(type: ReminderTriggerType.atDueTime),
        );
      case '15min':
        return TaskReminder(
          id: id,
          trigger: const ReminderTrigger(
            type: ReminderTriggerType.beforeDue,
            offsetMinutes: 15,
          ),
        );
      case '1h':
        return TaskReminder(
          id: id,
          trigger: const ReminderTrigger(
            type: ReminderTriggerType.hoursBefore,
            offsetMinutes: 60,
          ),
        );
      case '1d':
        return TaskReminder(
          id: id,
          trigger: const ReminderTrigger(
            type: ReminderTriggerType.daysBefore,
            offsetMinutes: 1440,
          ),
        );
      case 'daily':
        return TaskReminder(
          id: id,
          trigger: const ReminderTrigger(type: ReminderTriggerType.daily),
        );
      default:
        // Custom reminder - try to parse
        int? offsetMinutes;
        ReminderTriggerType type = ReminderTriggerType.atTime;
        if (reminder.endsWith('min')) {
          offsetMinutes = int.tryParse(reminder.replaceAll('min', ''));
          type = ReminderTriggerType.beforeDue;
        } else if (reminder.endsWith('h')) {
          final hours = int.tryParse(reminder.replaceAll('h', ''));
          if (hours != null) offsetMinutes = hours * 60;
          type = ReminderTriggerType.hoursBefore;
        } else if (reminder.endsWith('d')) {
          final days = int.tryParse(reminder.replaceAll('d', ''));
          if (days != null) offsetMinutes = days * 1440;
          type = ReminderTriggerType.daysBefore;
        }
        return TaskReminder(
          id: id,
          trigger: ReminderTrigger(
            type: type,
            offsetMinutes: offsetMinutes,
          ),
        );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveTask,
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
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'What needs to be done?',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) => value?.trim().isEmpty == true ? 'Required' : null,
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add details...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 24),

            // Due date & time
            Text(
              'Due Date & Time',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDueDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_dueDate != null
                        ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                        : 'Select date'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDueTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(_dueTime != null
                        ? _dueTime!.format(context)
                        : 'Select time'),
                  ),
                ),
              ],
            ),
            if (_dueDate != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() {
                  _dueDate = null;
                  _dueTime = null;
                }),
                icon: const Icon(Icons.clear),
                label: const Text('Clear due date'),
              ),
            ],

            const SizedBox(height: 24),

            // Priority
            Text(
              'Priority',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              segments: const [
                ButtonSegment(
                  value: TaskPriority.low,
                  label: Text('Low'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: TaskPriority.medium,
                  label: Text('Medium'),
                  icon: Icon(Icons.remove),
                ),
                ButtonSegment(
                  value: TaskPriority.high,
                  label: Text('High'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TaskPriority.urgent,
                  label: Text('Urgent'),
                  icon: Icon(Icons.warning),
                ),
              ],
              selected: {_priority},
              onSelectionChanged: (selection) {
                setState(() => _priority = selection.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),

            const SizedBox(height: 24),

            // Status (only for editing)
            if (isEditing) ...[
              Text(
                'Status',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<TaskStatus>(
                segments: const [
                  ButtonSegment(
                    value: TaskStatus.pending,
                    label: Text('Pending'),
                    icon: Icon(Icons.radio_button_unchecked),
                  ),
                  ButtonSegment(
                    value: TaskStatus.inProgress,
                    label: Text('In Progress'),
                    icon: Icon(Icons.play_circle),
                  ),
                  ButtonSegment(
                    value: TaskStatus.done,
                    label: Text('Done'),
                    icon: Icon(Icons.check_circle),
                  ),
                  ButtonSegment(
                    value: TaskStatus.cancelled,
                    label: Text('Cancelled'),
                    icon: Icon(Icons.cancel),
                  ),
                ],
                selected: {_status},
                onSelectionChanged: (selection) {
                  setState(() => _status = selection.first);
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Collection
            Text(
              'Collection',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _collection,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _collections
                  .map((c) => DropdownMenuItem(value: c, child: Text(c[0].toUpperCase() + c.substring(1))))
                  .toList(),
              onChanged: (value) => setState(() => _collection = value!),
            ),

            const SizedBox(height: 24),

            // Tags
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'work, urgent, hackathon',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tag),
              ),
            ),

            const SizedBox(height: 24),

            // Reminders
            Text(
              'Reminders',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_reminders.isEmpty)
              OutlinedButton.icon(
                onPressed: _addReminder,
                icon: const Icon(Icons.add),
                label: const Text('Add Reminder'),
              )
            else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _reminders
                    .map((r) => Chip(
                          label: Text(_formatReminder(r)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removeReminder(r),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _addReminder,
                icon: const Icon(Icons.add),
                label: const Text('Add More'),
              ),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}