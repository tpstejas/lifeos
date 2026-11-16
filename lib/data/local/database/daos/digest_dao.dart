// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:drift/drift.dart';
import 'package:lifeos/data/local/database/app_database.dart';
import 'package:lifeos/domain/entities/digest.dart';
import 'dart:convert';

part 'digest_dao.g.dart';

@DriftAccessor(tables: [Digests, DigestSections])
class DigestDao extends DatabaseAccessor<AppDatabase> with _$DigestDaoMixin {
  DigestDao(super.db);

  /// Insert or update a digest
  Future<void> upsertDigest(DigestsCompanion digest) =>
      into(digests).insertOnConflictUpdate(digest);

  /// Get digest by ID
  Future<DigestData?> getDigestById(String id) =>
      (select(digests)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get all digests for user
  Future<List<DigestData>> getAllDigests({
    String? userId,
    DigestPeriod? period,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
  }) {
    var query = select(digests);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (period != null) {
      query = query..where((t) => t.period.equals(period.name));
    }
    if (fromDate != null) {
      query = query..where((t) => t.date.isBiggerOrEqualValue(fromDate));
    }
    if (toDate != null) {
      query = query..where((t) => t.date.isSmallerOrEqualValue(toDate));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (limit != null) {
      query = query..limit(limit);
    }

    return query.get();
  }

  /// Stream digests
  Stream<List<DigestData>> watchAllDigests(
      {String? userId, DigestPeriod? period}) {
    var query = select(digests);

    if (userId != null) {
      query = query..where((t) => t.userId.equals(userId));
    }
    if (period != null) {
      query = query..where((t) => t.period.equals(period.name));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.date)]);

    return query.watch();
  }

  /// Delete digest by ID
  Future<int> deleteDigest(String id) =>
      (delete(digests)..where((t) => t.id.equals(id))).go();

  /// Get latest digest for period
  Future<DigestData?> getLatestDigest(String userId, DigestPeriod period) =>
      (select(digests)
            ..where(
                (t) => t.userId.equals(userId) & t.period.equals(period.name))
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(1))
          .getSingleOrNull();

  /// Get digest by date
  Future<DigestData?> getDigestByDate(
          String userId, DigestPeriod period, DateTime date) =>
      (select(digests)
            ..where((t) =>
                t.userId.equals(userId) &
                t.period.equals(period.name) &
                t.date.equals(date)))
          .getSingleOrNull();

  /// Insert or update digest section
  Future<void> upsertDigestSection(DigestSectionsCompanion section) =>
      into(digestSections).insertOnConflictUpdate(section);

  /// Get sections for digest
  Future<List<DigestSectionData>> getSectionsForDigest(String digestId) =>
      (select(digestSections)..where((t) => t.digestId.equals(digestId))).get();

  /// Delete sections for digest
  Future<void> deleteSectionsForDigest(String digestId) =>
      (delete(digestSections)..where((t) => t.digestId.equals(digestId))).go();

  /// Convert domain Digest to database companions
  DigestsCompanion toDigestCompanion(Digest digest) => DigestsCompanion(
        id: Value(digest.id),
        userId: Value(digest.userId),
        period: Value(digest.period),
        date: Value(digest.date),
        title: Value(digest.title),
        summary: Value(digest.summary),
        generatedAt: Value(digest.generatedAt),
        generationSource: Value(digest.generationSource),
        version: Value(digest.version),
      );

  DigestSectionsCompanion toSectionCompanion(
          DigestSection section, String digestId) =>
      DigestSectionsCompanion(
        digestId: Value(digestId),
        title: Value(section.title),
        itemCount: Value(section.itemCount),
        insight: Value(section.insight),
        items: Value(section.items),
        metadata: Value(section.metadata),
      );

  /// Convert database rows to domain Digest
  Future<Digest> toDomain(DigestData digestData) async {
    final sectionsData = await getSectionsForDigest(digestData.id);
    final sections = sectionsData
        .map((s) => DigestSection(
              title: s.title,
              itemCount: s.itemCount,
              insight: s.insight,
              items: s.items,
              metadata: s.metadata,
            ))
        .toList();

    return Digest(
      id: digestData.id,
      userId: digestData.userId,
      period: digestData.period,
      date: digestData.date,
      title: digestData.title,
      summary: digestData.summary,
      sections: sections,
      generatedAt: digestData.generatedAt,
      generationSource: digestData.generationSource,
      version: digestData.version,
    );
  }
}
