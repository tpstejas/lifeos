// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:lifeos/data/local/database/daos/digest_dao.dart';
import 'package:lifeos/domain/entities/digest.dart';
import 'package:lifeos/domain/entities/enums.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Local Digest Repository Implementation
class DigestRepositoryImpl implements DigestRepository {
  DigestRepositoryImpl(this._dao);

  final DigestDao _dao;

  @override
  Future<Digest?> getById(String id) async {
    final data = await _dao.getDigestById(id);
    return data != null ? _dao.toDomain(data) : null;
  }

  @override
  Future<Digest?> getDigest(String id) => getById(id);

  @override
  Future<List<Digest>> getAll({
    String? userId,
    DigestPeriod? period,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
  }) async {
    final dataList = await _dao.getAllDigests(
      userId: userId,
      period: period,
      fromDate: fromDate,
      toDate: toDate,
      limit: limit,
    );
    final digests = <Digest>[];
    for (final data in dataList) {
      digests.add(await _dao.toDomain(data));
    }
    return digests;
  }

  @override
  Stream<List<Digest>> watchAll({String? userId, DigestPeriod? period}) {
    return _dao
        .watchAllDigests(userId: userId, period: period)
        .asyncMap((dataList) async {
      final digests = <Digest>[];
      for (final data in dataList) {
        digests.add(await _dao.toDomain(data));
      }
      return digests;
    });
  }

  @override
  Future<void> save(Digest digest) async {
    final digestCompanion = _dao.toDigestCompanion(digest);
    await _dao.upsertDigest(digestCompanion);

    // Save sections
    await _dao.deleteSectionsForDigest(digest.id);
    for (final section in digest.sections) {
      final sectionCompanion = _dao.toSectionCompanion(section, digest.id);
      await _dao.upsertDigestSection(sectionCompanion);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteDigest(id);
  }

  @override
  Future<Digest?> getLatest(String userId, DigestPeriod period) async {
    final data = await _dao.getLatestDigest(userId, period);
    return data != null ? _dao.toDomain(data) : null;
  }

  @override
  Future<Digest?> getByDate(
      String userId, DigestPeriod period, DateTime date) async {
    final data = await _dao.getDigestByDate(userId, period, date);
    return data != null ? _dao.toDomain(data) : null;
  }

  @override
  Future<Digest> generateDigest({
    required String userId,
    required DigestPeriod period,
    required DateTime date,
    required InferenceSource source,
  }) async {
    // TODO: Implement actual AI digest generation via Cloud Functions
    // For now, return a placeholder digest
    final id = 'digest_${period.name}_${date.toIso8601String().split('T').first}';
    final title = '${period.name.toUpperCase()} Digest - ${date.day}/${date.month}/${date.year}';

    return Digest(
      id: id,
      userId: userId,
      period: period,
      date: date,
      title: title,
      summary: 'AI-generated digest for ${period.name} period.',
      sections: [
        DigestSection(
          title: 'Key Insights',
          itemCount: 0,
          insight: 'No items captured during this period.',
        ),
      ],
      generatedAt: DateTime.now().toUtc(),
      generationSource: source,
    );
  }
}
