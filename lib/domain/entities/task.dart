// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Task entity - Actionable items with due dates, priorities, and status
class Task {
  const Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.startDate,
    this.completedAt,
    this.collectionId,
    this.tags = const [],
    this.reminders = const [],
    this.recurrenceRule,
    this.estimatedDuration,
    this.actualDuration,
    this.relatedItemIds = const [],
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
    this.version = 1,
  });

  /// Unique identifier
  final String id;

  /// Owner user ID
  final String userId;

  /// Task title
  final String title;

  /// Detailed description
  final String? description;

  /// Current status
  final TaskStatus status;

  /// Priority level
  final TaskPriority priority;

  /// Due date/time (UTC)
  final DateTime? dueDate;

  /// Start date/time (UTC)
  final DateTime? startDate;

  /// Completion timestamp (UTC)
  final DateTime? completedAt;

  /// Collection this task belongs to
  final String? collectionId;

  /// User-defined tags
  final List<String> tags;

  /// Reminder configurations
  final List<TaskReminder> reminders;

  /// RRULE for recurring tasks
  final String? recurrenceRule;

  /// Estimated duration in minutes
  final int? estimatedDuration;

  /// Actual time spent in minutes
  final int? actualDuration;

  /// Related item IDs (links to notes, references, etc.)
  final List<String> relatedItemIds;

  /// Flexible metadata
  final Map<String, dynamic> metadata;

  /// Creation timestamp (UTC)
  final DateTime createdAt;

  /// Last modification timestamp (UTC)
  final DateTime updatedAt;

  /// Optimistic locking version
  final int version;

  /// Create a copy with updated fields
  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? startDate,
    DateTime? completedAt,
    String? collectionId,
    List<String>? tags,
    List<TaskReminder>? reminders,
    String? recurrenceRule,
    int? estimatedDuration,
    int? actualDuration,
    List<String>? relatedItemIds,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      completedAt: completedAt ?? this.completedAt,
      collectionId: collectionId ?? this.collectionId,
      tags: tags ?? this.tags,
      reminders: reminders ?? this.reminders,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      relatedItemIds: relatedItemIds ?? this.relatedItemIds,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  /// Create from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: TaskStatus.values.byName(json['status'] as String),
      priority: TaskPriority.values.byName(json['priority'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      collectionId: json['collectionId'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((e) => TaskReminder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recurrenceRule: json['recurrenceRule'] as String?,
      estimatedDuration: json['estimatedDuration'] as int?,
      actualDuration: json['actualDuration'] as int?,
      relatedItemIds:
          (json['relatedItemIds'] as List<dynamic>?)?.cast<String>() ?? [],
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['version'] as int? ?? 1,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'dueDate': dueDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'collectionId': collectionId,
      'tags': tags,
      'reminders': reminders.map((e) => e.toJson()).toList(),
      'recurrenceRule': recurrenceRule,
      'estimatedDuration': estimatedDuration,
      'actualDuration': actualDuration,
      'relatedItemIds': relatedItemIds,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
    };
  }

  /// Mark task as complete
  Task complete() => copyWith(
        status: TaskStatus.done,
        completedAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
        version: version + 1,
      );

  /// Mark task as in progress
  Task start() => copyWith(
        status: TaskStatus.inProgress,
        startDate: startDate ?? DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
        version: version + 1,
      );

  /// Update status
  Task withStatus(TaskStatus newStatus) => copyWith(
        status: newStatus,
        updatedAt: DateTime.now().toUtc(),
        version: version + 1,
      );

  /// Check if overdue
  bool get isOverdue {
    if (dueDate == null) return false;
    if (status == TaskStatus.done) return false;
    return DateTime.now().toUtc().isAfter(dueDate!);
  }

  /// Check if due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now().toUtc();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return due == today;
  }

  /// Check if due this week
  bool get isDueThisWeek {
    if (dueDate == null) return false;
    final now = DateTime.now().toUtc();
    final weekEnd = now.add(Duration(days: 7 - now.weekday));
    return dueDate!.isBefore(weekEnd) &&
        dueDate!.isAfter(now.subtract(Duration(days: now.weekday)));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          description == other.description &&
          status == other.status &&
          priority == other.priority &&
          dueDate == other.dueDate &&
          startDate == other.startDate &&
          completedAt == other.completedAt &&
          collectionId == other.collectionId &&
          tags == other.tags &&
          reminders == other.reminders &&
          recurrenceRule == other.recurrenceRule &&
          estimatedDuration == other.estimatedDuration &&
          actualDuration == other.actualDuration &&
          relatedItemIds == other.relatedItemIds &&
          _mapEquals(metadata, other.metadata) &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          version == other.version;

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        title,
        description,
        status,
        priority,
        dueDate,
        startDate,
        completedAt,
        collectionId,
        tags,
        reminders,
        recurrenceRule,
        estimatedDuration,
        actualDuration,
        relatedItemIds,
        metadata,
        createdAt,
        updatedAt,
        version,
      );

  @override
  String toString() =>
      'Task(id: $id, title: $title, status: $status, priority: $priority)';
}

/// Task status
enum TaskStatus {
  /// Not started
  pending,

  /// In progress
  inProgress,

  /// Completed
  done,

  /// Overdue (auto-computed, not stored)
  overdue,

  /// Cancelled
  cancelled,
}

/// Task priority
enum TaskPriority {
  /// No priority
  none,

  /// Low priority
  low,

  /// Medium priority
  medium,

  /// High priority
  high,

  /// Urgent
  urgent,
}

/// Task reminder configuration
class TaskReminder {
  const TaskReminder({
    required this.id,
    required this.trigger,
    this.message,
    this.isEnabled = true,
  });

  /// Unique identifier
  final String id;

  /// When to trigger (relative to due date, or absolute)
  final ReminderTrigger trigger;

  /// Custom message
  final String? message;

  /// Whether reminder is active
  final bool isEnabled;

  factory TaskReminder.fromJson(Map<String, dynamic> json) {
    return TaskReminder(
      id: json['id'] as String,
      trigger:
          ReminderTrigger.fromJson(json['trigger'] as Map<String, dynamic>),
      message: json['message'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trigger': trigger.toJson(),
      'message': message,
      'isEnabled': isEnabled,
    };
  }
}

/// Reminder trigger specification
class ReminderTrigger {
  const ReminderTrigger({
    required this.type,
    this.offsetMinutes,
    this.absoluteTime,
  });

  /// Trigger type
  final ReminderTriggerType type;

  /// Minutes before due date (for relative triggers)
  final int? offsetMinutes;

  /// Absolute timestamp (for absolute triggers)
  final DateTime? absoluteTime;

  factory ReminderTrigger.fromJson(Map<String, dynamic> json) {
    return ReminderTrigger(
      type: ReminderTriggerType.values.byName(json['type'] as String),
      offsetMinutes: json['offsetMinutes'] as int?,
      absoluteTime: json['absoluteTime'] != null
          ? DateTime.parse(json['absoluteTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'offsetMinutes': offsetMinutes,
      'absoluteTime': absoluteTime?.toIso8601String(),
    };
  }
}

/// Reminder trigger types
enum ReminderTriggerType {
  /// At due time
  atDueTime,

  /// Minutes before due
  beforeDue,

  /// Hours before due
  hoursBefore,

  /// Days before due
  daysBefore,

  /// At specific time
  atTime,

  /// Daily at specific time
  daily,
}

extension TaskPriorityX on TaskPriority {
  int get sortOrder {
    switch (this) {
      case TaskPriority.urgent:
        return 4;
      case TaskPriority.high:
        return 3;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 1;
      case TaskPriority.none:
        return 0;
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.urgent:
        return Colors.red;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.none:
        return Colors.grey;
    }
  }
}

extension TaskStatusX on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.overdue:
        return 'Overdue';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
