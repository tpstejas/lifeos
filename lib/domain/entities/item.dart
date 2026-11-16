// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Item entity - Core content unit in LifeOS
/// Represents any saved content: notes, links, PDFs, images, recordings, etc.
class Item {
  const Item({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    this.content,
    this.sourceUrl,
    this.thumbnailUrl,
    this.filePath,
    this.fileSize,
    this.mimeType,
    required this.collectionId,
    this.tags = const [],
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
    this.embedding,
    this.summary,
    this.keyPoints = const [],
    this.isArchived = false,
    this.isFavorite = false,
    this.version = 1,
  });

  /// Unique identifier
  final String id;

  /// Owner user ID
  final String userId;

  /// Type of content
  final ItemType type;

  /// Display title
  final String title;

  /// Brief description/summary
  final String? description;

  /// Full text content (for notes, articles)
  final String? content;

  /// Original source URL (for links, articles)
  final String? sourceUrl;

  /// Thumbnail/preview image URL
  final String? thumbnailUrl;

  /// Local file path (for PDFs, images, recordings)
  final String? filePath;

  /// File size in bytes
  final int? fileSize;

  /// MIME type
  final String? mimeType;

  /// Collection this item belongs to
  final String collectionId;

  /// User-defined tags
  final List<String> tags;

  /// Flexible metadata (extracted entities, AI analysis, etc.)
  final Map<String, dynamic> metadata;

  /// Creation timestamp (UTC)
  final DateTime createdAt;

  /// Last modification timestamp (UTC)
  final DateTime updatedAt;

  /// Vector embedding for semantic search (384-dim for all-MiniLM-L6-v2)
  final List<double>? embedding;

  /// AI-generated summary
  final String? summary;

  /// AI-extracted key points
  final List<String> keyPoints;

  /// Soft delete / archive flag
  final bool isArchived;

  /// User favorite flag
  final bool isFavorite;

  /// Optimistic locking version
  final int version;

  /// Create a copy with updated fields
  Item copyWith({
    String? id,
    String? userId,
    ItemType? type,
    String? title,
    String? description,
    String? content,
    String? sourceUrl,
    String? thumbnailUrl,
    String? filePath,
    int? fileSize,
    String? mimeType,
    String? collectionId,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<double>? embedding,
    String? summary,
    List<String>? keyPoints,
    bool? isArchived,
    bool? isFavorite,
    int? version,
  }) {
    return Item(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      collectionId: collectionId ?? this.collectionId,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      embedding: embedding ?? this.embedding,
      summary: summary ?? this.summary,
      keyPoints: keyPoints ?? this.keyPoints,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      version: version ?? this.version,
    );
  }

  /// Create from JSON (for API/serialization)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: ItemType.values.byName(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      filePath: json['filePath'] as String?,
      fileSize: json['fileSize'] as int?,
      mimeType: json['mimeType'] as String?,
      collectionId: json['collectionId'] as String,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      embedding:
          (json['embedding'] as List<dynamic>?)?.cast<double>()?.toList(),
      summary: json['summary'] as String?,
      keyPoints: (json['keyPoints'] as List<dynamic>?)?.cast<String>() ?? [],
      isArchived: json['isArchived'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      version: json['version'] as int? ?? 1,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'title': title,
      'description': description,
      'content': content,
      'sourceUrl': sourceUrl,
      'thumbnailUrl': thumbnailUrl,
      'filePath': filePath,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'collectionId': collectionId,
      'tags': tags,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'embedding': embedding,
      'summary': summary,
      'keyPoints': keyPoints,
      'isArchived': isArchived,
      'isFavorite': isFavorite,
      'version': version,
    };
  }

  /// Create a new item with updated timestamp and incremented version
  Item update({
    String? title,
    String? description,
    String? content,
    String? collectionId,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    String? summary,
    List<String>? keyPoints,
    bool? isArchived,
    bool? isFavorite,
  }) {
    return copyWith(
      title: title,
      description: description,
      content: content,
      collectionId: collectionId,
      tags: tags,
      metadata: metadata,
      summary: summary,
      keyPoints: keyPoints,
      isArchived: isArchived,
      isFavorite: isFavorite,
      updatedAt: DateTime.now().toUtc(),
      version: version + 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          type == other.type &&
          title == other.title &&
          description == other.description &&
          content == other.content &&
          sourceUrl == other.sourceUrl &&
          thumbnailUrl == other.thumbnailUrl &&
          filePath == other.filePath &&
          fileSize == other.fileSize &&
          mimeType == other.mimeType &&
          collectionId == other.collectionId &&
          tags == other.tags &&
          _mapEquals(metadata, other.metadata) &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          _listEquals(embedding, other.embedding) &&
          summary == other.summary &&
          keyPoints == other.keyPoints &&
          isArchived == other.isArchived &&
          isFavorite == other.isFavorite &&
          version == other.version;

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        type,
        title,
        description,
        content,
        sourceUrl,
        thumbnailUrl,
        filePath,
        fileSize,
        mimeType,
        collectionId,
        tags,
        metadata,
        createdAt,
        updatedAt,
        embedding,
        summary,
        keyPoints,
        isArchived,
        isFavorite,
        version,
      ]);

  @override
  String toString() =>
      'Item(id: $id, title: $title, type: $type, collection: $collectionId)';
}

/// Types of items that can be saved in LifeOS
enum ItemType {
  /// Plain text note
  note,

  /// Web article / blog post
  article,

  /// Link/bookmark
  link,

  /// PDF document
  pdf,

  /// Image
  image,

  /// Audio recording
  audio,

  /// Video
  video,

  /// Task/to-do
  task,

  /// Contact
  contact,

  /// Event/calendar entry
  event,

  /// Code snippet
  code,

  /// Other/unknown
  other,
}

/// Extension for ItemType to get display names and icons
extension ItemTypeX on ItemType {
  String get displayName {
    switch (this) {
      case ItemType.note:
        return 'Note';
      case ItemType.article:
        return 'Article';
      case ItemType.link:
        return 'Link';
      case ItemType.pdf:
        return 'PDF';
      case ItemType.image:
        return 'Image';
      case ItemType.audio:
        return 'Audio';
      case ItemType.video:
        return 'Video';
      case ItemType.task:
        return 'Task';
      case ItemType.contact:
        return 'Contact';
      case ItemType.event:
        return 'Event';
      case ItemType.code:
        return 'Code';
      case ItemType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ItemType.note:
        return Icons.note;
      case ItemType.article:
        return Icons.article;
      case ItemType.link:
        return Icons.link;
      case ItemType.pdf:
        return Icons.picture_as_pdf;
      case ItemType.image:
        return Icons.image;
      case ItemType.audio:
        return Icons.audiotrack;
      case ItemType.video:
        return Icons.videocam;
      case ItemType.task:
        return Icons.task;
      case ItemType.contact:
        return Icons.person;
      case ItemType.event:
        return Icons.event;
      case ItemType.code:
        return Icons.code;
      case ItemType.other:
        return Icons.insert_drive_file;
    }
  }

  Color get color {
    switch (this) {
      case ItemType.note:
        return Colors.blue;
      case ItemType.article:
        return Colors.green;
      case ItemType.link:
        return Colors.purple;
      case ItemType.pdf:
        return Colors.red;
      case ItemType.image:
        return Colors.orange;
      case ItemType.audio:
        return Colors.teal;
      case ItemType.video:
        return Colors.pink;
      case ItemType.task:
        return Colors.indigo;
      case ItemType.contact:
        return Colors.cyan;
      case ItemType.event:
        return Colors.amber;
      case ItemType.code:
        return Colors.deepPurple;
      case ItemType.other:
        return Colors.grey;
    }
  }
}

/// Helper functions for equality checks
bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
