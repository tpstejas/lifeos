// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/domain/entities/enums.dart';

/// User entity - Represents a user of the app
class User {
  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isPremium = false,
    this.subscriptionEndDate,
    required this.createdAt,
    required this.updatedAt,
    this.stats = const UserStats(),
  });

  /// Unique identifier
  final String id;

  /// User email
  final String email;

  /// Display name
  final String? displayName;

  /// Profile photo URL
  final String? photoUrl;

  /// Whether user has premium subscription
  final bool isPremium;

  /// Subscription end date
  final DateTime? subscriptionEndDate;

  /// Account creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// User statistics
  final UserStats stats;

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isPremium,
    DateTime? subscriptionEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserStats? stats,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }

  /// Create from JSON (for API/serialization)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? DateTime.parse(json['subscriptionEndDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      stats: json['stats'] != null
          ? UserStats.fromJson(json['stats'] as Map<String, dynamic>)
          : const UserStats(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isPremium': isPremium,
      'subscriptionEndDate': subscriptionEndDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'stats': stats.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          isPremium == other.isPremium &&
          subscriptionEndDate == other.subscriptionEndDate &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          stats == other.stats;

  @override
  int get hashCode => Object.hashAll([
        id,
        email,
        displayName,
        photoUrl,
        isPremium,
        subscriptionEndDate,
        createdAt,
        updatedAt,
        stats,
      ]);

  @override
  String toString() => 'User(id: $id, email: $email, displayName: $displayName)';
}

/// User statistics
class UserStats {
  const UserStats({
    this.totalItems = 0,
    this.collectionsCount = 0,
    this.chatSessionsCount = 0,
    this.digestsGenerated = 0,
    this.tasksCompleted = 0,
    this.storageUsedBytes = 0,
  });

  final int totalItems;
  final int collectionsCount;
  final int chatSessionsCount;
  final int digestsGenerated;
  final int tasksCompleted;
  final int storageUsedBytes;

  UserStats copyWith({
    int? totalItems,
    int? collectionsCount,
    int? chatSessionsCount,
    int? digestsGenerated,
    int? tasksCompleted,
    int? storageUsedBytes,
  }) {
    return UserStats(
      totalItems: totalItems ?? this.totalItems,
      collectionsCount: collectionsCount ?? this.collectionsCount,
      chatSessionsCount: chatSessionsCount ?? this.chatSessionsCount,
      digestsGenerated: digestsGenerated ?? this.digestsGenerated,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      storageUsedBytes: storageUsedBytes ?? this.storageUsedBytes,
    );
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalItems: json['totalItems'] as int? ?? 0,
      collectionsCount: json['collectionsCount'] as int? ?? 0,
      chatSessionsCount: json['chatSessionsCount'] as int? ?? 0,
      digestsGenerated: json['digestsGenerated'] as int? ?? 0,
      tasksCompleted: json['tasksCompleted'] as int? ?? 0,
      storageUsedBytes: json['storageUsedBytes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'collectionsCount': collectionsCount,
      'chatSessionsCount': chatSessionsCount,
      'digestsGenerated': digestsGenerated,
      'tasksCompleted': tasksCompleted,
      'storageUsedBytes': storageUsedBytes,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStats &&
          runtimeType == other.runtimeType &&
          totalItems == other.totalItems &&
          collectionsCount == other.collectionsCount &&
          chatSessionsCount == other.chatSessionsCount &&
          digestsGenerated == other.digestsGenerated &&
          tasksCompleted == other.tasksCompleted &&
          storageUsedBytes == other.storageUsedBytes;

  @override
  int get hashCode => Object.hashAll([
        totalItems,
        collectionsCount,
        chatSessionsCount,
        digestsGenerated,
        tasksCompleted,
        storageUsedBytes,
      ]);
}