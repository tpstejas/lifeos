// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'enums.dart';

/// Digest entity - AI-generated periodic summaries
enum DigestPeriod { daily, weekly, monthly }

class Digest {
  const Digest({
    required this.id,
    required this.userId,
    required this.period,
    required this.date,
    required this.title,
    required this.summary,
    required this.sections,
    required this.generatedAt,
    this.generationSource = InferenceSource.hybrid,
    this.version = 1,
  });

  /// Unique identifier
  final String id;

  /// Owner user ID
  final String userId;

  /// Period type
  final DigestPeriod period;

  /// Period start date (UTC midnight)
  final DateTime date;

  /// Display title
  final String title;

  /// Overall summary
  final String summary;

  /// Detailed sections
  final List<DigestSection> sections;

  /// When the digest was generated
  final DateTime generatedAt;

  /// AI source used for generation
  final InferenceSource generationSource;

  /// Version for updates
  final int version;

  /// Get key insights from all sections
  List<String> get keyInsights => sections.map((s) => s.insight).toList();

  /// Get action items from all sections (items that need user action)
  List<String> get actionItems => sections
      .expand((s) => s.items)
      .toList();

  /// Create a copy with updated fields
  Digest copyWith({
    String? id,
    String? userId,
    DigestPeriod? period,
    DateTime? date,
    String? title,
    String? summary,
    List<DigestSection>? sections,
    DateTime? generatedAt,
    InferenceSource? generationSource,
    int? version,
  }) {
    return Digest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      period: period ?? this.period,
      date: date ?? this.date,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      sections: sections ?? this.sections,
      generatedAt: generatedAt ?? this.generatedAt,
      generationSource: generationSource ?? this.generationSource,
      version: version ?? this.version,
    );
  }

  /// Create from JSON
  factory Digest.fromJson(Map<String, dynamic> json) {
    return Digest(
      id: json['id'] as String,
      userId: json['userId'] as String,
      period: DigestPeriod.values.byName(json['period'] as String),
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      summary: json['summary'] as String,
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => DigestSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      generationSource: InferenceSource.values
          .byName(json['generationSource'] as String? ?? 'hybrid'),
      version: json['version'] as int? ?? 1,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'period': period.name,
      'date': date.toIso8601String(),
      'title': title,
      'summary': summary,
      'sections': sections.map((e) => e.toJson()).toList(),
      'generatedAt': generatedAt.toIso8601String(),
      'generationSource': generationSource.name,
      'version': version,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Digest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          period == other.period &&
          date == other.date &&
          title == other.title &&
          summary == other.summary &&
          sections == other.sections &&
          generatedAt == other.generatedAt &&
          generationSource == other.generationSource &&
          version == other.version;

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        period,
        date,
        title,
        summary,
        sections,
        generatedAt,
        generationSource,
        version,
      );

  @override
  String toString() => 'Digest(id: $id, period: $period, date: $date)';
}

/// Digest section entity
class DigestSection {
  const DigestSection({
    required this.title,
    required this.itemCount,
    required this.insight,
    this.items = const [],
    this.metadata = const {},
  });

  /// Section title
  final String title;

  /// Number of items in this section
  final int itemCount;

  /// AI-generated insight
  final String insight;

  /// Related item IDs (for deep linking)
  final List<String> items;

  /// Additional metadata
  final Map<String, dynamic> metadata;

  factory DigestSection.fromJson(Map<String, dynamic> json) {
    return DigestSection(
      title: json['title'] as String,
      itemCount: json['itemCount'] as int? ?? 0,
      insight: json['insight'] as String,
      items: (json['items'] as List<dynamic>?)?.cast<String>() ?? [],
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'itemCount': itemCount,
      'insight': insight,
      'items': items,
      'metadata': metadata,
    };
  }
}
