// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/data/local/database/daos/task_dao.dart';
import 'package:lifeos/domain/entities/task.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Local Task Repository Implementation
class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._dao);

  final TaskDao _dao;

  @override
  Future<Task?> getById(String id) async {
    final data = await _dao.getTaskById(id);
    return data != null ? _dao.toDomain(data) : null;
  }

  @override
  Future<Task?> getTask(String id) => getById(id);

  @override
  Future<List<Task>> getAll({
    String? userId,
    String? collectionId,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
    bool? overdueOnly,
    int? limit,
    int? offset,
  }) async {
    final dataList = await _dao.getAllTasks(
      userId: userId,
      collectionId: collectionId,
      status: status,
      priority: priority,
      fromDate: fromDate,
      toDate: toDate,
      overdueOnly: overdueOnly,
      limit: limit,
      offset: offset,
    );
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Stream<List<Task>> watchAll({
    String? userId,
    String? collectionId,
    TaskStatus? status,
  }) {
    return _dao
        .watchAllTasks(
          userId: userId,
          collectionId: collectionId,
          status: status,
        )
        .map((dataList) => dataList.map(_dao.toDomain).toList());
  }

  @override
  Future<void> save(Task task) async {
    final companion = _dao.toCompanion(task);
    await _dao.upsertTask(companion);
  }

  @override
  Future<void> createTask(Task task) => save(task);

  @override
  Future<void> updateTask(Task task) => save(task);

  @override
  Future<void> delete(String id) async {
    await _dao.deleteTask(id);
  }

  @override
  Future<void> deleteTask(String id) => delete(id);

  @override
  Future<void> saveAll(List<Task> tasks) async {
    final companions = tasks.map(_dao.toCompanion).toList();
    await _dao.insertAllTasks(companions);
  }

  @override
  Future<List<Task>> getOverdue({String? userId, int? limit}) async {
    final dataList = await _dao.getOverdueTasks(userId: userId, limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Task>> getDueToday({String? userId}) async {
    final dataList = await _dao.getTasksDueToday(userId: userId);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Task>> getDueThisWeek({String? userId}) async {
    final dataList = await _dao.getTasksDueThisWeek(userId: userId);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Task>> getByStatus(TaskStatus status,
      {String? userId, int? limit}) async {
    final dataList =
        await _dao.getTasksByStatus(status, userId: userId, limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Task>> getUpcoming({String? userId, int? limit = 10}) async {
    final dataList = await _dao.getUpcomingTasks(userId: userId, limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<TaskStatistics> getStatistics(String userId) async {
    final data = await _dao.getTaskStatistics(userId);
    return TaskStatistics(
      total: data.total,
      pending: data.pending,
      inProgress: data.inProgress,
      completed: data.completed,
      overdue: data.overdue,
      dueToday: data.dueToday,
      dueThisWeek: data.dueThisWeek,
      byPriority: data.byPriority,
      byCollection: data.byCollection,
    );
  }

  @override
  Future<void> complete(String id) async {
    await _dao.completeTask(id);
  }

  @override
  Future<void> updateStatus(String id, TaskStatus status) async {
    await _dao.updateTaskStatus(id, status);
  }

  @override
  Future<List<Task>> getTasksNeedingReminders(DateTime now) async {
    final dataList = await _dao.getTasksNeedingReminders(now);
    return dataList.map(_dao.toDomain).toList();
  }

  @override
  Future<List<Task>> getModifiedAfter(DateTime timestamp, {int? limit}) async {
    final dataList = await _dao.getTasksModifiedAfter(timestamp, limit: limit);
    return dataList.map(_dao.toDomain).toList();
  }
}
