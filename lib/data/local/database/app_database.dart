// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: library_prefixes

// Main database file with @DriftDatabase annotation and all table definitions.
// Uses conditional export for platform-specific connection functions.

import 'package:drift/drift.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/entities/digest.dart';
import 'package:lifeos/domain/entities/chat_message.dart';
import 'package:lifeos/domain/entities/task.dart';
import 'package:lifeos/domain/entities/enums.dart';
import 'package:lifeos/domain/entities/task.dart' show TaskReminder;
import 'dart:convert';

// Conditional export for platform-specific connection function
import 'database_connection.dart';

part 'app_database.g.dart';

// ============================================================================
// TABLE DEFINITIONS (must be in same library as @DriftDatabase)
// ============================================================================

/// Items table
@DataClassName('ItemData')
class Items extends Table {
  @override
  String get tableName => 'items';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text().map(const ItemTypeConverter())();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get thumbnailUrl => text().nullable()();
  TextColumn get filePath => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get collectionId => text()();
  TextColumn get tags => text().map(const StringListConverter())();
  TextColumn get metadata => text().map(const JsonMapConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get embedding =>
      text().map(const FloatListConverter()).nullable()();
  TextColumn get summary => text().nullable()();
  TextColumn get keyPoints => text().map(const StringListConverter())();
  BoolColumn get isArchived => boolean().withDefault(Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(Constant(false))();
  IntColumn get version => integer().withDefault(Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE',
      ];
}

/// Item type converter
class ItemTypeConverter extends TypeConverter<ItemType, String> {
  const ItemTypeConverter();

  @override
  ItemType fromSql(String fromDb) => ItemType.values.byName(fromDb);

  @override
  String toSql(ItemType value) => value.name;
}

/// Collections table
@DataClassName('CollectionData')
class Collections extends Table {
  @override
  String get tableName => 'collections';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get parentId => text().nullable()();
  IntColumn get order => integer().withDefault(Constant(0))();
  BoolColumn get isSystem => boolean().withDefault(Constant(false))();
  BoolColumn get isDefault => boolean().withDefault(Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get itemCount => integer().withDefault(Constant(0))();
  TextColumn get metadata => text().map(const JsonMapConverter())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (parent_id) REFERENCES collections(id) ON DELETE SET NULL',
      ];
}

/// Digests table
@DataClassName('DigestData')
class Digests extends Table {
  @override
  String get tableName => 'digests';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get period => text().map(const DigestPeriodConverter())();
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  DateTimeColumn get generatedAt => dateTime()();
  TextColumn get generationSource =>
      text().map(const InferenceSourceConverter())();
  IntColumn get version => integer().withDefault(Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Digest sections table
@DataClassName('DigestSectionData')
class DigestSections extends Table {
  @override
  String get tableName => 'digest_sections';

  TextColumn get id => text()();
  TextColumn get digestId => text()();
  TextColumn get title => text()();
  IntColumn get itemCount => integer()();
  TextColumn get insight => text()();
  TextColumn get items => text().map(const StringListConverter())();
  TextColumn get metadata => text().map(const JsonMapConverter())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (digest_id) REFERENCES digests(id) ON DELETE CASCADE',
      ];
}

/// Digest period converter
class DigestPeriodConverter extends TypeConverter<DigestPeriod, String> {
  const DigestPeriodConverter();

  @override
  DigestPeriod fromSql(String fromDb) => DigestPeriod.values.byName(fromDb);

  @override
  String toSql(DigestPeriod value) => value.name;
}

/// Chat messages table
@DataClassName('ChatMessageData')
class ChatMessages extends Table {
  @override
  String get tableName => 'chat_messages';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text()();
  TextColumn get role => text().map(const MessageRoleConverter())();
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get source => text().map(const InferenceSourceConverter())();
  TextColumn get metadata => text().map(const JsonMapConverter())();
  BoolColumn get isStreaming => boolean().withDefault(Constant(false))();
  TextColumn get error => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE',
      ];
}

/// Chat sessions table
@DataClassName('ChatSessionData')
class ChatSessions extends Table {
  @override
  String get tableName => 'chat_sessions';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get messageCount => integer().withDefault(Constant(0))();
  TextColumn get lastMessagePreview => text().nullable()();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();
  BoolColumn get isPinned => boolean().withDefault(Constant(false))();
  TextColumn get metadata => text().map(const JsonMapConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// Chat citations table
@DataClassName('ChatCitationData')
class ChatCitations extends Table {
  @override
  String get tableName => 'chat_citations';

  TextColumn get id => text()();
  TextColumn get messageId => text()();
  TextColumn get itemId => text()();
  TextColumn get title => text()();
  TextColumn get snippet => text()();
  RealColumn get score => real().nullable()();
  TextColumn get metadata => text().map(const JsonMapConverter())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (message_id) REFERENCES chat_messages(id) ON DELETE CASCADE',
      ];
}

/// Message role converter
class MessageRoleConverter extends TypeConverter<MessageRole, String> {
  const MessageRoleConverter();

  @override
  MessageRole fromSql(String fromDb) => MessageRole.values.byName(fromDb);

  @override
  String toSql(MessageRole value) => value.name;
}

/// Inference source converter
class InferenceSourceConverter extends TypeConverter<InferenceSource, String> {
  const InferenceSourceConverter();

  @override
  InferenceSource fromSql(String fromDb) =>
      InferenceSource.values.byName(fromDb);

  @override
  String toSql(InferenceSource value) => value.name;
}

/// Tasks table
@DataClassName('TaskData')
class Tasks extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().map(const TaskStatusConverter())();
  TextColumn get priority => text().map(const TaskPriorityConverter())();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get collectionId => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  TextColumn get reminders => text().map(const TaskReminderListConverter())();
  TextColumn get recurrenceRule => text().nullable()();
  IntColumn get estimatedDuration => integer().nullable()();
  IntColumn get actualDuration => integer().nullable()();
  TextColumn get relatedItemIds => text().map(const StringListConverter())();
  TextColumn get metadata => text().map(const JsonMapConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE SET NULL',
      ];
}

/// Task reminders table (for individual reminder tracking)
@DataClassName('TaskReminderData')
class TaskReminders extends Table {
  @override
  String get tableName => 'task_reminders';

  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get reminderId => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  BoolColumn get isSent => boolean().withDefault(Constant(false))();
  DateTimeColumn get sentAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE',
      ];
}

/// Task status converter
class TaskStatusConverter extends TypeConverter<TaskStatus, String> {
  const TaskStatusConverter();

  @override
  TaskStatus fromSql(String fromDb) => TaskStatus.values.byName(fromDb);

  @override
  String toSql(TaskStatus value) => value.name;
}

/// Task priority converter
class TaskPriorityConverter extends TypeConverter<TaskPriority, String> {
  const TaskPriorityConverter();

  @override
  TaskPriority fromSql(String fromDb) => TaskPriority.values.byName(fromDb);

  @override
  String toSql(TaskPriority value) => value.name;
}

/// Sync queue table (for offline-first sync)
@DataClassName('SyncQueueData')
class SyncQueue extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  TextColumn get entityType => text()(); // 'item', 'collection', 'task', etc.
  TextColumn get entityId => text()();
  TextColumn get operation => text()
      .map(const SyncOperationConverter())(); // 'create', 'update', 'delete'
  TextColumn get payload =>
      text().map(const JsonMapConverter())(); // JSON payload
  IntColumn get retryCount => integer().withDefault(Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get error => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sync operation converter
class SyncOperationConverter extends TypeConverter<SyncOperation, String> {
  const SyncOperationConverter();

  @override
  SyncOperation fromSql(String fromDb) => SyncOperation.values.byName(fromDb);

  @override
  String toSql(SyncOperation value) => value.name;
}

/// Sync operations
enum SyncOperation { create, update, delete }

/// App settings table
@DataClassName('AppSettingData')
class AppSettings extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text().map(const JsonValueConverter())();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

// ============================================================================
// CONVERTERS FOR COMPLEX TYPES
// ============================================================================

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',').where((s) => s.isNotEmpty).toList();
  }

  @override
  String toSql(List<String> value) => value.join(',');
}

class FloatListConverter extends TypeConverter<List<double>, String> {
  const FloatListConverter();

  @override
  List<double> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',').map((s) => double.parse(s)).toList();
  }

  @override
  String toSql(List<double> value) => value.map((f) => f.toString()).join(',');
}

class JsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonMapConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    if (fromDb.isEmpty) return {};
    return jsonDecode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return jsonEncode(value);
  }
}

class JsonValueConverter extends TypeConverter<dynamic, String> {
  const JsonValueConverter();

  @override
  dynamic fromSql(String fromDb) {
    if (fromDb.isEmpty) return null;
    return jsonDecode(fromDb);
  }

  @override
  String toSql(dynamic value) {
    return jsonEncode(value);
  }
}

/// TaskReminder list converter for domain TaskReminder entities
class TaskReminderListConverter
    extends TypeConverter<List<TaskReminder>, String> {
  const TaskReminderListConverter();

  @override
  List<TaskReminder> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> jsonList = jsonDecode(fromDb);
    return jsonList
        .map((e) => TaskReminder.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  String toSql(List<TaskReminder> value) {
    return jsonEncode(value.map((r) => r.toJson()).toList());
  }
}

// ============================================================================
// DRIFT DATABASE
// ============================================================================

/// Drift database for LifeOS local storage
@DriftDatabase(tables: [
  Items,
  Collections,
  Digests,
  DigestSections,
  ChatMessages,
  ChatSessions,
  ChatCitations,
  Tasks,
  TaskReminders,
  SyncQueue,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Handle migrations here
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}