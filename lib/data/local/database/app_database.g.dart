// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, CollectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _itemCountMeta =
      const VerificationMeta('itemCount');
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
      'item_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $CollectionsTable.$convertermetadata);
  @override
  List<GeneratedColumn> get $columns => [
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
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(Insertable<CollectionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('item_count')) {
      context.handle(_itemCountMeta,
          itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      itemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_count'])!,
      metadata: $CollectionsTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
}

class CollectionData extends DataClass implements Insertable<CollectionData> {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final String? parentId;
  final int order;
  final bool isSystem;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int itemCount;
  final Map<String, dynamic> metadata;
  const CollectionData(
      {required this.id,
      required this.userId,
      required this.name,
      this.description,
      this.icon,
      this.color,
      this.parentId,
      required this.order,
      required this.isSystem,
      required this.isDefault,
      required this.createdAt,
      required this.updatedAt,
      required this.itemCount,
      required this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['order'] = Variable<int>(order);
    map['is_system'] = Variable<bool>(isSystem);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['item_count'] = Variable<int>(itemCount);
    {
      map['metadata'] = Variable<String>(
          $CollectionsTable.$convertermetadata.toSql(metadata));
    }
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      order: Value(order),
      isSystem: Value(isSystem),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      itemCount: Value(itemCount),
      metadata: Value(metadata),
    );
  }

  factory CollectionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      order: serializer.fromJson<int>(json['order']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'parentId': serializer.toJson<String?>(parentId),
      'order': serializer.toJson<int>(order),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'itemCount': serializer.toJson<int>(itemCount),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
    };
  }

  CollectionData copyWith(
          {String? id,
          String? userId,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          Value<String?> color = const Value.absent(),
          Value<String?> parentId = const Value.absent(),
          int? order,
          bool? isSystem,
          bool? isDefault,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? itemCount,
          Map<String, dynamic>? metadata}) =>
      CollectionData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        icon: icon.present ? icon.value : this.icon,
        color: color.present ? color.value : this.color,
        parentId: parentId.present ? parentId.value : this.parentId,
        order: order ?? this.order,
        isSystem: isSystem ?? this.isSystem,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        itemCount: itemCount ?? this.itemCount,
        metadata: metadata ?? this.metadata,
      );
  CollectionData copyWithCompanion(CollectionsCompanion data) {
    return CollectionData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      order: data.order.present ? data.order.value : this.order,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('parentId: $parentId, ')
          ..write('order: $order, ')
          ..write('isSystem: $isSystem, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('itemCount: $itemCount, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

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
      metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.parentId == this.parentId &&
          other.order == this.order &&
          other.isSystem == this.isSystem &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.itemCount == this.itemCount &&
          other.metadata == this.metadata);
}

class CollectionsCompanion extends UpdateCompanion<CollectionData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<String?> parentId;
  final Value<int> order;
  final Value<bool> isSystem;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> itemCount;
  final Value<Map<String, dynamic>> metadata;
  final Value<int> rowid;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.parentId = const Value.absent(),
    this.order = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.parentId = const Value.absent(),
    this.order = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.itemCount = const Value.absent(),
    required Map<String, dynamic> metadata,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        metadata = Value(metadata);
  static Insertable<CollectionData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<String>? parentId,
    Expression<int>? order,
    Expression<bool>? isSystem,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? itemCount,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (parentId != null) 'parent_id': parentId,
      if (order != null) 'order': order,
      if (isSystem != null) 'is_system': isSystem,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (itemCount != null) 'item_count': itemCount,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? icon,
      Value<String?>? color,
      Value<String?>? parentId,
      Value<int>? order,
      Value<bool>? isSystem,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? itemCount,
      Value<Map<String, dynamic>>? metadata,
      Value<int>? rowid}) {
    return CollectionsCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $CollectionsTable.$convertermetadata.toSql(metadata.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('parentId: $parentId, ')
          ..write('order: $order, ')
          ..write('isSystem: $isSystem, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('itemCount: $itemCount, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<ItemType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ItemType>($ItemsTable.$convertertype);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceUrlMeta =
      const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
      'source_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _thumbnailUrlMeta =
      const VerificationMeta('thumbnailUrl');
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
      'thumbnail_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _collectionIdMeta =
      const VerificationMeta('collectionId');
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
      'collection_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($ItemsTable.$convertertags);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($ItemsTable.$convertermetadata);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<double>?, String> embedding =
      GeneratedColumn<String>('embedding', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<double>?>($ItemsTable.$converterembeddingn);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> keyPoints =
      GeneratedColumn<String>('key_points', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($ItemsTable.$converterkeyPoints);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
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
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<ItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta,
          sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
          _thumbnailUrlMeta,
          thumbnailUrl.isAcceptableOrUnknown(
              data['thumbnail_url']!, _thumbnailUrlMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
          _collectionIdMeta,
          collectionId.isAcceptableOrUnknown(
              data['collection_id']!, _collectionIdMeta));
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      type: $ItemsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      sourceUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_url']),
      thumbnailUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_url']),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      collectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collection_id'])!,
      tags: $ItemsTable.$convertertags.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
      metadata: $ItemsTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      embedding: $ItemsTable.$converterembeddingn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}embedding'])),
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      keyPoints: $ItemsTable.$converterkeyPoints.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_points'])!),
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<ItemType, String> $convertertype =
      const ItemTypeConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
  static TypeConverter<List<double>, String> $converterembedding =
      const FloatListConverter();
  static TypeConverter<List<double>?, String?> $converterembeddingn =
      NullAwareTypeConverter.wrap($converterembedding);
  static TypeConverter<List<String>, String> $converterkeyPoints =
      const StringListConverter();
}

class ItemData extends DataClass implements Insertable<ItemData> {
  final String id;
  final String userId;
  final ItemType type;
  final String title;
  final String? description;
  final String? content;
  final String? sourceUrl;
  final String? thumbnailUrl;
  final String? filePath;
  final int? fileSize;
  final String? mimeType;
  final String collectionId;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<double>? embedding;
  final String? summary;
  final List<String> keyPoints;
  final bool isArchived;
  final bool isFavorite;
  final int version;
  const ItemData(
      {required this.id,
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
      required this.tags,
      required this.metadata,
      required this.createdAt,
      required this.updatedAt,
      this.embedding,
      this.summary,
      required this.keyPoints,
      required this.isArchived,
      required this.isFavorite,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    {
      map['type'] = Variable<String>($ItemsTable.$convertertype.toSql(type));
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['collection_id'] = Variable<String>(collectionId);
    {
      map['tags'] = Variable<String>($ItemsTable.$convertertags.toSql(tags));
    }
    {
      map['metadata'] =
          Variable<String>($ItemsTable.$convertermetadata.toSql(metadata));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || embedding != null) {
      map['embedding'] =
          Variable<String>($ItemsTable.$converterembeddingn.toSql(embedding));
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    {
      map['key_points'] =
          Variable<String>($ItemsTable.$converterkeyPoints.toSql(keyPoints));
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['version'] = Variable<int>(version);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      collectionId: Value(collectionId),
      tags: Value(tags),
      metadata: Value(metadata),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      embedding: embedding == null && nullToAbsent
          ? const Value.absent()
          : Value(embedding),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      keyPoints: Value(keyPoints),
      isArchived: Value(isArchived),
      isFavorite: Value(isFavorite),
      version: Value(version),
    );
  }

  factory ItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<ItemType>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      content: serializer.fromJson<String?>(json['content']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      collectionId: serializer.fromJson<String>(json['collectionId']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      embedding: serializer.fromJson<List<double>?>(json['embedding']),
      summary: serializer.fromJson<String?>(json['summary']),
      keyPoints: serializer.fromJson<List<String>>(json['keyPoints']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<ItemType>(type),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'content': serializer.toJson<String?>(content),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'filePath': serializer.toJson<String?>(filePath),
      'fileSize': serializer.toJson<int?>(fileSize),
      'mimeType': serializer.toJson<String?>(mimeType),
      'collectionId': serializer.toJson<String>(collectionId),
      'tags': serializer.toJson<List<String>>(tags),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'embedding': serializer.toJson<List<double>?>(embedding),
      'summary': serializer.toJson<String?>(summary),
      'keyPoints': serializer.toJson<List<String>>(keyPoints),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'version': serializer.toJson<int>(version),
    };
  }

  ItemData copyWith(
          {String? id,
          String? userId,
          ItemType? type,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> content = const Value.absent(),
          Value<String?> sourceUrl = const Value.absent(),
          Value<String?> thumbnailUrl = const Value.absent(),
          Value<String?> filePath = const Value.absent(),
          Value<int?> fileSize = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          String? collectionId,
          List<String>? tags,
          Map<String, dynamic>? metadata,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<List<double>?> embedding = const Value.absent(),
          Value<String?> summary = const Value.absent(),
          List<String>? keyPoints,
          bool? isArchived,
          bool? isFavorite,
          int? version}) =>
      ItemData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        content: content.present ? content.value : this.content,
        sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
        thumbnailUrl:
            thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
        filePath: filePath.present ? filePath.value : this.filePath,
        fileSize: fileSize.present ? fileSize.value : this.fileSize,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        collectionId: collectionId ?? this.collectionId,
        tags: tags ?? this.tags,
        metadata: metadata ?? this.metadata,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        embedding: embedding.present ? embedding.value : this.embedding,
        summary: summary.present ? summary.value : this.summary,
        keyPoints: keyPoints ?? this.keyPoints,
        isArchived: isArchived ?? this.isArchived,
        isFavorite: isFavorite ?? this.isFavorite,
        version: version ?? this.version,
      );
  ItemData copyWithCompanion(ItemsCompanion data) {
    return ItemData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      content: data.content.present ? data.content.value : this.content,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      tags: data.tags.present ? data.tags.value : this.tags,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      embedding: data.embedding.present ? data.embedding.value : this.embedding,
      summary: data.summary.present ? data.summary.value : this.summary,
      keyPoints: data.keyPoints.present ? data.keyPoints.value : this.keyPoints,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('mimeType: $mimeType, ')
          ..write('collectionId: $collectionId, ')
          ..write('tags: $tags, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('embedding: $embedding, ')
          ..write('summary: $summary, ')
          ..write('keyPoints: $keyPoints, ')
          ..write('isArchived: $isArchived, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

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
        version
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.content == this.content &&
          other.sourceUrl == this.sourceUrl &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.filePath == this.filePath &&
          other.fileSize == this.fileSize &&
          other.mimeType == this.mimeType &&
          other.collectionId == this.collectionId &&
          other.tags == this.tags &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.embedding == this.embedding &&
          other.summary == this.summary &&
          other.keyPoints == this.keyPoints &&
          other.isArchived == this.isArchived &&
          other.isFavorite == this.isFavorite &&
          other.version == this.version);
}

class ItemsCompanion extends UpdateCompanion<ItemData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<ItemType> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> content;
  final Value<String?> sourceUrl;
  final Value<String?> thumbnailUrl;
  final Value<String?> filePath;
  final Value<int?> fileSize;
  final Value<String?> mimeType;
  final Value<String> collectionId;
  final Value<List<String>> tags;
  final Value<Map<String, dynamic>> metadata;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<List<double>?> embedding;
  final Value<String?> summary;
  final Value<List<String>> keyPoints;
  final Value<bool> isArchived;
  final Value<bool> isFavorite;
  final Value<int> version;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.content = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.tags = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.embedding = const Value.absent(),
    this.summary = const Value.absent(),
    this.keyPoints = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String userId,
    required ItemType type,
    required String title,
    this.description = const Value.absent(),
    this.content = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.mimeType = const Value.absent(),
    required String collectionId,
    required List<String> tags,
    required Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.embedding = const Value.absent(),
    this.summary = const Value.absent(),
    required List<String> keyPoints,
    this.isArchived = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        type = Value(type),
        title = Value(title),
        collectionId = Value(collectionId),
        tags = Value(tags),
        metadata = Value(metadata),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        keyPoints = Value(keyPoints);
  static Insertable<ItemData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? content,
    Expression<String>? sourceUrl,
    Expression<String>? thumbnailUrl,
    Expression<String>? filePath,
    Expression<int>? fileSize,
    Expression<String>? mimeType,
    Expression<String>? collectionId,
    Expression<String>? tags,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? embedding,
    Expression<String>? summary,
    Expression<String>? keyPoints,
    Expression<bool>? isArchived,
    Expression<bool>? isFavorite,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (content != null) 'content': content,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      if (mimeType != null) 'mime_type': mimeType,
      if (collectionId != null) 'collection_id': collectionId,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (embedding != null) 'embedding': embedding,
      if (summary != null) 'summary': summary,
      if (keyPoints != null) 'key_points': keyPoints,
      if (isArchived != null) 'is_archived': isArchived,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<ItemType>? type,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? content,
      Value<String?>? sourceUrl,
      Value<String?>? thumbnailUrl,
      Value<String?>? filePath,
      Value<int?>? fileSize,
      Value<String?>? mimeType,
      Value<String>? collectionId,
      Value<List<String>>? tags,
      Value<Map<String, dynamic>>? metadata,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<List<double>?>? embedding,
      Value<String?>? summary,
      Value<List<String>>? keyPoints,
      Value<bool>? isArchived,
      Value<bool>? isFavorite,
      Value<int>? version,
      Value<int>? rowid}) {
    return ItemsCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($ItemsTable.$convertertype.toSql(type.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($ItemsTable.$convertertags.toSql(tags.value));
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $ItemsTable.$convertermetadata.toSql(metadata.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (embedding.present) {
      map['embedding'] = Variable<String>(
          $ItemsTable.$converterembeddingn.toSql(embedding.value));
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (keyPoints.present) {
      map['key_points'] = Variable<String>(
          $ItemsTable.$converterkeyPoints.toSql(keyPoints.value));
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('mimeType: $mimeType, ')
          ..write('collectionId: $collectionId, ')
          ..write('tags: $tags, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('embedding: $embedding, ')
          ..write('summary: $summary, ')
          ..write('keyPoints: $keyPoints, ')
          ..write('isArchived: $isArchived, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigestsTable extends Digests with TableInfo<$DigestsTable, DigestData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<DigestPeriod, String> period =
      GeneratedColumn<String>('period', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DigestPeriod>($DigestsTable.$converterperiod);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<InferenceSource, String>
      generationSource = GeneratedColumn<String>(
              'generation_source', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<InferenceSource>(
              $DigestsTable.$convertergenerationSource);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        period,
        date,
        title,
        summary,
        generatedAt,
        generationSource,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digests';
  @override
  VerificationContext validateIntegrity(Insertable<DigestData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigestData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigestData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      period: $DigestsTable.$converterperiod.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period'])!),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      generationSource: $DigestsTable.$convertergenerationSource.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}generation_source'])!),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $DigestsTable createAlias(String alias) {
    return $DigestsTable(attachedDatabase, alias);
  }

  static TypeConverter<DigestPeriod, String> $converterperiod =
      const DigestPeriodConverter();
  static TypeConverter<InferenceSource, String> $convertergenerationSource =
      const InferenceSourceConverter();
}

class DigestData extends DataClass implements Insertable<DigestData> {
  final String id;
  final String userId;
  final DigestPeriod period;
  final DateTime date;
  final String title;
  final String summary;
  final DateTime generatedAt;
  final InferenceSource generationSource;
  final int version;
  const DigestData(
      {required this.id,
      required this.userId,
      required this.period,
      required this.date,
      required this.title,
      required this.summary,
      required this.generatedAt,
      required this.generationSource,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    {
      map['period'] =
          Variable<String>($DigestsTable.$converterperiod.toSql(period));
    }
    map['date'] = Variable<DateTime>(date);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    {
      map['generation_source'] = Variable<String>(
          $DigestsTable.$convertergenerationSource.toSql(generationSource));
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  DigestsCompanion toCompanion(bool nullToAbsent) {
    return DigestsCompanion(
      id: Value(id),
      userId: Value(userId),
      period: Value(period),
      date: Value(date),
      title: Value(title),
      summary: Value(summary),
      generatedAt: Value(generatedAt),
      generationSource: Value(generationSource),
      version: Value(version),
    );
  }

  factory DigestData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigestData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      period: serializer.fromJson<DigestPeriod>(json['period']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      generationSource:
          serializer.fromJson<InferenceSource>(json['generationSource']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'period': serializer.toJson<DigestPeriod>(period),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'generationSource': serializer.toJson<InferenceSource>(generationSource),
      'version': serializer.toJson<int>(version),
    };
  }

  DigestData copyWith(
          {String? id,
          String? userId,
          DigestPeriod? period,
          DateTime? date,
          String? title,
          String? summary,
          DateTime? generatedAt,
          InferenceSource? generationSource,
          int? version}) =>
      DigestData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        period: period ?? this.period,
        date: date ?? this.date,
        title: title ?? this.title,
        summary: summary ?? this.summary,
        generatedAt: generatedAt ?? this.generatedAt,
        generationSource: generationSource ?? this.generationSource,
        version: version ?? this.version,
      );
  DigestData copyWithCompanion(DigestsCompanion data) {
    return DigestData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      period: data.period.present ? data.period.value : this.period,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      generationSource: data.generationSource.present
          ? data.generationSource.value
          : this.generationSource,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigestData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('period: $period, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('generationSource: $generationSource, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, period, date, title, summary,
      generatedAt, generationSource, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigestData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.period == this.period &&
          other.date == this.date &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.generatedAt == this.generatedAt &&
          other.generationSource == this.generationSource &&
          other.version == this.version);
}

class DigestsCompanion extends UpdateCompanion<DigestData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DigestPeriod> period;
  final Value<DateTime> date;
  final Value<String> title;
  final Value<String> summary;
  final Value<DateTime> generatedAt;
  final Value<InferenceSource> generationSource;
  final Value<int> version;
  final Value<int> rowid;
  const DigestsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.period = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.generationSource = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigestsCompanion.insert({
    required String id,
    required String userId,
    required DigestPeriod period,
    required DateTime date,
    required String title,
    required String summary,
    required DateTime generatedAt,
    required InferenceSource generationSource,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        period = Value(period),
        date = Value(date),
        title = Value(title),
        summary = Value(summary),
        generatedAt = Value(generatedAt),
        generationSource = Value(generationSource);
  static Insertable<DigestData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? period,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<DateTime>? generatedAt,
    Expression<String>? generationSource,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (period != null) 'period': period,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (generationSource != null) 'generation_source': generationSource,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigestsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<DigestPeriod>? period,
      Value<DateTime>? date,
      Value<String>? title,
      Value<String>? summary,
      Value<DateTime>? generatedAt,
      Value<InferenceSource>? generationSource,
      Value<int>? version,
      Value<int>? rowid}) {
    return DigestsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      period: period ?? this.period,
      date: date ?? this.date,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      generatedAt: generatedAt ?? this.generatedAt,
      generationSource: generationSource ?? this.generationSource,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (period.present) {
      map['period'] =
          Variable<String>($DigestsTable.$converterperiod.toSql(period.value));
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (generationSource.present) {
      map['generation_source'] = Variable<String>($DigestsTable
          .$convertergenerationSource
          .toSql(generationSource.value));
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigestsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('period: $period, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('generationSource: $generationSource, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigestSectionsTable extends DigestSections
    with TableInfo<$DigestSectionsTable, DigestSectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigestSectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _digestIdMeta =
      const VerificationMeta('digestId');
  @override
  late final GeneratedColumn<String> digestId = GeneratedColumn<String>(
      'digest_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemCountMeta =
      const VerificationMeta('itemCount');
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
      'item_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _insightMeta =
      const VerificationMeta('insight');
  @override
  late final GeneratedColumn<String> insight = GeneratedColumn<String>(
      'insight', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> items =
      GeneratedColumn<String>('items', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($DigestSectionsTable.$converteritems);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $DigestSectionsTable.$convertermetadata);
  @override
  List<GeneratedColumn> get $columns =>
      [id, digestId, title, itemCount, insight, items, metadata];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digest_sections';
  @override
  VerificationContext validateIntegrity(Insertable<DigestSectionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('digest_id')) {
      context.handle(_digestIdMeta,
          digestId.isAcceptableOrUnknown(data['digest_id']!, _digestIdMeta));
    } else if (isInserting) {
      context.missing(_digestIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('item_count')) {
      context.handle(_itemCountMeta,
          itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta));
    } else if (isInserting) {
      context.missing(_itemCountMeta);
    }
    if (data.containsKey('insight')) {
      context.handle(_insightMeta,
          insight.isAcceptableOrUnknown(data['insight']!, _insightMeta));
    } else if (isInserting) {
      context.missing(_insightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigestSectionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigestSectionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      digestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}digest_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      itemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_count'])!,
      insight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}insight'])!,
      items: $DigestSectionsTable.$converteritems.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items'])!),
      metadata: $DigestSectionsTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
    );
  }

  @override
  $DigestSectionsTable createAlias(String alias) {
    return $DigestSectionsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converteritems =
      const StringListConverter();
  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
}

class DigestSectionData extends DataClass
    implements Insertable<DigestSectionData> {
  final String id;
  final String digestId;
  final String title;
  final int itemCount;
  final String insight;
  final List<String> items;
  final Map<String, dynamic> metadata;
  const DigestSectionData(
      {required this.id,
      required this.digestId,
      required this.title,
      required this.itemCount,
      required this.insight,
      required this.items,
      required this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['digest_id'] = Variable<String>(digestId);
    map['title'] = Variable<String>(title);
    map['item_count'] = Variable<int>(itemCount);
    map['insight'] = Variable<String>(insight);
    {
      map['items'] =
          Variable<String>($DigestSectionsTable.$converteritems.toSql(items));
    }
    {
      map['metadata'] = Variable<String>(
          $DigestSectionsTable.$convertermetadata.toSql(metadata));
    }
    return map;
  }

  DigestSectionsCompanion toCompanion(bool nullToAbsent) {
    return DigestSectionsCompanion(
      id: Value(id),
      digestId: Value(digestId),
      title: Value(title),
      itemCount: Value(itemCount),
      insight: Value(insight),
      items: Value(items),
      metadata: Value(metadata),
    );
  }

  factory DigestSectionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigestSectionData(
      id: serializer.fromJson<String>(json['id']),
      digestId: serializer.fromJson<String>(json['digestId']),
      title: serializer.fromJson<String>(json['title']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
      insight: serializer.fromJson<String>(json['insight']),
      items: serializer.fromJson<List<String>>(json['items']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'digestId': serializer.toJson<String>(digestId),
      'title': serializer.toJson<String>(title),
      'itemCount': serializer.toJson<int>(itemCount),
      'insight': serializer.toJson<String>(insight),
      'items': serializer.toJson<List<String>>(items),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
    };
  }

  DigestSectionData copyWith(
          {String? id,
          String? digestId,
          String? title,
          int? itemCount,
          String? insight,
          List<String>? items,
          Map<String, dynamic>? metadata}) =>
      DigestSectionData(
        id: id ?? this.id,
        digestId: digestId ?? this.digestId,
        title: title ?? this.title,
        itemCount: itemCount ?? this.itemCount,
        insight: insight ?? this.insight,
        items: items ?? this.items,
        metadata: metadata ?? this.metadata,
      );
  DigestSectionData copyWithCompanion(DigestSectionsCompanion data) {
    return DigestSectionData(
      id: data.id.present ? data.id.value : this.id,
      digestId: data.digestId.present ? data.digestId.value : this.digestId,
      title: data.title.present ? data.title.value : this.title,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      insight: data.insight.present ? data.insight.value : this.insight,
      items: data.items.present ? data.items.value : this.items,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigestSectionData(')
          ..write('id: $id, ')
          ..write('digestId: $digestId, ')
          ..write('title: $title, ')
          ..write('itemCount: $itemCount, ')
          ..write('insight: $insight, ')
          ..write('items: $items, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, digestId, title, itemCount, insight, items, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigestSectionData &&
          other.id == this.id &&
          other.digestId == this.digestId &&
          other.title == this.title &&
          other.itemCount == this.itemCount &&
          other.insight == this.insight &&
          other.items == this.items &&
          other.metadata == this.metadata);
}

class DigestSectionsCompanion extends UpdateCompanion<DigestSectionData> {
  final Value<String> id;
  final Value<String> digestId;
  final Value<String> title;
  final Value<int> itemCount;
  final Value<String> insight;
  final Value<List<String>> items;
  final Value<Map<String, dynamic>> metadata;
  final Value<int> rowid;
  const DigestSectionsCompanion({
    this.id = const Value.absent(),
    this.digestId = const Value.absent(),
    this.title = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.insight = const Value.absent(),
    this.items = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigestSectionsCompanion.insert({
    required String id,
    required String digestId,
    required String title,
    required int itemCount,
    required String insight,
    required List<String> items,
    required Map<String, dynamic> metadata,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        digestId = Value(digestId),
        title = Value(title),
        itemCount = Value(itemCount),
        insight = Value(insight),
        items = Value(items),
        metadata = Value(metadata);
  static Insertable<DigestSectionData> custom({
    Expression<String>? id,
    Expression<String>? digestId,
    Expression<String>? title,
    Expression<int>? itemCount,
    Expression<String>? insight,
    Expression<String>? items,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (digestId != null) 'digest_id': digestId,
      if (title != null) 'title': title,
      if (itemCount != null) 'item_count': itemCount,
      if (insight != null) 'insight': insight,
      if (items != null) 'items': items,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigestSectionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? digestId,
      Value<String>? title,
      Value<int>? itemCount,
      Value<String>? insight,
      Value<List<String>>? items,
      Value<Map<String, dynamic>>? metadata,
      Value<int>? rowid}) {
    return DigestSectionsCompanion(
      id: id ?? this.id,
      digestId: digestId ?? this.digestId,
      title: title ?? this.title,
      itemCount: itemCount ?? this.itemCount,
      insight: insight ?? this.insight,
      items: items ?? this.items,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (digestId.present) {
      map['digest_id'] = Variable<String>(digestId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (insight.present) {
      map['insight'] = Variable<String>(insight.value);
    }
    if (items.present) {
      map['items'] = Variable<String>(
          $DigestSectionsTable.$converteritems.toSql(items.value));
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $DigestSectionsTable.$convertermetadata.toSql(metadata.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigestSectionsCompanion(')
          ..write('id: $id, ')
          ..write('digestId: $digestId, ')
          ..write('title: $title, ')
          ..write('itemCount: $itemCount, ')
          ..write('insight: $insight, ')
          ..write('items: $items, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatSessionsTable extends ChatSessions
    with TableInfo<$ChatSessionsTable, ChatSessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _messageCountMeta =
      const VerificationMeta('messageCount');
  @override
  late final GeneratedColumn<int> messageCount = GeneratedColumn<int>(
      'message_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _lastMessagePreviewMeta =
      const VerificationMeta('lastMessagePreview');
  @override
  late final GeneratedColumn<String> lastMessagePreview =
      GeneratedColumn<String>('last_message_preview', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>('last_message_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $ChatSessionsTable.$convertermetadata);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        createdAt,
        updatedAt,
        messageCount,
        lastMessagePreview,
        lastMessageAt,
        isPinned,
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<ChatSessionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('message_count')) {
      context.handle(
          _messageCountMeta,
          messageCount.isAcceptableOrUnknown(
              data['message_count']!, _messageCountMeta));
    }
    if (data.containsKey('last_message_preview')) {
      context.handle(
          _lastMessagePreviewMeta,
          lastMessagePreview.isAcceptableOrUnknown(
              data['last_message_preview']!, _lastMessagePreviewMeta));
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
          _lastMessageAtMeta,
          lastMessageAt.isAcceptableOrUnknown(
              data['last_message_at']!, _lastMessageAtMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatSessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatSessionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      messageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}message_count'])!,
      lastMessagePreview: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_message_preview']),
      lastMessageAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_message_at']),
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      metadata: $ChatSessionsTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
    );
  }

  @override
  $ChatSessionsTable createAlias(String alias) {
    return $ChatSessionsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
}

class ChatSessionData extends DataClass implements Insertable<ChatSessionData> {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final bool isPinned;
  final Map<String, dynamic> metadata;
  const ChatSessionData(
      {required this.id,
      required this.userId,
      required this.title,
      required this.createdAt,
      required this.updatedAt,
      required this.messageCount,
      this.lastMessagePreview,
      this.lastMessageAt,
      required this.isPinned,
      required this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['message_count'] = Variable<int>(messageCount);
    if (!nullToAbsent || lastMessagePreview != null) {
      map['last_message_preview'] = Variable<String>(lastMessagePreview);
    }
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    {
      map['metadata'] = Variable<String>(
          $ChatSessionsTable.$convertermetadata.toSql(metadata));
    }
    return map;
  }

  ChatSessionsCompanion toCompanion(bool nullToAbsent) {
    return ChatSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      messageCount: Value(messageCount),
      lastMessagePreview: lastMessagePreview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessagePreview),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      isPinned: Value(isPinned),
      metadata: Value(metadata),
    );
  }

  factory ChatSessionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatSessionData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      messageCount: serializer.fromJson<int>(json['messageCount']),
      lastMessagePreview:
          serializer.fromJson<String?>(json['lastMessagePreview']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'messageCount': serializer.toJson<int>(messageCount),
      'lastMessagePreview': serializer.toJson<String?>(lastMessagePreview),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'isPinned': serializer.toJson<bool>(isPinned),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
    };
  }

  ChatSessionData copyWith(
          {String? id,
          String? userId,
          String? title,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? messageCount,
          Value<String?> lastMessagePreview = const Value.absent(),
          Value<DateTime?> lastMessageAt = const Value.absent(),
          bool? isPinned,
          Map<String, dynamic>? metadata}) =>
      ChatSessionData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        messageCount: messageCount ?? this.messageCount,
        lastMessagePreview: lastMessagePreview.present
            ? lastMessagePreview.value
            : this.lastMessagePreview,
        lastMessageAt:
            lastMessageAt.present ? lastMessageAt.value : this.lastMessageAt,
        isPinned: isPinned ?? this.isPinned,
        metadata: metadata ?? this.metadata,
      );
  ChatSessionData copyWithCompanion(ChatSessionsCompanion data) {
    return ChatSessionData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      messageCount: data.messageCount.present
          ? data.messageCount.value
          : this.messageCount,
      lastMessagePreview: data.lastMessagePreview.present
          ? data.lastMessagePreview.value
          : this.lastMessagePreview,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('messageCount: $messageCount, ')
          ..write('lastMessagePreview: $lastMessagePreview, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, title, createdAt, updatedAt,
      messageCount, lastMessagePreview, lastMessageAt, isPinned, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatSessionData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.messageCount == this.messageCount &&
          other.lastMessagePreview == this.lastMessagePreview &&
          other.lastMessageAt == this.lastMessageAt &&
          other.isPinned == this.isPinned &&
          other.metadata == this.metadata);
}

class ChatSessionsCompanion extends UpdateCompanion<ChatSessionData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> messageCount;
  final Value<String?> lastMessagePreview;
  final Value<DateTime?> lastMessageAt;
  final Value<bool> isPinned;
  final Value<Map<String, dynamic>> metadata;
  final Value<int> rowid;
  const ChatSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.messageCount = const Value.absent(),
    this.lastMessagePreview = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatSessionsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.messageCount = const Value.absent(),
    this.lastMessagePreview = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    required Map<String, dynamic> metadata,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        metadata = Value(metadata);
  static Insertable<ChatSessionData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? messageCount,
    Expression<String>? lastMessagePreview,
    Expression<DateTime>? lastMessageAt,
    Expression<bool>? isPinned,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (messageCount != null) 'message_count': messageCount,
      if (lastMessagePreview != null)
        'last_message_preview': lastMessagePreview,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (isPinned != null) 'is_pinned': isPinned,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? messageCount,
      Value<String?>? lastMessagePreview,
      Value<DateTime?>? lastMessageAt,
      Value<bool>? isPinned,
      Value<Map<String, dynamic>>? metadata,
      Value<int>? rowid}) {
    return ChatSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      isPinned: isPinned ?? this.isPinned,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (messageCount.present) {
      map['message_count'] = Variable<int>(messageCount.value);
    }
    if (lastMessagePreview.present) {
      map['last_message_preview'] = Variable<String>(lastMessagePreview.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $ChatSessionsTable.$convertermetadata.toSql(metadata.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('messageCount: $messageCount, ')
          ..write('lastMessagePreview: $lastMessagePreview, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<MessageRole, String> role =
      GeneratedColumn<String>('role', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MessageRole>($ChatMessagesTable.$converterrole);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<InferenceSource, String> source =
      GeneratedColumn<String>('source', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<InferenceSource>($ChatMessagesTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $ChatMessagesTable.$convertermetadata);
  static const VerificationMeta _isStreamingMeta =
      const VerificationMeta('isStreaming');
  @override
  late final GeneratedColumn<bool> isStreaming = GeneratedColumn<bool>(
      'is_streaming', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_streaming" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        sessionId,
        role,
        content,
        timestamp,
        source,
        metadata,
        isStreaming,
        error
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_streaming')) {
      context.handle(
          _isStreamingMeta,
          isStreaming.isAcceptableOrUnknown(
              data['is_streaming']!, _isStreamingMeta));
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      role: $ChatMessagesTable.$converterrole.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      source: $ChatMessagesTable.$convertersource.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!),
      metadata: $ChatMessagesTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
      isStreaming: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_streaming'])!,
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }

  static TypeConverter<MessageRole, String> $converterrole =
      const MessageRoleConverter();
  static TypeConverter<InferenceSource, String> $convertersource =
      const InferenceSourceConverter();
  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
}

class ChatMessageData extends DataClass implements Insertable<ChatMessageData> {
  final String id;
  final String userId;
  final String sessionId;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final InferenceSource source;
  final Map<String, dynamic> metadata;
  final bool isStreaming;
  final String? error;
  const ChatMessageData(
      {required this.id,
      required this.userId,
      required this.sessionId,
      required this.role,
      required this.content,
      required this.timestamp,
      required this.source,
      required this.metadata,
      required this.isStreaming,
      this.error});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['session_id'] = Variable<String>(sessionId);
    {
      map['role'] =
          Variable<String>($ChatMessagesTable.$converterrole.toSql(role));
    }
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    {
      map['source'] =
          Variable<String>($ChatMessagesTable.$convertersource.toSql(source));
    }
    {
      map['metadata'] = Variable<String>(
          $ChatMessagesTable.$convertermetadata.toSql(metadata));
    }
    map['is_streaming'] = Variable<bool>(isStreaming);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      userId: Value(userId),
      sessionId: Value(sessionId),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
      source: Value(source),
      metadata: Value(metadata),
      isStreaming: Value(isStreaming),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
    );
  }

  factory ChatMessageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      role: serializer.fromJson<MessageRole>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      source: serializer.fromJson<InferenceSource>(json['source']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
      isStreaming: serializer.fromJson<bool>(json['isStreaming']),
      error: serializer.fromJson<String?>(json['error']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sessionId': serializer.toJson<String>(sessionId),
      'role': serializer.toJson<MessageRole>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'source': serializer.toJson<InferenceSource>(source),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
      'isStreaming': serializer.toJson<bool>(isStreaming),
      'error': serializer.toJson<String?>(error),
    };
  }

  ChatMessageData copyWith(
          {String? id,
          String? userId,
          String? sessionId,
          MessageRole? role,
          String? content,
          DateTime? timestamp,
          InferenceSource? source,
          Map<String, dynamic>? metadata,
          bool? isStreaming,
          Value<String?> error = const Value.absent()}) =>
      ChatMessageData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        sessionId: sessionId ?? this.sessionId,
        role: role ?? this.role,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        source: source ?? this.source,
        metadata: metadata ?? this.metadata,
        isStreaming: isStreaming ?? this.isStreaming,
        error: error.present ? error.value : this.error,
      );
  ChatMessageData copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessageData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      source: data.source.present ? data.source.value : this.source,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      isStreaming:
          data.isStreaming.present ? data.isStreaming.value : this.isStreaming,
      error: data.error.present ? data.error.value : this.error,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('metadata: $metadata, ')
          ..write('isStreaming: $isStreaming, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, sessionId, role, content,
      timestamp, source, metadata, isStreaming, error);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sessionId == this.sessionId &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.source == this.source &&
          other.metadata == this.metadata &&
          other.isStreaming == this.isStreaming &&
          other.error == this.error);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessageData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sessionId;
  final Value<MessageRole> role;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<InferenceSource> source;
  final Value<Map<String, dynamic>> metadata;
  final Value<bool> isStreaming;
  final Value<String?> error;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.source = const Value.absent(),
    this.metadata = const Value.absent(),
    this.isStreaming = const Value.absent(),
    this.error = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String userId,
    required String sessionId,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
    required InferenceSource source,
    required Map<String, dynamic> metadata,
    this.isStreaming = const Value.absent(),
    this.error = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        sessionId = Value(sessionId),
        role = Value(role),
        content = Value(content),
        timestamp = Value(timestamp),
        source = Value(source),
        metadata = Value(metadata);
  static Insertable<ChatMessageData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sessionId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<String>? source,
    Expression<String>? metadata,
    Expression<bool>? isStreaming,
    Expression<String>? error,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (source != null) 'source': source,
      if (metadata != null) 'metadata': metadata,
      if (isStreaming != null) 'is_streaming': isStreaming,
      if (error != null) 'error': error,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? sessionId,
      Value<MessageRole>? role,
      Value<String>? content,
      Value<DateTime>? timestamp,
      Value<InferenceSource>? source,
      Value<Map<String, dynamic>>? metadata,
      Value<bool>? isStreaming,
      Value<String?>? error,
      Value<int>? rowid}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
      isStreaming: isStreaming ?? this.isStreaming,
      error: error ?? this.error,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (role.present) {
      map['role'] =
          Variable<String>($ChatMessagesTable.$converterrole.toSql(role.value));
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
          $ChatMessagesTable.$convertersource.toSql(source.value));
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $ChatMessagesTable.$convertermetadata.toSql(metadata.value));
    }
    if (isStreaming.present) {
      map['is_streaming'] = Variable<bool>(isStreaming.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('metadata: $metadata, ')
          ..write('isStreaming: $isStreaming, ')
          ..write('error: $error, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatCitationsTable extends ChatCitations
    with TableInfo<$ChatCitationsTable, ChatCitationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatCitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _snippetMeta =
      const VerificationMeta('snippet');
  @override
  late final GeneratedColumn<String> snippet = GeneratedColumn<String>(
      'snippet', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
      'score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $ChatCitationsTable.$convertermetadata);
  @override
  List<GeneratedColumn> get $columns =>
      [id, messageId, itemId, title, snippet, score, metadata];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_citations';
  @override
  VerificationContext validateIntegrity(Insertable<ChatCitationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('snippet')) {
      context.handle(_snippetMeta,
          snippet.isAcceptableOrUnknown(data['snippet']!, _snippetMeta));
    } else if (isInserting) {
      context.missing(_snippetMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatCitationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatCitationData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      snippet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}score']),
      metadata: $ChatCitationsTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
    );
  }

  @override
  $ChatCitationsTable createAlias(String alias) {
    return $ChatCitationsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
}

class ChatCitationData extends DataClass
    implements Insertable<ChatCitationData> {
  final String id;
  final String messageId;
  final String itemId;
  final String title;
  final String snippet;
  final double? score;
  final Map<String, dynamic> metadata;
  const ChatCitationData(
      {required this.id,
      required this.messageId,
      required this.itemId,
      required this.title,
      required this.snippet,
      this.score,
      required this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['item_id'] = Variable<String>(itemId);
    map['title'] = Variable<String>(title);
    map['snippet'] = Variable<String>(snippet);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    {
      map['metadata'] = Variable<String>(
          $ChatCitationsTable.$convertermetadata.toSql(metadata));
    }
    return map;
  }

  ChatCitationsCompanion toCompanion(bool nullToAbsent) {
    return ChatCitationsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      itemId: Value(itemId),
      title: Value(title),
      snippet: Value(snippet),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      metadata: Value(metadata),
    );
  }

  factory ChatCitationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatCitationData(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      title: serializer.fromJson<String>(json['title']),
      snippet: serializer.fromJson<String>(json['snippet']),
      score: serializer.fromJson<double?>(json['score']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'itemId': serializer.toJson<String>(itemId),
      'title': serializer.toJson<String>(title),
      'snippet': serializer.toJson<String>(snippet),
      'score': serializer.toJson<double?>(score),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
    };
  }

  ChatCitationData copyWith(
          {String? id,
          String? messageId,
          String? itemId,
          String? title,
          String? snippet,
          Value<double?> score = const Value.absent(),
          Map<String, dynamic>? metadata}) =>
      ChatCitationData(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        itemId: itemId ?? this.itemId,
        title: title ?? this.title,
        snippet: snippet ?? this.snippet,
        score: score.present ? score.value : this.score,
        metadata: metadata ?? this.metadata,
      );
  ChatCitationData copyWithCompanion(ChatCitationsCompanion data) {
    return ChatCitationData(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      title: data.title.present ? data.title.value : this.title,
      snippet: data.snippet.present ? data.snippet.value : this.snippet,
      score: data.score.present ? data.score.value : this.score,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatCitationData(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('itemId: $itemId, ')
          ..write('title: $title, ')
          ..write('snippet: $snippet, ')
          ..write('score: $score, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageId, itemId, title, snippet, score, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatCitationData &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.itemId == this.itemId &&
          other.title == this.title &&
          other.snippet == this.snippet &&
          other.score == this.score &&
          other.metadata == this.metadata);
}

class ChatCitationsCompanion extends UpdateCompanion<ChatCitationData> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> itemId;
  final Value<String> title;
  final Value<String> snippet;
  final Value<double?> score;
  final Value<Map<String, dynamic>> metadata;
  final Value<int> rowid;
  const ChatCitationsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.title = const Value.absent(),
    this.snippet = const Value.absent(),
    this.score = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatCitationsCompanion.insert({
    required String id,
    required String messageId,
    required String itemId,
    required String title,
    required String snippet,
    this.score = const Value.absent(),
    required Map<String, dynamic> metadata,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        messageId = Value(messageId),
        itemId = Value(itemId),
        title = Value(title),
        snippet = Value(snippet),
        metadata = Value(metadata);
  static Insertable<ChatCitationData> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? itemId,
    Expression<String>? title,
    Expression<String>? snippet,
    Expression<double>? score,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (itemId != null) 'item_id': itemId,
      if (title != null) 'title': title,
      if (snippet != null) 'snippet': snippet,
      if (score != null) 'score': score,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatCitationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? messageId,
      Value<String>? itemId,
      Value<String>? title,
      Value<String>? snippet,
      Value<double?>? score,
      Value<Map<String, dynamic>>? metadata,
      Value<int>? rowid}) {
    return ChatCitationsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      score: score ?? this.score,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (snippet.present) {
      map['snippet'] = Variable<String>(snippet.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $ChatCitationsTable.$convertermetadata.toSql(metadata.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatCitationsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('itemId: $itemId, ')
          ..write('title: $title, ')
          ..write('snippet: $snippet, ')
          ..write('score: $score, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TaskStatus>($TasksTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<TaskPriority, String> priority =
      GeneratedColumn<String>('priority', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TaskPriority>($TasksTable.$converterpriority);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _collectionIdMeta =
      const VerificationMeta('collectionId');
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
      'collection_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($TasksTable.$convertertags);
  @override
  late final GeneratedColumnWithTypeConverter<List<TaskReminder>, String>
      reminders = GeneratedColumn<String>('reminders', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<TaskReminder>>($TasksTable.$converterreminders);
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estimatedDurationMeta =
      const VerificationMeta('estimatedDuration');
  @override
  late final GeneratedColumn<int> estimatedDuration = GeneratedColumn<int>(
      'estimated_duration', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _actualDurationMeta =
      const VerificationMeta('actualDuration');
  @override
  late final GeneratedColumn<int> actualDuration = GeneratedColumn<int>(
      'actual_duration', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      relatedItemIds = GeneratedColumn<String>(
              'related_item_ids', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($TasksTable.$converterrelatedItemIds);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($TasksTable.$convertermetadata);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        description,
        status,
        priority,
        dueDate,
        startDate,
        completedAt,
        collectionId,
        tags,
        reminders,
        recurrenceRule,
        estimatedDuration,
        actualDuration,
        relatedItemIds,
        metadata,
        createdAt,
        updatedAt,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TaskData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
          _collectionIdMeta,
          collectionId.isAcceptableOrUnknown(
              data['collection_id']!, _collectionIdMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('estimated_duration')) {
      context.handle(
          _estimatedDurationMeta,
          estimatedDuration.isAcceptableOrUnknown(
              data['estimated_duration']!, _estimatedDurationMeta));
    }
    if (data.containsKey('actual_duration')) {
      context.handle(
          _actualDurationMeta,
          actualDuration.isAcceptableOrUnknown(
              data['actual_duration']!, _actualDurationMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      status: $TasksTable.$converterstatus.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      priority: $TasksTable.$converterpriority.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      collectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collection_id']),
      tags: $TasksTable.$convertertags.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
      reminders: $TasksTable.$converterreminders.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminders'])!),
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      estimatedDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estimated_duration']),
      actualDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actual_duration']),
      relatedItemIds: $TasksTable.$converterrelatedItemIds.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}related_item_ids'])!),
      metadata: $TasksTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static TypeConverter<TaskStatus, String> $converterstatus =
      const TaskStatusConverter();
  static TypeConverter<TaskPriority, String> $converterpriority =
      const TaskPriorityConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
  static TypeConverter<List<TaskReminder>, String> $converterreminders =
      const TaskReminderListConverter();
  static TypeConverter<List<String>, String> $converterrelatedItemIds =
      const StringListConverter();
  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
}

class TaskData extends DataClass implements Insertable<TaskData> {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime? startDate;
  final DateTime? completedAt;
  final String? collectionId;
  final List<String> tags;
  final List<TaskReminder> reminders;
  final String? recurrenceRule;
  final int? estimatedDuration;
  final int? actualDuration;
  final List<String> relatedItemIds;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  const TaskData(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      required this.status,
      required this.priority,
      this.dueDate,
      this.startDate,
      this.completedAt,
      this.collectionId,
      required this.tags,
      required this.reminders,
      this.recurrenceRule,
      this.estimatedDuration,
      this.actualDuration,
      required this.relatedItemIds,
      required this.metadata,
      required this.createdAt,
      required this.updatedAt,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['status'] =
          Variable<String>($TasksTable.$converterstatus.toSql(status));
    }
    {
      map['priority'] =
          Variable<String>($TasksTable.$converterpriority.toSql(priority));
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || collectionId != null) {
      map['collection_id'] = Variable<String>(collectionId);
    }
    {
      map['tags'] = Variable<String>($TasksTable.$convertertags.toSql(tags));
    }
    {
      map['reminders'] =
          Variable<String>($TasksTable.$converterreminders.toSql(reminders));
    }
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || estimatedDuration != null) {
      map['estimated_duration'] = Variable<int>(estimatedDuration);
    }
    if (!nullToAbsent || actualDuration != null) {
      map['actual_duration'] = Variable<int>(actualDuration);
    }
    {
      map['related_item_ids'] = Variable<String>(
          $TasksTable.$converterrelatedItemIds.toSql(relatedItemIds));
    }
    {
      map['metadata'] =
          Variable<String>($TasksTable.$convertermetadata.toSql(metadata));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      priority: Value(priority),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      collectionId: collectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(collectionId),
      tags: Value(tags),
      reminders: Value(reminders),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      estimatedDuration: estimatedDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedDuration),
      actualDuration: actualDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDuration),
      relatedItemIds: Value(relatedItemIds),
      metadata: Value(metadata),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory TaskData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<TaskStatus>(json['status']),
      priority: serializer.fromJson<TaskPriority>(json['priority']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      collectionId: serializer.fromJson<String?>(json['collectionId']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      reminders: serializer.fromJson<List<TaskReminder>>(json['reminders']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      estimatedDuration: serializer.fromJson<int?>(json['estimatedDuration']),
      actualDuration: serializer.fromJson<int?>(json['actualDuration']),
      relatedItemIds: serializer.fromJson<List<String>>(json['relatedItemIds']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<TaskStatus>(status),
      'priority': serializer.toJson<TaskPriority>(priority),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'collectionId': serializer.toJson<String?>(collectionId),
      'tags': serializer.toJson<List<String>>(tags),
      'reminders': serializer.toJson<List<TaskReminder>>(reminders),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'estimatedDuration': serializer.toJson<int?>(estimatedDuration),
      'actualDuration': serializer.toJson<int?>(actualDuration),
      'relatedItemIds': serializer.toJson<List<String>>(relatedItemIds),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  TaskData copyWith(
          {String? id,
          String? userId,
          String? title,
          Value<String?> description = const Value.absent(),
          TaskStatus? status,
          TaskPriority? priority,
          Value<DateTime?> dueDate = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> collectionId = const Value.absent(),
          List<String>? tags,
          List<TaskReminder>? reminders,
          Value<String?> recurrenceRule = const Value.absent(),
          Value<int?> estimatedDuration = const Value.absent(),
          Value<int?> actualDuration = const Value.absent(),
          List<String>? relatedItemIds,
          Map<String, dynamic>? metadata,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? version}) =>
      TaskData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        startDate: startDate.present ? startDate.value : this.startDate,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        collectionId:
            collectionId.present ? collectionId.value : this.collectionId,
        tags: tags ?? this.tags,
        reminders: reminders ?? this.reminders,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        estimatedDuration: estimatedDuration.present
            ? estimatedDuration.value
            : this.estimatedDuration,
        actualDuration:
            actualDuration.present ? actualDuration.value : this.actualDuration,
        relatedItemIds: relatedItemIds ?? this.relatedItemIds,
        metadata: metadata ?? this.metadata,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        version: version ?? this.version,
      );
  TaskData copyWithCompanion(TasksCompanion data) {
    return TaskData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      tags: data.tags.present ? data.tags.value : this.tags,
      reminders: data.reminders.present ? data.reminders.value : this.reminders,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      estimatedDuration: data.estimatedDuration.present
          ? data.estimatedDuration.value
          : this.estimatedDuration,
      actualDuration: data.actualDuration.present
          ? data.actualDuration.value
          : this.actualDuration,
      relatedItemIds: data.relatedItemIds.present
          ? data.relatedItemIds.value
          : this.relatedItemIds,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('startDate: $startDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('collectionId: $collectionId, ')
          ..write('tags: $tags, ')
          ..write('reminders: $reminders, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('estimatedDuration: $estimatedDuration, ')
          ..write('actualDuration: $actualDuration, ')
          ..write('relatedItemIds: $relatedItemIds, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      title,
      description,
      status,
      priority,
      dueDate,
      startDate,
      completedAt,
      collectionId,
      tags,
      reminders,
      recurrenceRule,
      estimatedDuration,
      actualDuration,
      relatedItemIds,
      metadata,
      createdAt,
      updatedAt,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.startDate == this.startDate &&
          other.completedAt == this.completedAt &&
          other.collectionId == this.collectionId &&
          other.tags == this.tags &&
          other.reminders == this.reminders &&
          other.recurrenceRule == this.recurrenceRule &&
          other.estimatedDuration == this.estimatedDuration &&
          other.actualDuration == this.actualDuration &&
          other.relatedItemIds == this.relatedItemIds &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class TasksCompanion extends UpdateCompanion<TaskData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<TaskStatus> status;
  final Value<TaskPriority> priority;
  final Value<DateTime?> dueDate;
  final Value<DateTime?> startDate;
  final Value<DateTime?> completedAt;
  final Value<String?> collectionId;
  final Value<List<String>> tags;
  final Value<List<TaskReminder>> reminders;
  final Value<String?> recurrenceRule;
  final Value<int?> estimatedDuration;
  final Value<int?> actualDuration;
  final Value<List<String>> relatedItemIds;
  final Value<Map<String, dynamic>> metadata;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.tags = const Value.absent(),
    this.reminders = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.estimatedDuration = const Value.absent(),
    this.actualDuration = const Value.absent(),
    this.relatedItemIds = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String userId,
    required String title,
    this.description = const Value.absent(),
    required TaskStatus status,
    required TaskPriority priority,
    this.dueDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.collectionId = const Value.absent(),
    required List<String> tags,
    required List<TaskReminder> reminders,
    this.recurrenceRule = const Value.absent(),
    this.estimatedDuration = const Value.absent(),
    this.actualDuration = const Value.absent(),
    required List<String> relatedItemIds,
    required Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        title = Value(title),
        status = Value(status),
        priority = Value(priority),
        tags = Value(tags),
        reminders = Value(reminders),
        relatedItemIds = Value(relatedItemIds),
        metadata = Value(metadata),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TaskData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? startDate,
    Expression<DateTime>? completedAt,
    Expression<String>? collectionId,
    Expression<String>? tags,
    Expression<String>? reminders,
    Expression<String>? recurrenceRule,
    Expression<int>? estimatedDuration,
    Expression<int>? actualDuration,
    Expression<String>? relatedItemIds,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (startDate != null) 'start_date': startDate,
      if (completedAt != null) 'completed_at': completedAt,
      if (collectionId != null) 'collection_id': collectionId,
      if (tags != null) 'tags': tags,
      if (reminders != null) 'reminders': reminders,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (estimatedDuration != null) 'estimated_duration': estimatedDuration,
      if (actualDuration != null) 'actual_duration': actualDuration,
      if (relatedItemIds != null) 'related_item_ids': relatedItemIds,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<String?>? description,
      Value<TaskStatus>? status,
      Value<TaskPriority>? priority,
      Value<DateTime?>? dueDate,
      Value<DateTime?>? startDate,
      Value<DateTime?>? completedAt,
      Value<String?>? collectionId,
      Value<List<String>>? tags,
      Value<List<TaskReminder>>? reminders,
      Value<String?>? recurrenceRule,
      Value<int?>? estimatedDuration,
      Value<int?>? actualDuration,
      Value<List<String>>? relatedItemIds,
      Value<Map<String, dynamic>>? metadata,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? version,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      completedAt: completedAt ?? this.completedAt,
      collectionId: collectionId ?? this.collectionId,
      tags: tags ?? this.tags,
      reminders: reminders ?? this.reminders,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      relatedItemIds: relatedItemIds ?? this.relatedItemIds,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] =
          Variable<String>($TasksTable.$converterstatus.toSql(status.value));
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
          $TasksTable.$converterpriority.toSql(priority.value));
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($TasksTable.$convertertags.toSql(tags.value));
    }
    if (reminders.present) {
      map['reminders'] = Variable<String>(
          $TasksTable.$converterreminders.toSql(reminders.value));
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (estimatedDuration.present) {
      map['estimated_duration'] = Variable<int>(estimatedDuration.value);
    }
    if (actualDuration.present) {
      map['actual_duration'] = Variable<int>(actualDuration.value);
    }
    if (relatedItemIds.present) {
      map['related_item_ids'] = Variable<String>(
          $TasksTable.$converterrelatedItemIds.toSql(relatedItemIds.value));
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $TasksTable.$convertermetadata.toSql(metadata.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('startDate: $startDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('collectionId: $collectionId, ')
          ..write('tags: $tags, ')
          ..write('reminders: $reminders, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('estimatedDuration: $estimatedDuration, ')
          ..write('actualDuration: $actualDuration, ')
          ..write('relatedItemIds: $relatedItemIds, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskRemindersTable extends TaskReminders
    with TableInfo<$TaskRemindersTable, TaskReminderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reminderIdMeta =
      const VerificationMeta('reminderId');
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
      'reminder_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSentMeta = const VerificationMeta('isSent');
  @override
  late final GeneratedColumn<bool> isSent = GeneratedColumn<bool>(
      'is_sent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_sent" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, reminderId, scheduledAt, isSent, sentAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_reminders';
  @override
  VerificationContext validateIntegrity(Insertable<TaskReminderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
          _reminderIdMeta,
          reminderId.isAcceptableOrUnknown(
              data['reminder_id']!, _reminderIdMeta));
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('is_sent')) {
      context.handle(_isSentMeta,
          isSent.isAcceptableOrUnknown(data['is_sent']!, _isSentMeta));
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskReminderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskReminderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      reminderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_id'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      isSent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_sent'])!,
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at']),
    );
  }

  @override
  $TaskRemindersTable createAlias(String alias) {
    return $TaskRemindersTable(attachedDatabase, alias);
  }
}

class TaskReminderData extends DataClass
    implements Insertable<TaskReminderData> {
  final String id;
  final String taskId;
  final String reminderId;
  final DateTime scheduledAt;
  final bool isSent;
  final DateTime? sentAt;
  const TaskReminderData(
      {required this.id,
      required this.taskId,
      required this.reminderId,
      required this.scheduledAt,
      required this.isSent,
      this.sentAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['reminder_id'] = Variable<String>(reminderId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['is_sent'] = Variable<bool>(isSent);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    return map;
  }

  TaskRemindersCompanion toCompanion(bool nullToAbsent) {
    return TaskRemindersCompanion(
      id: Value(id),
      taskId: Value(taskId),
      reminderId: Value(reminderId),
      scheduledAt: Value(scheduledAt),
      isSent: Value(isSent),
      sentAt:
          sentAt == null && nullToAbsent ? const Value.absent() : Value(sentAt),
    );
  }

  factory TaskReminderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskReminderData(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      reminderId: serializer.fromJson<String>(json['reminderId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      isSent: serializer.fromJson<bool>(json['isSent']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'reminderId': serializer.toJson<String>(reminderId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'isSent': serializer.toJson<bool>(isSent),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
    };
  }

  TaskReminderData copyWith(
          {String? id,
          String? taskId,
          String? reminderId,
          DateTime? scheduledAt,
          bool? isSent,
          Value<DateTime?> sentAt = const Value.absent()}) =>
      TaskReminderData(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        reminderId: reminderId ?? this.reminderId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        isSent: isSent ?? this.isSent,
        sentAt: sentAt.present ? sentAt.value : this.sentAt,
      );
  TaskReminderData copyWithCompanion(TaskRemindersCompanion data) {
    return TaskReminderData(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      reminderId:
          data.reminderId.present ? data.reminderId.value : this.reminderId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      isSent: data.isSent.present ? data.isSent.value : this.isSent,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskReminderData(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('isSent: $isSent, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, reminderId, scheduledAt, isSent, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskReminderData &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.reminderId == this.reminderId &&
          other.scheduledAt == this.scheduledAt &&
          other.isSent == this.isSent &&
          other.sentAt == this.sentAt);
}

class TaskRemindersCompanion extends UpdateCompanion<TaskReminderData> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> reminderId;
  final Value<DateTime> scheduledAt;
  final Value<bool> isSent;
  final Value<DateTime?> sentAt;
  final Value<int> rowid;
  const TaskRemindersCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.isSent = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRemindersCompanion.insert({
    required String id,
    required String taskId,
    required String reminderId,
    required DateTime scheduledAt,
    this.isSent = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        reminderId = Value(reminderId),
        scheduledAt = Value(scheduledAt);
  static Insertable<TaskReminderData> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? reminderId,
    Expression<DateTime>? scheduledAt,
    Expression<bool>? isSent,
    Expression<DateTime>? sentAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (reminderId != null) 'reminder_id': reminderId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (isSent != null) 'is_sent': isSent,
      if (sentAt != null) 'sent_at': sentAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? reminderId,
      Value<DateTime>? scheduledAt,
      Value<bool>? isSent,
      Value<DateTime?>? sentAt,
      Value<int>? rowid}) {
    return TaskRemindersCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      reminderId: reminderId ?? this.reminderId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isSent: isSent ?? this.isSent,
      sentAt: sentAt ?? this.sentAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (isSent.present) {
      map['is_sent'] = Variable<bool>(isSent.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRemindersCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('isSent: $isSent, ')
          ..write('sentAt: $sentAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SyncOperation, String> operation =
      GeneratedColumn<String>('operation', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SyncOperation>($SyncQueueTable.$converteroperation);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      payload = GeneratedColumn<String>('payload', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $SyncQueueTable.$converterpayload);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operation,
        payload,
        retryCount,
        createdAt,
        lastAttemptAt,
        error
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: $SyncQueueTable.$converteroperation.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!),
      payload: $SyncQueueTable.$converterpayload.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!),
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static TypeConverter<SyncOperation, String> $converteroperation =
      const SyncOperationConverter();
  static TypeConverter<Map<String, dynamic>, String> $converterpayload =
      const JsonMapConverter();
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String entityType;
  final String entityId;
  final SyncOperation operation;
  final Map<String, dynamic> payload;
  final int retryCount;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final String? error;
  const SyncQueueData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payload,
      required this.retryCount,
      required this.createdAt,
      this.lastAttemptAt,
      this.error});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    {
      map['operation'] = Variable<String>(
          $SyncQueueTable.$converteroperation.toSql(operation));
    }
    {
      map['payload'] =
          Variable<String>($SyncQueueTable.$converterpayload.toSql(payload));
    }
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<SyncOperation>(json['operation']),
      payload: serializer.fromJson<Map<String, dynamic>>(json['payload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      error: serializer.fromJson<String?>(json['error']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<SyncOperation>(operation),
      'payload': serializer.toJson<Map<String, dynamic>>(payload),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'error': serializer.toJson<String?>(error),
    };
  }

  SyncQueueData copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          SyncOperation? operation,
          Map<String, dynamic>? payload,
          int? retryCount,
          DateTime? createdAt,
          Value<DateTime?> lastAttemptAt = const Value.absent(),
          Value<String?> error = const Value.absent()}) =>
      SyncQueueData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt ?? this.createdAt,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
        error: error.present ? error.value : this.error,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      error: data.error.present ? data.error.value : this.error,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, operation, payload,
      retryCount, createdAt, lastAttemptAt, error);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.error == this.error);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<SyncOperation> operation;
  final Value<Map<String, dynamic>> payload;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<String?> error;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.error = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required Map<String, dynamic> payload,
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
    this.lastAttemptAt = const Value.absent(),
    this.error = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? error,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (error != null) 'error': error,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<SyncOperation>? operation,
      Value<Map<String, dynamic>>? payload,
      Value<int>? retryCount,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastAttemptAt,
      Value<String?>? error,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      error: error ?? this.error,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(
          $SyncQueueTable.$converteroperation.toSql(operation.value));
    }
    if (payload.present) {
      map['payload'] = Variable<String>(
          $SyncQueueTable.$converterpayload.toSql(payload.value));
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('error: $error, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<dynamic, String> value =
      GeneratedColumn<String>('value', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<dynamic>($AppSettingsTable.$convertervalue);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: $AppSettingsTable.$convertervalue.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }

  static TypeConverter<dynamic, String> $convertervalue =
      const JsonValueConverter();
}

class AppSettingData extends DataClass implements Insertable<AppSettingData> {
  final String key;
  final dynamic value;
  final DateTime updatedAt;
  const AppSettingData(
      {required this.key, this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] =
          Variable<String>($AppSettingsTable.$convertervalue.toSql(value));
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<dynamic>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<dynamic>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingData copyWith(
          {String? key,
          Value<dynamic> value = const Value.absent(),
          DateTime? updatedAt}) =>
      AppSettingData(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingData copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingData> {
  final Value<String> key;
  final Value<dynamic> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required dynamic value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<AppSettingData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key,
      Value<dynamic>? value,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(
          $AppSettingsTable.$convertervalue.toSql(value.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $DigestsTable digests = $DigestsTable(this);
  late final $DigestSectionsTable digestSections = $DigestSectionsTable(this);
  late final $ChatSessionsTable chatSessions = $ChatSessionsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $ChatCitationsTable chatCitations = $ChatCitationsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskRemindersTable taskReminders = $TaskRemindersTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        collections,
        items,
        digests,
        digestSections,
        chatSessions,
        chatMessages,
        chatCitations,
        tasks,
        taskReminders,
        syncQueue,
        appSettings
      ];
}

typedef $$CollectionsTableCreateCompanionBuilder = CollectionsCompanion
    Function({
  required String id,
  required String userId,
  required String name,
  Value<String?> description,
  Value<String?> icon,
  Value<String?> color,
  Value<String?> parentId,
  Value<int> order,
  Value<bool> isSystem,
  Value<bool> isDefault,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> itemCount,
  required Map<String, dynamic> metadata,
  Value<int> rowid,
});
typedef $$CollectionsTableUpdateCompanionBuilder = CollectionsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String?> description,
  Value<String?> icon,
  Value<String?> color,
  Value<String?> parentId,
  Value<int> order,
  Value<bool> isSystem,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> itemCount,
  Value<Map<String, dynamic>> metadata,
  Value<int> rowid,
});

class $$CollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$CollectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CollectionsTable,
    CollectionData,
    $$CollectionsTableFilterComposer,
    $$CollectionsTableOrderingComposer,
    $$CollectionsTableAnnotationComposer,
    $$CollectionsTableCreateCompanionBuilder,
    $$CollectionsTableUpdateCompanionBuilder,
    (
      CollectionData,
      BaseReferences<_$AppDatabase, $CollectionsTable, CollectionData>
    ),
    CollectionData,
    PrefetchHooks Function()> {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> itemCount = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionsCompanion(
            id: id,
            userId: userId,
            name: name,
            description: description,
            icon: icon,
            color: color,
            parentId: parentId,
            order: order,
            isSystem: isSystem,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            itemCount: itemCount,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> itemCount = const Value.absent(),
            required Map<String, dynamic> metadata,
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionsCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            description: description,
            icon: icon,
            color: color,
            parentId: parentId,
            order: order,
            isSystem: isSystem,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            itemCount: itemCount,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CollectionsTable, CollectionData>(table),
                    BaseReferences<_$AppDatabase, $CollectionsTable,
                        CollectionData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CollectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CollectionsTable,
    CollectionData,
    $$CollectionsTableFilterComposer,
    $$CollectionsTableOrderingComposer,
    $$CollectionsTableAnnotationComposer,
    $$CollectionsTableCreateCompanionBuilder,
    $$CollectionsTableUpdateCompanionBuilder,
    (
      CollectionData,
      BaseReferences<_$AppDatabase, $CollectionsTable, CollectionData>
    ),
    CollectionData,
    PrefetchHooks Function()>;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  required String userId,
  required ItemType type,
  required String title,
  Value<String?> description,
  Value<String?> content,
  Value<String?> sourceUrl,
  Value<String?> thumbnailUrl,
  Value<String?> filePath,
  Value<int?> fileSize,
  Value<String?> mimeType,
  required String collectionId,
  required List<String> tags,
  required Map<String, dynamic> metadata,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<List<double>?> embedding,
  Value<String?> summary,
  required List<String> keyPoints,
  Value<bool> isArchived,
  Value<bool> isFavorite,
  Value<int> version,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<ItemType> type,
  Value<String> title,
  Value<String?> description,
  Value<String?> content,
  Value<String?> sourceUrl,
  Value<String?> thumbnailUrl,
  Value<String?> filePath,
  Value<int?> fileSize,
  Value<String?> mimeType,
  Value<String> collectionId,
  Value<List<String>> tags,
  Value<Map<String, dynamic>> metadata,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<List<double>?> embedding,
  Value<String?> summary,
  Value<List<String>> keyPoints,
  Value<bool> isArchived,
  Value<bool> isFavorite,
  Value<int> version,
  Value<int> rowid,
});

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ItemType, ItemType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collectionId => $composableBuilder(
      column: $table.collectionId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<double>?, List<double>, String>
      get embedding => $composableBuilder(
          column: $table.embedding,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get keyPoints => $composableBuilder(
          column: $table.keyPoints,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get embedding => $composableBuilder(
      column: $table.embedding, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyPoints => $composableBuilder(
      column: $table.keyPoints, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get collectionId => $composableBuilder(
      column: $table.collectionId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<double>?, String> get embedding =>
      $composableBuilder(column: $table.embedding, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get keyPoints =>
      $composableBuilder(column: $table.keyPoints, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    ItemData,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (ItemData, BaseReferences<_$AppDatabase, $ItemsTable, ItemData>),
    ItemData,
    PrefetchHooks Function()> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<ItemType> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<int?> fileSize = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<String> collectionId = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<List<double>?> embedding = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<List<String>> keyPoints = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            userId: userId,
            type: type,
            title: title,
            description: description,
            content: content,
            sourceUrl: sourceUrl,
            thumbnailUrl: thumbnailUrl,
            filePath: filePath,
            fileSize: fileSize,
            mimeType: mimeType,
            collectionId: collectionId,
            tags: tags,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt,
            embedding: embedding,
            summary: summary,
            keyPoints: keyPoints,
            isArchived: isArchived,
            isFavorite: isFavorite,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required ItemType type,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<int?> fileSize = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            required String collectionId,
            required List<String> tags,
            required Map<String, dynamic> metadata,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<List<double>?> embedding = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            required List<String> keyPoints,
            Value<bool> isArchived = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            userId: userId,
            type: type,
            title: title,
            description: description,
            content: content,
            sourceUrl: sourceUrl,
            thumbnailUrl: thumbnailUrl,
            filePath: filePath,
            fileSize: fileSize,
            mimeType: mimeType,
            collectionId: collectionId,
            tags: tags,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt,
            embedding: embedding,
            summary: summary,
            keyPoints: keyPoints,
            isArchived: isArchived,
            isFavorite: isFavorite,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ItemsTable, ItemData>(table),
                    BaseReferences<_$AppDatabase, $ItemsTable, ItemData>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTable,
    ItemData,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (ItemData, BaseReferences<_$AppDatabase, $ItemsTable, ItemData>),
    ItemData,
    PrefetchHooks Function()>;
typedef $$DigestsTableCreateCompanionBuilder = DigestsCompanion Function({
  required String id,
  required String userId,
  required DigestPeriod period,
  required DateTime date,
  required String title,
  required String summary,
  required DateTime generatedAt,
  required InferenceSource generationSource,
  Value<int> version,
  Value<int> rowid,
});
typedef $$DigestsTableUpdateCompanionBuilder = DigestsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<DigestPeriod> period,
  Value<DateTime> date,
  Value<String> title,
  Value<String> summary,
  Value<DateTime> generatedAt,
  Value<InferenceSource> generationSource,
  Value<int> version,
  Value<int> rowid,
});

class $$DigestsTableFilterComposer
    extends Composer<_$AppDatabase, $DigestsTable> {
  $$DigestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DigestPeriod, DigestPeriod, String>
      get period => $composableBuilder(
          column: $table.period,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<InferenceSource, InferenceSource, String>
      get generationSource => $composableBuilder(
          column: $table.generationSource,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$DigestsTableOrderingComposer
    extends Composer<_$AppDatabase, $DigestsTable> {
  $$DigestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get generationSource => $composableBuilder(
      column: $table.generationSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$DigestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigestsTable> {
  $$DigestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DigestPeriod, String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InferenceSource, String>
      get generationSource => $composableBuilder(
          column: $table.generationSource, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$DigestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DigestsTable,
    DigestData,
    $$DigestsTableFilterComposer,
    $$DigestsTableOrderingComposer,
    $$DigestsTableAnnotationComposer,
    $$DigestsTableCreateCompanionBuilder,
    $$DigestsTableUpdateCompanionBuilder,
    (DigestData, BaseReferences<_$AppDatabase, $DigestsTable, DigestData>),
    DigestData,
    PrefetchHooks Function()> {
  $$DigestsTableTableManager(_$AppDatabase db, $DigestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DigestPeriod> period = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<InferenceSource> generationSource = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DigestsCompanion(
            id: id,
            userId: userId,
            period: period,
            date: date,
            title: title,
            summary: summary,
            generatedAt: generatedAt,
            generationSource: generationSource,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required DigestPeriod period,
            required DateTime date,
            required String title,
            required String summary,
            required DateTime generatedAt,
            required InferenceSource generationSource,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DigestsCompanion.insert(
            id: id,
            userId: userId,
            period: period,
            date: date,
            title: title,
            summary: summary,
            generatedAt: generatedAt,
            generationSource: generationSource,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DigestsTable, DigestData>(table),
                    BaseReferences<_$AppDatabase, $DigestsTable, DigestData>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DigestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DigestsTable,
    DigestData,
    $$DigestsTableFilterComposer,
    $$DigestsTableOrderingComposer,
    $$DigestsTableAnnotationComposer,
    $$DigestsTableCreateCompanionBuilder,
    $$DigestsTableUpdateCompanionBuilder,
    (DigestData, BaseReferences<_$AppDatabase, $DigestsTable, DigestData>),
    DigestData,
    PrefetchHooks Function()>;
typedef $$DigestSectionsTableCreateCompanionBuilder = DigestSectionsCompanion
    Function({
  required String id,
  required String digestId,
  required String title,
  required int itemCount,
  required String insight,
  required List<String> items,
  required Map<String, dynamic> metadata,
  Value<int> rowid,
});
typedef $$DigestSectionsTableUpdateCompanionBuilder = DigestSectionsCompanion
    Function({
  Value<String> id,
  Value<String> digestId,
  Value<String> title,
  Value<int> itemCount,
  Value<String> insight,
  Value<List<String>> items,
  Value<Map<String, dynamic>> metadata,
  Value<int> rowid,
});

class $$DigestSectionsTableFilterComposer
    extends Composer<_$AppDatabase, $DigestSectionsTable> {
  $$DigestSectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get digestId => $composableBuilder(
      column: $table.digestId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insight => $composableBuilder(
      column: $table.insight, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get items => $composableBuilder(
          column: $table.items,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$DigestSectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DigestSectionsTable> {
  $$DigestSectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get digestId => $composableBuilder(
      column: $table.digestId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insight => $composableBuilder(
      column: $table.insight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get items => $composableBuilder(
      column: $table.items, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$DigestSectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigestSectionsTable> {
  $$DigestSectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get digestId =>
      $composableBuilder(column: $table.digestId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumn<String> get insight =>
      $composableBuilder(column: $table.insight, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get items =>
      $composableBuilder(column: $table.items, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$DigestSectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DigestSectionsTable,
    DigestSectionData,
    $$DigestSectionsTableFilterComposer,
    $$DigestSectionsTableOrderingComposer,
    $$DigestSectionsTableAnnotationComposer,
    $$DigestSectionsTableCreateCompanionBuilder,
    $$DigestSectionsTableUpdateCompanionBuilder,
    (
      DigestSectionData,
      BaseReferences<_$AppDatabase, $DigestSectionsTable, DigestSectionData>
    ),
    DigestSectionData,
    PrefetchHooks Function()> {
  $$DigestSectionsTableTableManager(
      _$AppDatabase db, $DigestSectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigestSectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigestSectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigestSectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> digestId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> itemCount = const Value.absent(),
            Value<String> insight = const Value.absent(),
            Value<List<String>> items = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DigestSectionsCompanion(
            id: id,
            digestId: digestId,
            title: title,
            itemCount: itemCount,
            insight: insight,
            items: items,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String digestId,
            required String title,
            required int itemCount,
            required String insight,
            required List<String> items,
            required Map<String, dynamic> metadata,
            Value<int> rowid = const Value.absent(),
          }) =>
              DigestSectionsCompanion.insert(
            id: id,
            digestId: digestId,
            title: title,
            itemCount: itemCount,
            insight: insight,
            items: items,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DigestSectionsTable, DigestSectionData>(table),
                    BaseReferences<_$AppDatabase, $DigestSectionsTable,
                        DigestSectionData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DigestSectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DigestSectionsTable,
    DigestSectionData,
    $$DigestSectionsTableFilterComposer,
    $$DigestSectionsTableOrderingComposer,
    $$DigestSectionsTableAnnotationComposer,
    $$DigestSectionsTableCreateCompanionBuilder,
    $$DigestSectionsTableUpdateCompanionBuilder,
    (
      DigestSectionData,
      BaseReferences<_$AppDatabase, $DigestSectionsTable, DigestSectionData>
    ),
    DigestSectionData,
    PrefetchHooks Function()>;
typedef $$ChatSessionsTableCreateCompanionBuilder = ChatSessionsCompanion
    Function({
  required String id,
  required String userId,
  required String title,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> messageCount,
  Value<String?> lastMessagePreview,
  Value<DateTime?> lastMessageAt,
  Value<bool> isPinned,
  required Map<String, dynamic> metadata,
  Value<int> rowid,
});
typedef $$ChatSessionsTableUpdateCompanionBuilder = ChatSessionsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> title,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> messageCount,
  Value<String?> lastMessagePreview,
  Value<DateTime?> lastMessageAt,
  Value<bool> isPinned,
  Value<Map<String, dynamic>> metadata,
  Value<int> rowid,
});

class $$ChatSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get messageCount => $composableBuilder(
      column: $table.messageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMessagePreview => $composableBuilder(
      column: $table.lastMessagePreview,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$ChatSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get messageCount => $composableBuilder(
      column: $table.messageCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMessagePreview => $composableBuilder(
      column: $table.lastMessagePreview,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$ChatSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get messageCount => $composableBuilder(
      column: $table.messageCount, builder: (column) => column);

  GeneratedColumn<String> get lastMessagePreview => $composableBuilder(
      column: $table.lastMessagePreview, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$ChatSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatSessionsTable,
    ChatSessionData,
    $$ChatSessionsTableFilterComposer,
    $$ChatSessionsTableOrderingComposer,
    $$ChatSessionsTableAnnotationComposer,
    $$ChatSessionsTableCreateCompanionBuilder,
    $$ChatSessionsTableUpdateCompanionBuilder,
    (
      ChatSessionData,
      BaseReferences<_$AppDatabase, $ChatSessionsTable, ChatSessionData>
    ),
    ChatSessionData,
    PrefetchHooks Function()> {
  $$ChatSessionsTableTableManager(_$AppDatabase db, $ChatSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> messageCount = const Value.absent(),
            Value<String?> lastMessagePreview = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatSessionsCompanion(
            id: id,
            userId: userId,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            messageCount: messageCount,
            lastMessagePreview: lastMessagePreview,
            lastMessageAt: lastMessageAt,
            isPinned: isPinned,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String title,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> messageCount = const Value.absent(),
            Value<String?> lastMessagePreview = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            required Map<String, dynamic> metadata,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatSessionsCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            messageCount: messageCount,
            lastMessagePreview: lastMessagePreview,
            lastMessageAt: lastMessageAt,
            isPinned: isPinned,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ChatSessionsTable, ChatSessionData>(table),
                    BaseReferences<_$AppDatabase, $ChatSessionsTable,
                        ChatSessionData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatSessionsTable,
    ChatSessionData,
    $$ChatSessionsTableFilterComposer,
    $$ChatSessionsTableOrderingComposer,
    $$ChatSessionsTableAnnotationComposer,
    $$ChatSessionsTableCreateCompanionBuilder,
    $$ChatSessionsTableUpdateCompanionBuilder,
    (
      ChatSessionData,
      BaseReferences<_$AppDatabase, $ChatSessionsTable, ChatSessionData>
    ),
    ChatSessionData,
    PrefetchHooks Function()>;
typedef $$ChatMessagesTableCreateCompanionBuilder = ChatMessagesCompanion
    Function({
  required String id,
  required String userId,
  required String sessionId,
  required MessageRole role,
  required String content,
  required DateTime timestamp,
  required InferenceSource source,
  required Map<String, dynamic> metadata,
  Value<bool> isStreaming,
  Value<String?> error,
  Value<int> rowid,
});
typedef $$ChatMessagesTableUpdateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> sessionId,
  Value<MessageRole> role,
  Value<String> content,
  Value<DateTime> timestamp,
  Value<InferenceSource> source,
  Value<Map<String, dynamic>> metadata,
  Value<bool> isStreaming,
  Value<String?> error,
  Value<int> rowid,
});

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MessageRole, MessageRole, String> get role =>
      $composableBuilder(
          column: $table.role,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<InferenceSource, InferenceSource, String>
      get source => $composableBuilder(
          column: $table.source,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isStreaming => $composableBuilder(
      column: $table.isStreaming, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnFilters(column));
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isStreaming => $composableBuilder(
      column: $table.isStreaming, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnOrderings(column));
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InferenceSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<bool> get isStreaming => $composableBuilder(
      column: $table.isStreaming, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);
}

class $$ChatMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessageData,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessageData,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageData>
    ),
    ChatMessageData,
    PrefetchHooks Function()> {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<MessageRole> role = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<InferenceSource> source = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
            Value<bool> isStreaming = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            userId: userId,
            sessionId: sessionId,
            role: role,
            content: content,
            timestamp: timestamp,
            source: source,
            metadata: metadata,
            isStreaming: isStreaming,
            error: error,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String sessionId,
            required MessageRole role,
            required String content,
            required DateTime timestamp,
            required InferenceSource source,
            required Map<String, dynamic> metadata,
            Value<bool> isStreaming = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            userId: userId,
            sessionId: sessionId,
            role: role,
            content: content,
            timestamp: timestamp,
            source: source,
            metadata: metadata,
            isStreaming: isStreaming,
            error: error,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ChatMessagesTable, ChatMessageData>(table),
                    BaseReferences<_$AppDatabase, $ChatMessagesTable,
                        ChatMessageData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessageData,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessageData,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageData>
    ),
    ChatMessageData,
    PrefetchHooks Function()>;
typedef $$ChatCitationsTableCreateCompanionBuilder = ChatCitationsCompanion
    Function({
  required String id,
  required String messageId,
  required String itemId,
  required String title,
  required String snippet,
  Value<double?> score,
  required Map<String, dynamic> metadata,
  Value<int> rowid,
});
typedef $$ChatCitationsTableUpdateCompanionBuilder = ChatCitationsCompanion
    Function({
  Value<String> id,
  Value<String> messageId,
  Value<String> itemId,
  Value<String> title,
  Value<String> snippet,
  Value<double?> score,
  Value<Map<String, dynamic>> metadata,
  Value<int> rowid,
});

class $$ChatCitationsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatCitationsTable> {
  $$ChatCitationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snippet => $composableBuilder(
      column: $table.snippet, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$ChatCitationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatCitationsTable> {
  $$ChatCitationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snippet => $composableBuilder(
      column: $table.snippet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$ChatCitationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatCitationsTable> {
  $$ChatCitationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get snippet =>
      $composableBuilder(column: $table.snippet, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$ChatCitationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatCitationsTable,
    ChatCitationData,
    $$ChatCitationsTableFilterComposer,
    $$ChatCitationsTableOrderingComposer,
    $$ChatCitationsTableAnnotationComposer,
    $$ChatCitationsTableCreateCompanionBuilder,
    $$ChatCitationsTableUpdateCompanionBuilder,
    (
      ChatCitationData,
      BaseReferences<_$AppDatabase, $ChatCitationsTable, ChatCitationData>
    ),
    ChatCitationData,
    PrefetchHooks Function()> {
  $$ChatCitationsTableTableManager(_$AppDatabase db, $ChatCitationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatCitationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatCitationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatCitationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> snippet = const Value.absent(),
            Value<double?> score = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatCitationsCompanion(
            id: id,
            messageId: messageId,
            itemId: itemId,
            title: title,
            snippet: snippet,
            score: score,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String messageId,
            required String itemId,
            required String title,
            required String snippet,
            Value<double?> score = const Value.absent(),
            required Map<String, dynamic> metadata,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatCitationsCompanion.insert(
            id: id,
            messageId: messageId,
            itemId: itemId,
            title: title,
            snippet: snippet,
            score: score,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ChatCitationsTable, ChatCitationData>(table),
                    BaseReferences<_$AppDatabase, $ChatCitationsTable,
                        ChatCitationData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatCitationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatCitationsTable,
    ChatCitationData,
    $$ChatCitationsTableFilterComposer,
    $$ChatCitationsTableOrderingComposer,
    $$ChatCitationsTableAnnotationComposer,
    $$ChatCitationsTableCreateCompanionBuilder,
    $$ChatCitationsTableUpdateCompanionBuilder,
    (
      ChatCitationData,
      BaseReferences<_$AppDatabase, $ChatCitationsTable, ChatCitationData>
    ),
    ChatCitationData,
    PrefetchHooks Function()>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String userId,
  required String title,
  Value<String?> description,
  required TaskStatus status,
  required TaskPriority priority,
  Value<DateTime?> dueDate,
  Value<DateTime?> startDate,
  Value<DateTime?> completedAt,
  Value<String?> collectionId,
  required List<String> tags,
  required List<TaskReminder> reminders,
  Value<String?> recurrenceRule,
  Value<int?> estimatedDuration,
  Value<int?> actualDuration,
  required List<String> relatedItemIds,
  required Map<String, dynamic> metadata,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> title,
  Value<String?> description,
  Value<TaskStatus> status,
  Value<TaskPriority> priority,
  Value<DateTime?> dueDate,
  Value<DateTime?> startDate,
  Value<DateTime?> completedAt,
  Value<String?> collectionId,
  Value<List<String>> tags,
  Value<List<TaskReminder>> reminders,
  Value<String?> recurrenceRule,
  Value<int?> estimatedDuration,
  Value<int?> actualDuration,
  Value<List<String>> relatedItemIds,
  Value<Map<String, dynamic>> metadata,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<TaskPriority, TaskPriority, String>
      get priority => $composableBuilder(
          column: $table.priority,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collectionId => $composableBuilder(
      column: $table.collectionId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<TaskReminder>, List<TaskReminder>, String>
      get reminders => $composableBuilder(
          column: $table.reminders,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedDuration => $composableBuilder(
      column: $table.estimatedDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualDuration => $composableBuilder(
      column: $table.actualDuration,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get relatedItemIds => $composableBuilder(
          column: $table.relatedItemIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminders => $composableBuilder(
      column: $table.reminders, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedDuration => $composableBuilder(
      column: $table.estimatedDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualDuration => $composableBuilder(
      column: $table.actualDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedItemIds => $composableBuilder(
      column: $table.relatedItemIds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskPriority, String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get collectionId => $composableBuilder(
      column: $table.collectionId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<TaskReminder>, String> get reminders =>
      $composableBuilder(column: $table.reminders, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<int> get estimatedDuration => $composableBuilder(
      column: $table.estimatedDuration, builder: (column) => column);

  GeneratedColumn<int> get actualDuration => $composableBuilder(
      column: $table.actualDuration, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get relatedItemIds =>
      $composableBuilder(
          column: $table.relatedItemIds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskData,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskData, BaseReferences<_$AppDatabase, $TasksTable, TaskData>),
    TaskData,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<TaskStatus> status = const Value.absent(),
            Value<TaskPriority> priority = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> collectionId = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<List<TaskReminder>> reminders = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<int?> estimatedDuration = const Value.absent(),
            Value<int?> actualDuration = const Value.absent(),
            Value<List<String>> relatedItemIds = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            userId: userId,
            title: title,
            description: description,
            status: status,
            priority: priority,
            dueDate: dueDate,
            startDate: startDate,
            completedAt: completedAt,
            collectionId: collectionId,
            tags: tags,
            reminders: reminders,
            recurrenceRule: recurrenceRule,
            estimatedDuration: estimatedDuration,
            actualDuration: actualDuration,
            relatedItemIds: relatedItemIds,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String title,
            Value<String?> description = const Value.absent(),
            required TaskStatus status,
            required TaskPriority priority,
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> collectionId = const Value.absent(),
            required List<String> tags,
            required List<TaskReminder> reminders,
            Value<String?> recurrenceRule = const Value.absent(),
            Value<int?> estimatedDuration = const Value.absent(),
            Value<int?> actualDuration = const Value.absent(),
            required List<String> relatedItemIds,
            required Map<String, dynamic> metadata,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            description: description,
            status: status,
            priority: priority,
            dueDate: dueDate,
            startDate: startDate,
            completedAt: completedAt,
            collectionId: collectionId,
            tags: tags,
            reminders: reminders,
            recurrenceRule: recurrenceRule,
            estimatedDuration: estimatedDuration,
            actualDuration: actualDuration,
            relatedItemIds: relatedItemIds,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TasksTable, TaskData>(table),
                    BaseReferences<_$AppDatabase, $TasksTable, TaskData>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskData,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskData, BaseReferences<_$AppDatabase, $TasksTable, TaskData>),
    TaskData,
    PrefetchHooks Function()>;
typedef $$TaskRemindersTableCreateCompanionBuilder = TaskRemindersCompanion
    Function({
  required String id,
  required String taskId,
  required String reminderId,
  required DateTime scheduledAt,
  Value<bool> isSent,
  Value<DateTime?> sentAt,
  Value<int> rowid,
});
typedef $$TaskRemindersTableUpdateCompanionBuilder = TaskRemindersCompanion
    Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> reminderId,
  Value<DateTime> scheduledAt,
  Value<bool> isSent,
  Value<DateTime?> sentAt,
  Value<int> rowid,
});

class $$TaskRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSent => $composableBuilder(
      column: $table.isSent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnFilters(column));
}

class $$TaskRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSent => $composableBuilder(
      column: $table.isSent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnOrderings(column));
}

class $$TaskRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<bool> get isSent =>
      $composableBuilder(column: $table.isSent, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);
}

class $$TaskRemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskRemindersTable,
    TaskReminderData,
    $$TaskRemindersTableFilterComposer,
    $$TaskRemindersTableOrderingComposer,
    $$TaskRemindersTableAnnotationComposer,
    $$TaskRemindersTableCreateCompanionBuilder,
    $$TaskRemindersTableUpdateCompanionBuilder,
    (
      TaskReminderData,
      BaseReferences<_$AppDatabase, $TaskRemindersTable, TaskReminderData>
    ),
    TaskReminderData,
    PrefetchHooks Function()> {
  $$TaskRemindersTableTableManager(_$AppDatabase db, $TaskRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> reminderId = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<bool> isSent = const Value.absent(),
            Value<DateTime?> sentAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRemindersCompanion(
            id: id,
            taskId: taskId,
            reminderId: reminderId,
            scheduledAt: scheduledAt,
            isSent: isSent,
            sentAt: sentAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required String reminderId,
            required DateTime scheduledAt,
            Value<bool> isSent = const Value.absent(),
            Value<DateTime?> sentAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRemindersCompanion.insert(
            id: id,
            taskId: taskId,
            reminderId: reminderId,
            scheduledAt: scheduledAt,
            isSent: isSent,
            sentAt: sentAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TaskRemindersTable, TaskReminderData>(table),
                    BaseReferences<_$AppDatabase, $TaskRemindersTable,
                        TaskReminderData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskRemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskRemindersTable,
    TaskReminderData,
    $$TaskRemindersTableFilterComposer,
    $$TaskRemindersTableOrderingComposer,
    $$TaskRemindersTableAnnotationComposer,
    $$TaskRemindersTableCreateCompanionBuilder,
    $$TaskRemindersTableUpdateCompanionBuilder,
    (
      TaskReminderData,
      BaseReferences<_$AppDatabase, $TaskRemindersTable, TaskReminderData>
    ),
    TaskReminderData,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String entityType,
  required String entityId,
  required SyncOperation operation,
  required Map<String, dynamic> payload,
  Value<int> retryCount,
  required DateTime createdAt,
  Value<DateTime?> lastAttemptAt,
  Value<String?> error,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<SyncOperation> operation,
  Value<Map<String, dynamic>> payload,
  Value<int> retryCount,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAttemptAt,
  Value<String?> error,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SyncOperation, SyncOperation, String>
      get operation => $composableBuilder(
          column: $table.operation,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get payload => $composableBuilder(
          column: $table.payload,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncOperation, String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<SyncOperation> operation = const Value.absent(),
            Value<Map<String, dynamic>> payload = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            retryCount: retryCount,
            createdAt: createdAt,
            lastAttemptAt: lastAttemptAt,
            error: error,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            required SyncOperation operation,
            required Map<String, dynamic> payload,
            Value<int> retryCount = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            retryCount: retryCount,
            createdAt: createdAt,
            lastAttemptAt: lastAttemptAt,
            error: error,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SyncQueueTable, SyncQueueData>(table),
                    BaseReferences<_$AppDatabase, $SyncQueueTable,
                        SyncQueueData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required dynamic value,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<dynamic> value,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<dynamic, dynamic, String> get value =>
      $composableBuilder(
          column: $table.value,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dynamic, String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingData,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingData,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingData>
    ),
    AppSettingData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<dynamic> value = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required dynamic value,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AppSettingsTable, AppSettingData>(table),
                    BaseReferences<_$AppDatabase, $AppSettingsTable,
                        AppSettingData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingData,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingData,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingData>
    ),
    AppSettingData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$DigestsTableTableManager get digests =>
      $$DigestsTableTableManager(_db, _db.digests);
  $$DigestSectionsTableTableManager get digestSections =>
      $$DigestSectionsTableTableManager(_db, _db.digestSections);
  $$ChatSessionsTableTableManager get chatSessions =>
      $$ChatSessionsTableTableManager(_db, _db.chatSessions);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$ChatCitationsTableTableManager get chatCitations =>
      $$ChatCitationsTableTableManager(_db, _db.chatCitations);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskRemindersTableTableManager get taskReminders =>
      $$TaskRemindersTableTableManager(_db, _db.taskReminders);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
