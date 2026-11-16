// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digest_dao.dart';

// ignore_for_file: type=lint
mixin _$DigestDaoMixin on DatabaseAccessor<AppDatabase> {
  $DigestsTable get digests => attachedDatabase.digests;
  $DigestSectionsTable get digestSections => attachedDatabase.digestSections;
  DigestDaoManager get managers => DigestDaoManager(this);
}

class DigestDaoManager {
  final _$DigestDaoMixin _db;
  DigestDaoManager(this._db);
  $$DigestsTableTableManager get digests =>
      $$DigestsTableTableManager(_db.attachedDatabase, _db.digests);
  $$DigestSectionsTableTableManager get digestSections =>
      $$DigestSectionsTableTableManager(
          _db.attachedDatabase, _db.digestSections);
}
