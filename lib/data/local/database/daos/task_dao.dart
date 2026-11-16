// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:drift/drift.dart';
import 'package:lifeos/data/local/database/app_database.dart';
import 'package:lifeos/domain/entities/task.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks, TaskReminders])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  /// Insert or update a task
  Future<void> upsertTask(TasksCompanion task) =>
      into(tasks).insertOnConflictUpdate(task);

  /// Get task by ID
  Future<TaskData?> getTaskById(String id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get all tasks with optional filters
  Future<List<TaskData>> getAllTasks({
    String? userId,
    String? collectionId,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
    bool? overdueOnly,
    int? limit,
    int? offset,
  }) {
    var query = select(tasks);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (collectionId != null) {
      query = query..where((t) => t.collectionId.equals(collectionId));
    }
    if (status != null) {
      query = query..where((t) => t.status.equals(status.name));
    }
    if (priority != null) {
      query = query..where((t) => t.priority.equals(priority.name));
    }
    if (fromDate != null) {
      query = query..where((t) => t.dueDate.isBiggerOrEqualValue(fromDate));
    }
    if (toDate != null) {
      query = query..where((t) => t.dueDate.isSmallerOrEqualValue(toDate));
    }
    if (overdueOnly == true) {
      final now = DateTime.now().toUtc();
      query = query
        ..where((t) =>
            t.dueDate.isSmallerThanValue(now) &
            t.status.equals(TaskStatus.done.name).not());
    }

    query = query
      ..orderBy([
        (t) => OrderingTerm.asc(t.dueDate),
        (t) => OrderingTerm.desc(t.priority),
      ]);

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    return query.get();
  }

  /// Stream all tasks
  Stream<List<TaskData>> watchAllTasks({
    String? userId,
    String? collectionId,
    TaskStatus? status,
  }) {
    var query = select(tasks);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (collectionId != null) {
      query = query..where((t) => t.collectionId.equals(collectionId));
    }
    if (status != null) {
      query = query..where((t) => t.status.equals(status.name));
    }

    query = query
      ..orderBy([
        (t) => OrderingTerm.asc(t.dueDate),
        (t) => OrderingTerm.desc(t.priority),
      ]);

    return query.watch();
  }

  /// Delete task by ID
  Future<int> deleteTask(String id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  /// Bulk insert tasks
  Future<void> insertAllTasks(List<TasksCompanion> tasksList) => batch((batch) {
        batch.insertAllOnConflictUpdate(tasks, tasksList);
      });

  /// Get overdue tasks
  Future<List<TaskData>> getOverdueTasks({String? userId, int? limit}) {
    final now = DateTime.now().toUtc();
    var query = select(tasks)
      ..where((t) =>
          t.dueDate.isSmallerThanValue(now) &
          t.status.equals(TaskStatus.done.name).not())
      ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (limit != null) {
      query = query..limit(limit);
    }

    return query.get();
  }

  /// Get tasks due today
  Future<List<TaskData>> getTasksDueToday({String? userId}) {
    final now = DateTime.now().toUtc();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    var query = select(tasks)
      ..where((t) =>
          t.dueDate.isBiggerOrEqualValue(today) &
          t.dueDate.isSmallerThanValue(tomorrow) &
          t.status.equals(TaskStatus.done.name).not())
      ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  /// Get tasks due this week
  Future<List<TaskData>> getTasksDueThisWeek({String? userId}) {
    final now = DateTime.now().toUtc();
    final weekEnd = now.add(Duration(days: 7 - now.weekday));

    var query = select(tasks)
      ..where((t) =>
          t.dueDate.isBiggerOrEqualValue(now) &
          t.dueDate.isSmallerOrEqualValue(weekEnd) &
          t.status.equals(TaskStatus.done.name).not())
      ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  /// Get tasks by status
  Future<List<TaskData>> getTasksByStatus(TaskStatus status,
      {String? userId, int? limit}) {
    var query = select(tasks)
      ..where((t) => t.status.equals(status.name))
      ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (limit != null) {
      query = query..limit(limit);
    }

    return query.get();
  }

  /// Get upcoming tasks
  Future<List<TaskData>> getUpcomingTasks({String? userId, int? limit = 10}) {
    final now = DateTime.now().toUtc();
    var query = select(tasks)
      ..where((t) =>
          t.dueDate.isBiggerOrEqualValue(now) &
          t.status.equals(TaskStatus.done.name).not())
      ..orderBy([(t) => OrderingTerm.asc(t.dueDate)])
      ..limit(limit ?? 10);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  /// Complete task
  Future<void> completeTask(String id) =>
      (update(tasks)..where((t) => t.id.equals(id))).write(TasksCompanion(
        status: Value(TaskStatus.done),
        completedAt: Value(DateTime.now().toUtc()),
        updatedAt: Value(DateTime.now().toUtc()),
      ));

  /// Update task status
  Future<void> updateTaskStatus(String id, TaskStatus status) =>
      (update(tasks)..where((t) => t.id.equals(id))).write(TasksCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().toUtc()),
      ));

  /// Get tasks needing reminders
  Future<List<TaskData>> getTasksNeedingReminders(DateTime now) =>
      (select(tasks)
            ..where((t) =>
                t.dueDate.isNotNull() &
                t.dueDate.isBiggerOrEqualValue(now) &
                t.status.equals(TaskStatus.done.name).not() &
                t.status.equals(TaskStatus.cancelled.name).not()))
          .get();

  /// Get tasks modified after timestamp (for sync)
  Future<List<TaskData>> getTasksModifiedAfter(DateTime timestamp,
          {int? limit}) =>
      (select(tasks)
            ..where((t) => t.updatedAt.isBiggerOrEqualValue(timestamp))
            ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)])
            ..limit(limit ?? 1000))
          .get();

  /// Get task statistics
  Future<TaskStatisticsData> getTaskStatistics(String userId) async {
    final now = DateTime.now().toUtc();
    final today = DateTime(now.year, now.month, now.day);
    final weekEnd = today.add(const Duration(days: 7));

    // Total tasks
    final totalQuery = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.userId.equals(userId));
    final total = (await totalQuery.getSingle()).read(tasks.id.count()) ?? 0;

    // By status
    final pendingQuery = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.userId.equals(userId) &
          tasks.status.equals(TaskStatus.pending.name));
    final pending =
        (await pendingQuery.getSingle()).read(tasks.id.count()) ?? 0;

    final inProgressQuery = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.userId.equals(userId) &
          tasks.status.equals(TaskStatus.inProgress.name));
    final inProgress =
        (await inProgressQuery.getSingle()).read(tasks.id.count()) ?? 0;

    final completedQuery = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.userId.equals(userId) &
          tasks.status.equals(TaskStatus.done.name));
    final completed =
        (await completedQuery.getSingle()).read(tasks.id.count()) ?? 0;

    // Overdue
    final overdueQuery = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.userId.equals(userId) &
          tasks.dueDate.isSmallerThanValue(today) &
          tasks.status.equals(TaskStatus.done.name).not());
    final overdue =
        (await overdueQuery.getSingle()).read(tasks.id.count()) ?? 0;

    // Due today
    final dueTodayQuery = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.userId.equals(userId) &
          tasks.dueDate.isBiggerOrEqualValue(today) &
          tasks.dueDate.isSmallerThanValue(today.add(const Duration(days: 1))) &
          tasks.status.equals(TaskStatus.done.name).not());
    final dueToday =
        (await dueTodayQuery.getSingle()).read(tasks.id.count()) ?? 0;

    // Due this week
    final dueThisWeekQuery = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.userId.equals(userId) &
          tasks.dueDate.isBiggerOrEqualValue(today) &
          tasks.dueDate.isSmallerOrEqualValue(weekEnd) &
          tasks.status.equals(TaskStatus.done.name).not());
    final dueThisWeek =
        (await dueThisWeekQuery.getSingle()).read(tasks.id.count()) ?? 0;

    // By priority
    final byPriority = <TaskPriority, int>{};
    for (final priority in TaskPriority.values) {
      final query = selectOnly(tasks)
        ..addColumns([tasks.id.count()])
        ..where(
            tasks.userId.equals(userId) & tasks.priority.equals(priority.name));
      byPriority[priority] =
          (await query.getSingle()).read(tasks.id.count()) ?? 0;
    }

    // By collection
    final byCollectionQuery = selectOnly(tasks)
      ..addColumns([tasks.collectionId, tasks.id.count()])
      ..where(tasks.userId.equals(userId) & tasks.collectionId.isNotNull())
      ..groupBy([tasks.collectionId]);
    final byCollectionRows = await byCollectionQuery.get();
    final byCollection = <String, int>{};
    for (final row in byCollectionRows) {
      final collectionId = row.read(tasks.collectionId);
      if (collectionId != null) {
        byCollection[collectionId] = row.read(tasks.id.count()) ?? 0;
      }
    }

    return TaskStatisticsData(
      total: total,
      pending: pending,
      inProgress: inProgress,
      completed: completed,
      overdue: overdue,
      dueToday: dueToday,
      dueThisWeek: dueThisWeek,
      byPriority: byPriority,
      byCollection: byCollection,
    );
  }

  /// Convert domain Task to database companion
  TasksCompanion toCompanion(Task task) => TasksCompanion(
        id: Value(task.id),
        userId: Value(task.userId),
        title: Value(task.title),
        description: Value(task.description),
        status: Value(task.status),
        priority: Value(task.priority),
        dueDate: Value(task.dueDate),
        startDate: Value(task.startDate),
        completedAt: Value(task.completedAt),
        collectionId: Value(task.collectionId),
        tags: Value(task.tags),
        reminders: Value(task.reminders),
        recurrenceRule: Value(task.recurrenceRule),
        estimatedDuration: Value(task.estimatedDuration),
        actualDuration: Value(task.actualDuration),
        relatedItemIds: Value(task.relatedItemIds),
        metadata: Value(task.metadata),
        createdAt: Value(task.createdAt),
        updatedAt: Value(task.updatedAt),
        version: Value(task.version),
      );

  /// Convert database row to domain Task
  Task toDomain(TaskData data) {
    // The TaskReminderListConverter already converts the JSON to List<TaskReminder>
    final remindersList =
        data.reminders as List<TaskReminder>? ?? <TaskReminder>[];

    return Task(
      id: data.id,
      userId: data.userId,
      title: data.title,
      description: data.description,
      status: data.status,
      priority: data.priority,
      dueDate: data.dueDate,
      startDate: data.startDate,
      completedAt: data.completedAt,
      collectionId: data.collectionId,
      tags: data.tags,
      reminders: remindersList,
      recurrenceRule: data.recurrenceRule,
      estimatedDuration: data.estimatedDuration,
      actualDuration: data.actualDuration,
      relatedItemIds: data.relatedItemIds,
      metadata: data.metadata,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      version: data.version,
    );
  }
}

/// Task statistics data class
class TaskStatisticsData {
  const TaskStatisticsData({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.overdue,
    required this.dueToday,
    required this.dueThisWeek,
    required this.byPriority,
    required this.byCollection,
  });

  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final int overdue;
  final int dueToday;
  final int dueThisWeek;
  final Map<TaskPriority, int> byPriority;
  final Map<String, int> byCollection;
}
