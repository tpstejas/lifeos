// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'item.dart';

/// Collection entity - Organizational unit for grouping items
class Collection {
  const Collection({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.parentId,
    this.order = 0,
    this.isSystem = false,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
    this.itemCount = 0,
    this.metadata = const {},
  });

  /// Unique identifier
  final String id;

  /// Owner user ID
  final String userId;

  /// Display name
  final String name;

  /// Description
  final String? description;

  /// Icon name (Material icon)
  final String? icon;

  /// Color (hex string)
  final String? color;

  /// Parent collection ID (for nested collections)
  final String? parentId;

  /// Display order
  final int order;

  /// System collection (cannot be deleted)
  final bool isSystem;

  /// Default collection for new items
  final bool isDefault;

  /// Creation timestamp (UTC)
  final DateTime createdAt;

  /// Last modification timestamp (UTC)
  final DateTime updatedAt;

  /// Number of items in this collection (cached)
  final int itemCount;

  /// Flexible metadata
  final Map<String, dynamic> metadata;

  /// Create a copy with updated fields
  Collection copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? icon,
    String? color,
    String? parentId,
    int? order,
    bool? isSystem,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? itemCount,
    Map<String, dynamic>? metadata,
  }) {
    return Collection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
      isSystem: isSystem ?? this.isSystem,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      itemCount: itemCount ?? this.itemCount,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create from JSON
  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      parentId: json['parentId'] as String?,
      order: json['order'] as int? ?? 0,
      isSystem: json['isSystem'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      itemCount: json['itemCount'] as int? ?? 0,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'parentId': parentId,
      'order': order,
      'isSystem': isSystem,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'itemCount': itemCount,
      'metadata': metadata,
    };
  }

  /// Create with incremented item count
  Collection incrementItemCount() => copyWith(itemCount: itemCount + 1);

  /// Create with decremented item count
  Collection decrementItemCount() => copyWith(itemCount: itemCount - 1);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Collection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          description == other.description &&
          icon == other.icon &&
          color == other.color &&
          parentId == other.parentId &&
          order == other.order &&
          isSystem == other.isSystem &&
          isDefault == other.isDefault &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          itemCount == other.itemCount &&
          _mapEquals(metadata, other.metadata);

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        name,
        description,
        icon,
        color,
        parentId,
        order,
        isSystem,
        isDefault,
        createdAt,
        updatedAt,
        itemCount,
        metadata,
      );

  @override
  String toString() => 'Collection(id: $id, name: $name, items: $itemCount)';
}

/// Predefined system collections
class SystemCollections {
  static const String inbox = 'inbox';
  static const String tasks = 'tasks';
  static const String learning = 'learning';
  static const String references = 'references';
  static const String ideas = 'ideas';
  static const String opportunities = 'opportunities';
  static const String archive = 'archive';

  static List<Collection> getDefaults(String userId) {
    final now = DateTime.now().toUtc();
    return [
      Collection(
        id: inbox,
        userId: userId,
        name: 'Inbox',
        description: 'Quick capture - process later',
        icon: 'inbox',
        color: '#6366F1',
        order: 0,
        isSystem: true,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Collection(
        id: tasks,
        userId: userId,
        name: 'Tasks',
        description: 'Things to do',
        icon: 'task_alt',
        color: '#3B82F6',
        order: 1,
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      Collection(
        id: learning,
        userId: userId,
        name: 'Learning',
        description: 'Articles, courses, tutorials',
        icon: 'school',
        color: '#10B981',
        order: 2,
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      Collection(
        id: references,
        userId: userId,
        name: 'References',
        description: 'Documentation, specs, resources',
        icon: 'menu_book',
        color: '#8B5CF6',
        order: 3,
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      Collection(
        id: ideas,
        userId: userId,
        name: 'Ideas',
        description: 'Creative thoughts, projects',
        icon: 'lightbulb',
        color: '#F59E0B',
        order: 4,
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      Collection(
        id: opportunities,
        userId: userId,
        name: 'Opportunities',
        description: 'Jobs, hackathons, grants',
        icon: 'star',
        color: '#EF4444',
        order: 5,
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      Collection(
        id: archive,
        userId: userId,
        name: 'Archive',
        description: 'Archived items',
        icon: 'archive',
        color: '#6B7280',
        order: 99,
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
