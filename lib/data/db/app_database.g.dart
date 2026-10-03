// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NodesTable extends Nodes with TableInfo<$NodesTable, Node> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<NodeType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<NodeType>($NodesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<NodeTemplate?, String> template =
      GeneratedColumn<String>(
        'template',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<NodeTemplate?>($NodesTable.$convertertemplaten);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('folder'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<NodeStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('active'),
      ).withConverter<NodeStatus>($NodesTable.$converterstatus);
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    name,
    type,
    template,
    icon,
    status,
    sortIndex,
    lastOpenedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Node> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Node map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Node(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      type: $NodesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      template: $NodesTable.$convertertemplaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}template'],
        ),
      ),
      icon:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}icon'],
          )!,
      status: $NodesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      sortIndex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_index'],
          )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $NodesTable createAlias(String alias) {
    return $NodesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NodeType, String, String> $convertertype =
      const EnumNameConverter<NodeType>(NodeType.values);
  static JsonTypeConverter2<NodeTemplate, String, String> $convertertemplate =
      const EnumNameConverter<NodeTemplate>(NodeTemplate.values);
  static JsonTypeConverter2<NodeTemplate?, String?, String?>
  $convertertemplaten = JsonTypeConverter2.asNullable($convertertemplate);
  static JsonTypeConverter2<NodeStatus, String, String> $converterstatus =
      const EnumNameConverter<NodeStatus>(NodeStatus.values);
}

class Node extends DataClass implements Insertable<Node> {
  final int id;
  final int? parentId;
  final String name;
  final NodeType type;
  final NodeTemplate? template;
  final String icon;
  final NodeStatus status;
  final int sortIndex;
  final DateTime? lastOpenedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Node({
    required this.id,
    this.parentId,
    required this.name,
    required this.type,
    this.template,
    required this.icon,
    required this.status,
    required this.sortIndex,
    this.lastOpenedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($NodesTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || template != null) {
      map['template'] = Variable<String>(
        $NodesTable.$convertertemplaten.toSql(template),
      );
    }
    map['icon'] = Variable<String>(icon);
    {
      map['status'] = Variable<String>(
        $NodesTable.$converterstatus.toSql(status),
      );
    }
    map['sort_index'] = Variable<int>(sortIndex);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  NodesCompanion toCompanion(bool nullToAbsent) {
    return NodesCompanion(
      id: Value(id),
      parentId:
          parentId == null && nullToAbsent
              ? const Value.absent()
              : Value(parentId),
      name: Value(name),
      type: Value(type),
      template:
          template == null && nullToAbsent
              ? const Value.absent()
              : Value(template),
      icon: Value(icon),
      status: Value(status),
      sortIndex: Value(sortIndex),
      lastOpenedAt:
          lastOpenedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastOpenedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory Node.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Node(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      type: $NodesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      template: $NodesTable.$convertertemplaten.fromJson(
        serializer.fromJson<String?>(json['template']),
      ),
      icon: serializer.fromJson<String>(json['icon']),
      status: $NodesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int?>(parentId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $NodesTable.$convertertype.toJson(type),
      ),
      'template': serializer.toJson<String?>(
        $NodesTable.$convertertemplaten.toJson(template),
      ),
      'icon': serializer.toJson<String>(icon),
      'status': serializer.toJson<String>(
        $NodesTable.$converterstatus.toJson(status),
      ),
      'sortIndex': serializer.toJson<int>(sortIndex),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Node copyWith({
    int? id,
    Value<int?> parentId = const Value.absent(),
    String? name,
    NodeType? type,
    Value<NodeTemplate?> template = const Value.absent(),
    String? icon,
    NodeStatus? status,
    int? sortIndex,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Node(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    type: type ?? this.type,
    template: template.present ? template.value : this.template,
    icon: icon ?? this.icon,
    status: status ?? this.status,
    sortIndex: sortIndex ?? this.sortIndex,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Node copyWithCompanion(NodesCompanion data) {
    return Node(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      template: data.template.present ? data.template.value : this.template,
      icon: data.icon.present ? data.icon.value : this.icon,
      status: data.status.present ? data.status.value : this.status,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      lastOpenedAt:
          data.lastOpenedAt.present
              ? data.lastOpenedAt.value
              : this.lastOpenedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Node(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('template: $template, ')
          ..write('icon: $icon, ')
          ..write('status: $status, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    name,
    type,
    template,
    icon,
    status,
    sortIndex,
    lastOpenedAt,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Node &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.type == this.type &&
          other.template == this.template &&
          other.icon == this.icon &&
          other.status == this.status &&
          other.sortIndex == this.sortIndex &&
          other.lastOpenedAt == this.lastOpenedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class NodesCompanion extends UpdateCompanion<Node> {
  final Value<int> id;
  final Value<int?> parentId;
  final Value<String> name;
  final Value<NodeType> type;
  final Value<NodeTemplate?> template;
  final Value<String> icon;
  final Value<NodeStatus> status;
  final Value<int> sortIndex;
  final Value<DateTime?> lastOpenedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const NodesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.template = const Value.absent(),
    this.icon = const Value.absent(),
    this.status = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  NodesCompanion.insert({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    required String name,
    required NodeType type,
    this.template = const Value.absent(),
    this.icon = const Value.absent(),
    this.status = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<Node> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? template,
    Expression<String>? icon,
    Expression<String>? status,
    Expression<int>? sortIndex,
    Expression<DateTime>? lastOpenedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (template != null) 'template': template,
      if (icon != null) 'icon': icon,
      if (status != null) 'status': status,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  NodesCompanion copyWith({
    Value<int>? id,
    Value<int?>? parentId,
    Value<String>? name,
    Value<NodeType>? type,
    Value<NodeTemplate?>? template,
    Value<String>? icon,
    Value<NodeStatus>? status,
    Value<int>? sortIndex,
    Value<DateTime?>? lastOpenedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return NodesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      type: type ?? this.type,
      template: template ?? this.template,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      sortIndex: sortIndex ?? this.sortIndex,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $NodesTable.$convertertype.toSql(type.value),
      );
    }
    if (template.present) {
      map['template'] = Variable<String>(
        $NodesTable.$convertertemplaten.toSql(template.value),
      );
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $NodesTable.$converterstatus.toSql(status.value),
      );
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('template: $template, ')
          ..write('icon: $icon, ')
          ..write('status: $status, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $LinksTable extends Links with TableInfo<$LinksTable, Link> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LinkCategory>($LinksTable.$convertercategory);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    title,
    url,
    category,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'links';
  @override
  VerificationContext validateIntegrity(
    Insertable<Link> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Link map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Link(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      url:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}url'],
          )!,
      category: $LinksTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LinksTable createAlias(String alias) {
    return $LinksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LinkCategory, String, String> $convertercategory =
      const EnumNameConverter<LinkCategory>(LinkCategory.values);
}

class Link extends DataClass implements Insertable<Link> {
  final int id;
  final int nodeId;
  final String title;
  final String url;
  final LinkCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Link({
    required this.id,
    required this.nodeId,
    required this.title,
    required this.url,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    map['title'] = Variable<String>(title);
    map['url'] = Variable<String>(url);
    {
      map['category'] = Variable<String>(
        $LinksTable.$convertercategory.toSql(category),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LinksCompanion toCompanion(bool nullToAbsent) {
    return LinksCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      title: Value(title),
      url: Value(url),
      category: Value(category),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory Link.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Link(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String>(json['url']),
      category: $LinksTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String>(url),
      'category': serializer.toJson<String>(
        $LinksTable.$convertercategory.toJson(category),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Link copyWith({
    int? id,
    int? nodeId,
    String? title,
    String? url,
    LinkCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Link(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    title: title ?? this.title,
    url: url ?? this.url,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Link copyWithCompanion(LinksCompanion data) {
    return Link(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Link(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nodeId,
    title,
    url,
    category,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Link &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.title == this.title &&
          other.url == this.url &&
          other.category == this.category &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class LinksCompanion extends UpdateCompanion<Link> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<String> title;
  final Value<String> url;
  final Value<LinkCategory> category;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const LinksCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  LinksCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    required String title,
    required String url,
    required LinkCategory category,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : nodeId = Value(nodeId),
       title = Value(title),
       url = Value(url),
       category = Value(category);
  static Insertable<Link> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  LinksCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<String>? title,
    Value<String>? url,
    Value<LinkCategory>? category,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return LinksCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      title: title ?? this.title,
      url: url ?? this.url,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $LinksTable.$convertercategory.toSql(category.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LinksCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    title,
    content,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final int nodeId;
  final String? title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Note({
    required this.id,
    required this.nodeId,
    this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Note copyWith({
    int? id,
    int? nodeId,
    Value<String?> title = const Value.absent(),
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Note(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    title: title.present ? title.value : this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nodeId, title, content, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<String?> title;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : nodeId = Value(nodeId);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<String?>? title,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $EmailsTable extends Emails with TableInfo<$EmailsTable, Email> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    label,
    address,
    password,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emails';
  @override
  VerificationContext validateIntegrity(
    Insertable<Email> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Email map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Email(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      label:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}label'],
          )!,
      address:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}address'],
          )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EmailsTable createAlias(String alias) {
    return $EmailsTable(attachedDatabase, alias);
  }
}

class Email extends DataClass implements Insertable<Email> {
  final int id;
  final int nodeId;
  final String label;
  final String address;
  final String? password;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Email({
    required this.id,
    required this.nodeId,
    required this.label,
    required this.address,
    this.password,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    map['label'] = Variable<String>(label);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EmailsCompanion toCompanion(bool nullToAbsent) {
    return EmailsCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      label: Value(label),
      address: Value(address),
      password:
          password == null && nullToAbsent
              ? const Value.absent()
              : Value(password),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory Email.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Email(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      label: serializer.fromJson<String>(json['label']),
      address: serializer.fromJson<String>(json['address']),
      password: serializer.fromJson<String?>(json['password']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'label': serializer.toJson<String>(label),
      'address': serializer.toJson<String>(address),
      'password': serializer.toJson<String?>(password),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Email copyWith({
    int? id,
    int? nodeId,
    String? label,
    String? address,
    Value<String?> password = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Email(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    label: label ?? this.label,
    address: address ?? this.address,
    password: password.present ? password.value : this.password,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Email copyWithCompanion(EmailsCompanion data) {
    return Email(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      label: data.label.present ? data.label.value : this.label,
      address: data.address.present ? data.address.value : this.address,
      password: data.password.present ? data.password.value : this.password,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Email(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('label: $label, ')
          ..write('address: $address, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nodeId,
    label,
    address,
    password,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Email &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.label == this.label &&
          other.address == this.address &&
          other.password == this.password &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class EmailsCompanion extends UpdateCompanion<Email> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<String> label;
  final Value<String> address;
  final Value<String?> password;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const EmailsCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.label = const Value.absent(),
    this.address = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  EmailsCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    required String label,
    required String address,
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : nodeId = Value(nodeId),
       label = Value(label),
       address = Value(address);
  static Insertable<Email> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<String>? label,
    Expression<String>? address,
    Expression<String>? password,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (label != null) 'label': label,
      if (address != null) 'address': address,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  EmailsCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<String>? label,
    Value<String>? address,
    Value<String?>? password,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return EmailsCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      label: label ?? this.label,
      address: address ?? this.address,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailsCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('label: $label, ')
          ..write('address: $address, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _serviceNameMeta = const VerificationMeta(
    'serviceName',
  );
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
    'service_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BillingCycle, String> cycle =
      GeneratedColumn<String>(
        'cycle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('monthly'),
      ).withConverter<BillingCycle>($SubscriptionsTable.$convertercycle);
  static const VerificationMeta _renewsAtMeta = const VerificationMeta(
    'renewsAt',
  );
  @override
  late final GeneratedColumn<DateTime> renewsAt = GeneratedColumn<DateTime>(
    'renews_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SubStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('active'),
      ).withConverter<SubStatus>($SubscriptionsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    serviceName,
    plan,
    price,
    cycle,
    renewsAt,
    status,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('service_name')) {
      context.handle(
        _serviceNameMeta,
        serviceName.isAcceptableOrUnknown(
          data['service_name']!,
          _serviceNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('renews_at')) {
      context.handle(
        _renewsAtMeta,
        renewsAt.isAcceptableOrUnknown(data['renews_at']!, _renewsAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      serviceName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}service_name'],
          )!,
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price'],
      ),
      cycle: $SubscriptionsTable.$convertercycle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cycle'],
        )!,
      ),
      renewsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}renews_at'],
      ),
      status: $SubscriptionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BillingCycle, String, String> $convertercycle =
      const EnumNameConverter<BillingCycle>(BillingCycle.values);
  static JsonTypeConverter2<SubStatus, String, String> $converterstatus =
      const EnumNameConverter<SubStatus>(SubStatus.values);
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final int id;
  final int nodeId;
  final String serviceName;
  final String? plan;
  final String? price;
  final BillingCycle cycle;
  final DateTime? renewsAt;
  final SubStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Subscription({
    required this.id,
    required this.nodeId,
    required this.serviceName,
    this.plan,
    this.price,
    required this.cycle,
    this.renewsAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    map['service_name'] = Variable<String>(serviceName);
    if (!nullToAbsent || plan != null) {
      map['plan'] = Variable<String>(plan);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<String>(price);
    }
    {
      map['cycle'] = Variable<String>(
        $SubscriptionsTable.$convertercycle.toSql(cycle),
      );
    }
    if (!nullToAbsent || renewsAt != null) {
      map['renews_at'] = Variable<DateTime>(renewsAt);
    }
    {
      map['status'] = Variable<String>(
        $SubscriptionsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      serviceName: Value(serviceName),
      plan: plan == null && nullToAbsent ? const Value.absent() : Value(plan),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      cycle: Value(cycle),
      renewsAt:
          renewsAt == null && nullToAbsent
              ? const Value.absent()
              : Value(renewsAt),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory Subscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      plan: serializer.fromJson<String?>(json['plan']),
      price: serializer.fromJson<String?>(json['price']),
      cycle: $SubscriptionsTable.$convertercycle.fromJson(
        serializer.fromJson<String>(json['cycle']),
      ),
      renewsAt: serializer.fromJson<DateTime?>(json['renewsAt']),
      status: $SubscriptionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'serviceName': serializer.toJson<String>(serviceName),
      'plan': serializer.toJson<String?>(plan),
      'price': serializer.toJson<String?>(price),
      'cycle': serializer.toJson<String>(
        $SubscriptionsTable.$convertercycle.toJson(cycle),
      ),
      'renewsAt': serializer.toJson<DateTime?>(renewsAt),
      'status': serializer.toJson<String>(
        $SubscriptionsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Subscription copyWith({
    int? id,
    int? nodeId,
    String? serviceName,
    Value<String?> plan = const Value.absent(),
    Value<String?> price = const Value.absent(),
    BillingCycle? cycle,
    Value<DateTime?> renewsAt = const Value.absent(),
    SubStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Subscription(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    serviceName: serviceName ?? this.serviceName,
    plan: plan.present ? plan.value : this.plan,
    price: price.present ? price.value : this.price,
    cycle: cycle ?? this.cycle,
    renewsAt: renewsAt.present ? renewsAt.value : this.renewsAt,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      serviceName:
          data.serviceName.present ? data.serviceName.value : this.serviceName,
      plan: data.plan.present ? data.plan.value : this.plan,
      price: data.price.present ? data.price.value : this.price,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      renewsAt: data.renewsAt.present ? data.renewsAt.value : this.renewsAt,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('serviceName: $serviceName, ')
          ..write('plan: $plan, ')
          ..write('price: $price, ')
          ..write('cycle: $cycle, ')
          ..write('renewsAt: $renewsAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nodeId,
    serviceName,
    plan,
    price,
    cycle,
    renewsAt,
    status,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.serviceName == this.serviceName &&
          other.plan == this.plan &&
          other.price == this.price &&
          other.cycle == this.cycle &&
          other.renewsAt == this.renewsAt &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<String> serviceName;
  final Value<String?> plan;
  final Value<String?> price;
  final Value<BillingCycle> cycle;
  final Value<DateTime?> renewsAt;
  final Value<SubStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.plan = const Value.absent(),
    this.price = const Value.absent(),
    this.cycle = const Value.absent(),
    this.renewsAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    required String serviceName,
    this.plan = const Value.absent(),
    this.price = const Value.absent(),
    this.cycle = const Value.absent(),
    this.renewsAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : nodeId = Value(nodeId),
       serviceName = Value(serviceName);
  static Insertable<Subscription> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<String>? serviceName,
    Expression<String>? plan,
    Expression<String>? price,
    Expression<String>? cycle,
    Expression<DateTime>? renewsAt,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (serviceName != null) 'service_name': serviceName,
      if (plan != null) 'plan': plan,
      if (price != null) 'price': price,
      if (cycle != null) 'cycle': cycle,
      if (renewsAt != null) 'renews_at': renewsAt,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  SubscriptionsCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<String>? serviceName,
    Value<String?>? plan,
    Value<String?>? price,
    Value<BillingCycle>? cycle,
    Value<DateTime?>? renewsAt,
    Value<SubStatus>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      serviceName: serviceName ?? this.serviceName,
      plan: plan ?? this.plan,
      price: price ?? this.price,
      cycle: cycle ?? this.cycle,
      renewsAt: renewsAt ?? this.renewsAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<String>(
        $SubscriptionsTable.$convertercycle.toSql(cycle.value),
      );
    }
    if (renewsAt.present) {
      map['renews_at'] = Variable<DateTime>(renewsAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SubscriptionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('serviceName: $serviceName, ')
          ..write('plan: $plan, ')
          ..write('price: $price, ')
          ..write('cycle: $cycle, ')
          ..write('renewsAt: $renewsAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $PlatformsTable extends Platforms
    with TableInfo<$PlatformsTable, PlatformRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlatformsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _platformNameMeta = const VerificationMeta(
    'platformName',
  );
  @override
  late final GeneratedColumn<String> platformName = GeneratedColumn<String>(
    'platform_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  @override
  late final GeneratedColumn<String> account = GeneratedColumn<String>(
    'account',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    platformName,
    account,
    url,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'platforms';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlatformRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('platform_name')) {
      context.handle(
        _platformNameMeta,
        platformName.isAcceptableOrUnknown(
          data['platform_name']!,
          _platformNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_platformNameMeta);
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlatformRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlatformRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      platformName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}platform_name'],
          )!,
      account: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PlatformsTable createAlias(String alias) {
    return $PlatformsTable(attachedDatabase, alias);
  }
}

class PlatformRow extends DataClass implements Insertable<PlatformRow> {
  final int id;
  final int nodeId;
  final String platformName;
  final String? account;
  final String? url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const PlatformRow({
    required this.id,
    required this.nodeId,
    required this.platformName,
    this.account,
    this.url,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    map['platform_name'] = Variable<String>(platformName);
    if (!nullToAbsent || account != null) {
      map['account'] = Variable<String>(account);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PlatformsCompanion toCompanion(bool nullToAbsent) {
    return PlatformsCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      platformName: Value(platformName),
      account:
          account == null && nullToAbsent
              ? const Value.absent()
              : Value(account),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory PlatformRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlatformRow(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      platformName: serializer.fromJson<String>(json['platformName']),
      account: serializer.fromJson<String?>(json['account']),
      url: serializer.fromJson<String?>(json['url']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'platformName': serializer.toJson<String>(platformName),
      'account': serializer.toJson<String?>(account),
      'url': serializer.toJson<String?>(url),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PlatformRow copyWith({
    int? id,
    int? nodeId,
    String? platformName,
    Value<String?> account = const Value.absent(),
    Value<String?> url = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PlatformRow(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    platformName: platformName ?? this.platformName,
    account: account.present ? account.value : this.account,
    url: url.present ? url.value : this.url,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PlatformRow copyWithCompanion(PlatformsCompanion data) {
    return PlatformRow(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      platformName:
          data.platformName.present
              ? data.platformName.value
              : this.platformName,
      account: data.account.present ? data.account.value : this.account,
      url: data.url.present ? data.url.value : this.url,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlatformRow(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('platformName: $platformName, ')
          ..write('account: $account, ')
          ..write('url: $url, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nodeId,
    platformName,
    account,
    url,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlatformRow &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.platformName == this.platformName &&
          other.account == this.account &&
          other.url == this.url &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PlatformsCompanion extends UpdateCompanion<PlatformRow> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<String> platformName;
  final Value<String?> account;
  final Value<String?> url;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const PlatformsCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.platformName = const Value.absent(),
    this.account = const Value.absent(),
    this.url = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  PlatformsCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    required String platformName,
    this.account = const Value.absent(),
    this.url = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : nodeId = Value(nodeId),
       platformName = Value(platformName);
  static Insertable<PlatformRow> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<String>? platformName,
    Expression<String>? account,
    Expression<String>? url,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (platformName != null) 'platform_name': platformName,
      if (account != null) 'account': account,
      if (url != null) 'url': url,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  PlatformsCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<String>? platformName,
    Value<String?>? account,
    Value<String?>? url,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return PlatformsCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      platformName: platformName ?? this.platformName,
      account: account ?? this.account,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (platformName.present) {
      map['platform_name'] = Variable<String>(platformName.value);
    }
    if (account.present) {
      map['account'] = Variable<String>(account.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlatformsCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('platformName: $platformName, ')
          ..write('account: $account, ')
          ..write('url: $url, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $VariablesTable extends Variables
    with TableInfo<$VariablesTable, VariableRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VariablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _varKeyMeta = const VerificationMeta('varKey');
  @override
  late final GeneratedColumn<String> varKey = GeneratedColumn<String>(
    'var_key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _varValueMeta = const VerificationMeta(
    'varValue',
  );
  @override
  late final GeneratedColumn<String> varValue = GeneratedColumn<String>(
    'var_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isSecretMeta = const VerificationMeta(
    'isSecret',
  );
  @override
  late final GeneratedColumn<bool> isSecret = GeneratedColumn<bool>(
    'is_secret',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_secret" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    varKey,
    varValue,
    isSecret,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'variables';
  @override
  VerificationContext validateIntegrity(
    Insertable<VariableRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('var_key')) {
      context.handle(
        _varKeyMeta,
        varKey.isAcceptableOrUnknown(data['var_key']!, _varKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_varKeyMeta);
    }
    if (data.containsKey('var_value')) {
      context.handle(
        _varValueMeta,
        varValue.isAcceptableOrUnknown(data['var_value']!, _varValueMeta),
      );
    }
    if (data.containsKey('is_secret')) {
      context.handle(
        _isSecretMeta,
        isSecret.isAcceptableOrUnknown(data['is_secret']!, _isSecretMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VariableRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VariableRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      varKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}var_key'],
          )!,
      varValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}var_value'],
          )!,
      isSecret:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_secret'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $VariablesTable createAlias(String alias) {
    return $VariablesTable(attachedDatabase, alias);
  }
}

class VariableRow extends DataClass implements Insertable<VariableRow> {
  final int id;
  final int nodeId;
  final String varKey;
  final String varValue;
  final bool isSecret;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const VariableRow({
    required this.id,
    required this.nodeId,
    required this.varKey,
    required this.varValue,
    required this.isSecret,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    map['var_key'] = Variable<String>(varKey);
    map['var_value'] = Variable<String>(varValue);
    map['is_secret'] = Variable<bool>(isSecret);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  VariablesCompanion toCompanion(bool nullToAbsent) {
    return VariablesCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      varKey: Value(varKey),
      varValue: Value(varValue),
      isSecret: Value(isSecret),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory VariableRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VariableRow(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      varKey: serializer.fromJson<String>(json['varKey']),
      varValue: serializer.fromJson<String>(json['varValue']),
      isSecret: serializer.fromJson<bool>(json['isSecret']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'varKey': serializer.toJson<String>(varKey),
      'varValue': serializer.toJson<String>(varValue),
      'isSecret': serializer.toJson<bool>(isSecret),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  VariableRow copyWith({
    int? id,
    int? nodeId,
    String? varKey,
    String? varValue,
    bool? isSecret,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => VariableRow(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    varKey: varKey ?? this.varKey,
    varValue: varValue ?? this.varValue,
    isSecret: isSecret ?? this.isSecret,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  VariableRow copyWithCompanion(VariablesCompanion data) {
    return VariableRow(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      varKey: data.varKey.present ? data.varKey.value : this.varKey,
      varValue: data.varValue.present ? data.varValue.value : this.varValue,
      isSecret: data.isSecret.present ? data.isSecret.value : this.isSecret,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VariableRow(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('varKey: $varKey, ')
          ..write('varValue: $varValue, ')
          ..write('isSecret: $isSecret, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nodeId,
    varKey,
    varValue,
    isSecret,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VariableRow &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.varKey == this.varKey &&
          other.varValue == this.varValue &&
          other.isSecret == this.isSecret &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class VariablesCompanion extends UpdateCompanion<VariableRow> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<String> varKey;
  final Value<String> varValue;
  final Value<bool> isSecret;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const VariablesCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.varKey = const Value.absent(),
    this.varValue = const Value.absent(),
    this.isSecret = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  VariablesCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    required String varKey,
    this.varValue = const Value.absent(),
    this.isSecret = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : nodeId = Value(nodeId),
       varKey = Value(varKey);
  static Insertable<VariableRow> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<String>? varKey,
    Expression<String>? varValue,
    Expression<bool>? isSecret,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (varKey != null) 'var_key': varKey,
      if (varValue != null) 'var_value': varValue,
      if (isSecret != null) 'is_secret': isSecret,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  VariablesCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<String>? varKey,
    Value<String>? varValue,
    Value<bool>? isSecret,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return VariablesCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      varKey: varKey ?? this.varKey,
      varValue: varValue ?? this.varValue,
      isSecret: isSecret ?? this.isSecret,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (varKey.present) {
      map['var_key'] = Variable<String>(varKey.value);
    }
    if (varValue.present) {
      map['var_value'] = Variable<String>(varValue.value);
    }
    if (isSecret.present) {
      map['is_secret'] = Variable<bool>(isSecret.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariablesCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('varKey: $varKey, ')
          ..write('varValue: $varValue, ')
          ..write('isSecret: $isSecret, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, Alert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fireAtMeta = const VerificationMeta('fireAt');
  @override
  late final GeneratedColumn<DateTime> fireAt = GeneratedColumn<DateTime>(
    'fire_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderMinutesBeforeMeta =
      const VerificationMeta('reminderMinutesBefore');
  @override
  late final GeneratedColumn<int> reminderMinutesBefore = GeneratedColumn<int>(
    'reminder_minutes_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifiedMeta = const VerificationMeta(
    'notified',
  );
  @override
  late final GeneratedColumn<bool> notified = GeneratedColumn<bool>(
    'notified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    title,
    fireAt,
    reminderMinutesBefore,
    enabled,
    notified,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Alert> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('fire_at')) {
      context.handle(
        _fireAtMeta,
        fireAt.isAcceptableOrUnknown(data['fire_at']!, _fireAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fireAtMeta);
    }
    if (data.containsKey('reminder_minutes_before')) {
      context.handle(
        _reminderMinutesBeforeMeta,
        reminderMinutesBefore.isAcceptableOrUnknown(
          data['reminder_minutes_before']!,
          _reminderMinutesBeforeMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('notified')) {
      context.handle(
        _notifiedMeta,
        notified.isAcceptableOrUnknown(data['notified']!, _notifiedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alert(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      fireAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}fire_at'],
          )!,
      reminderMinutesBefore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}reminder_minutes_before'],
          )!,
      enabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}enabled'],
          )!,
      notified:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}notified'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class Alert extends DataClass implements Insertable<Alert> {
  final int id;
  final int nodeId;
  final String title;
  final DateTime fireAt;
  final int reminderMinutesBefore;
  final bool enabled;
  final bool notified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Alert({
    required this.id,
    required this.nodeId,
    required this.title,
    required this.fireAt,
    required this.reminderMinutesBefore,
    required this.enabled,
    required this.notified,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    map['title'] = Variable<String>(title);
    map['fire_at'] = Variable<DateTime>(fireAt);
    map['reminder_minutes_before'] = Variable<int>(reminderMinutesBefore);
    map['enabled'] = Variable<bool>(enabled);
    map['notified'] = Variable<bool>(notified);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      title: Value(title),
      fireAt: Value(fireAt),
      reminderMinutesBefore: Value(reminderMinutesBefore),
      enabled: Value(enabled),
      notified: Value(notified),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
    );
  }

  factory Alert.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alert(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      title: serializer.fromJson<String>(json['title']),
      fireAt: serializer.fromJson<DateTime>(json['fireAt']),
      reminderMinutesBefore: serializer.fromJson<int>(
        json['reminderMinutesBefore'],
      ),
      enabled: serializer.fromJson<bool>(json['enabled']),
      notified: serializer.fromJson<bool>(json['notified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'title': serializer.toJson<String>(title),
      'fireAt': serializer.toJson<DateTime>(fireAt),
      'reminderMinutesBefore': serializer.toJson<int>(reminderMinutesBefore),
      'enabled': serializer.toJson<bool>(enabled),
      'notified': serializer.toJson<bool>(notified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Alert copyWith({
    int? id,
    int? nodeId,
    String? title,
    DateTime? fireAt,
    int? reminderMinutesBefore,
    bool? enabled,
    bool? notified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Alert(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    title: title ?? this.title,
    fireAt: fireAt ?? this.fireAt,
    reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
    enabled: enabled ?? this.enabled,
    notified: notified ?? this.notified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Alert copyWithCompanion(AlertsCompanion data) {
    return Alert(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      title: data.title.present ? data.title.value : this.title,
      fireAt: data.fireAt.present ? data.fireAt.value : this.fireAt,
      reminderMinutesBefore:
          data.reminderMinutesBefore.present
              ? data.reminderMinutesBefore.value
              : this.reminderMinutesBefore,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      notified: data.notified.present ? data.notified.value : this.notified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alert(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('title: $title, ')
          ..write('fireAt: $fireAt, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('enabled: $enabled, ')
          ..write('notified: $notified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nodeId,
    title,
    fireAt,
    reminderMinutesBefore,
    enabled,
    notified,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alert &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.title == this.title &&
          other.fireAt == this.fireAt &&
          other.reminderMinutesBefore == this.reminderMinutesBefore &&
          other.enabled == this.enabled &&
          other.notified == this.notified &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class AlertsCompanion extends UpdateCompanion<Alert> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<String> title;
  final Value<DateTime> fireAt;
  final Value<int> reminderMinutesBefore;
  final Value<bool> enabled;
  final Value<bool> notified;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.title = const Value.absent(),
    this.fireAt = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
    this.enabled = const Value.absent(),
    this.notified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  AlertsCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    required String title,
    required DateTime fireAt,
    this.reminderMinutesBefore = const Value.absent(),
    this.enabled = const Value.absent(),
    this.notified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : nodeId = Value(nodeId),
       title = Value(title),
       fireAt = Value(fireAt);
  static Insertable<Alert> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<String>? title,
    Expression<DateTime>? fireAt,
    Expression<int>? reminderMinutesBefore,
    Expression<bool>? enabled,
    Expression<bool>? notified,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (title != null) 'title': title,
      if (fireAt != null) 'fire_at': fireAt,
      if (reminderMinutesBefore != null)
        'reminder_minutes_before': reminderMinutesBefore,
      if (enabled != null) 'enabled': enabled,
      if (notified != null) 'notified': notified,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  AlertsCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<String>? title,
    Value<DateTime>? fireAt,
    Value<int>? reminderMinutesBefore,
    Value<bool>? enabled,
    Value<bool>? notified,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return AlertsCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      title: title ?? this.title,
      fireAt: fireAt ?? this.fireAt,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      enabled: enabled ?? this.enabled,
      notified: notified ?? this.notified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (fireAt.present) {
      map['fire_at'] = Variable<DateTime>(fireAt.value);
    }
    if (reminderMinutesBefore.present) {
      map['reminder_minutes_before'] = Variable<int>(
        reminderMinutesBefore.value,
      );
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (notified.present) {
      map['notified'] = Variable<bool>(notified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('title: $title, ')
          ..write('fireAt: $fireAt, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('enabled: $enabled, ')
          ..write('notified: $notified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $OpenLogsTable extends OpenLogs with TableInfo<$OpenLogsTable, OpenLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpenLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int> nodeId = GeneratedColumn<int>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nodes (id)',
    ),
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nodeId, openedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'open_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<OpenLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpenLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OpenLog(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nodeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}node_id'],
          )!,
      openedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}opened_at'],
          )!,
    );
  }

  @override
  $OpenLogsTable createAlias(String alias) {
    return $OpenLogsTable(attachedDatabase, alias);
  }
}

class OpenLog extends DataClass implements Insertable<OpenLog> {
  final int id;
  final int nodeId;
  final DateTime openedAt;
  const OpenLog({
    required this.id,
    required this.nodeId,
    required this.openedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<int>(nodeId);
    map['opened_at'] = Variable<DateTime>(openedAt);
    return map;
  }

  OpenLogsCompanion toCompanion(bool nullToAbsent) {
    return OpenLogsCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      openedAt: Value(openedAt),
    );
  }

  factory OpenLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OpenLog(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<int>(json['nodeId']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<int>(nodeId),
      'openedAt': serializer.toJson<DateTime>(openedAt),
    };
  }

  OpenLog copyWith({int? id, int? nodeId, DateTime? openedAt}) => OpenLog(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    openedAt: openedAt ?? this.openedAt,
  );
  OpenLog copyWithCompanion(OpenLogsCompanion data) {
    return OpenLog(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OpenLog(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('openedAt: $openedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nodeId, openedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpenLog &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.openedAt == this.openedAt);
}

class OpenLogsCompanion extends UpdateCompanion<OpenLog> {
  final Value<int> id;
  final Value<int> nodeId;
  final Value<DateTime> openedAt;
  const OpenLogsCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.openedAt = const Value.absent(),
  });
  OpenLogsCompanion.insert({
    this.id = const Value.absent(),
    required int nodeId,
    this.openedAt = const Value.absent(),
  }) : nodeId = Value(nodeId);
  static Insertable<OpenLog> custom({
    Expression<int>? id,
    Expression<int>? nodeId,
    Expression<DateTime>? openedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (openedAt != null) 'opened_at': openedAt,
    });
  }

  OpenLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? nodeId,
    Value<DateTime>? openedAt,
  }) {
    return OpenLogsCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      openedAt: openedAt ?? this.openedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int>(nodeId.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpenLogsCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('openedAt: $openedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
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
      map['value'] = Variable<String>(value.value);
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
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NodesTable nodes = $NodesTable(this);
  late final $LinksTable links = $LinksTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $EmailsTable emails = $EmailsTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $PlatformsTable platforms = $PlatformsTable(this);
  late final $VariablesTable variables = $VariablesTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $OpenLogsTable openLogs = $OpenLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final NodesDao nodesDao = NodesDao(this as AppDatabase);
  late final ElementsDao elementsDao = ElementsDao(this as AppDatabase);
  late final BackupDao backupDao = BackupDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    nodes,
    links,
    notes,
    emails,
    subscriptions,
    platforms,
    variables,
    alerts,
    openLogs,
    appSettings,
  ];
}

typedef $$NodesTableCreateCompanionBuilder =
    NodesCompanion Function({
      Value<int> id,
      Value<int?> parentId,
      required String name,
      required NodeType type,
      Value<NodeTemplate?> template,
      Value<String> icon,
      Value<NodeStatus> status,
      Value<int> sortIndex,
      Value<DateTime?> lastOpenedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$NodesTableUpdateCompanionBuilder =
    NodesCompanion Function({
      Value<int> id,
      Value<int?> parentId,
      Value<String> name,
      Value<NodeType> type,
      Value<NodeTemplate?> template,
      Value<String> icon,
      Value<NodeStatus> status,
      Value<int> sortIndex,
      Value<DateTime?> lastOpenedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$NodesTableReferences
    extends BaseReferences<_$AppDatabase, $NodesTable, Node> {
  $$NodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _parentIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('nodes__parent_id__nodes__id');

  $$NodesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LinksTable, List<Link>> _linksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.links,
    aliasName: 'nodes__id__links__node_id',
  );

  $$LinksTableProcessedTableManager get linksRefs {
    final manager = $$LinksTableTableManager(
      $_db,
      $_db.links,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_linksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'nodes__id__notes__node_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EmailsTable, List<Email>> _emailsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.emails,
    aliasName: 'nodes__id__emails__node_id',
  );

  $$EmailsTableProcessedTableManager get emailsRefs {
    final manager = $$EmailsTableTableManager(
      $_db,
      $_db.emails,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubscriptionsTable, List<Subscription>>
  _subscriptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subscriptions,
    aliasName: 'nodes__id__subscriptions__node_id',
  );

  $$SubscriptionsTableProcessedTableManager get subscriptionsRefs {
    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subscriptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlatformsTable, List<PlatformRow>>
  _platformsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.platforms,
    aliasName: 'nodes__id__platforms__node_id',
  );

  $$PlatformsTableProcessedTableManager get platformsRefs {
    final manager = $$PlatformsTableTableManager(
      $_db,
      $_db.platforms,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_platformsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VariablesTable, List<VariableRow>>
  _variablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.variables,
    aliasName: 'nodes__id__variables__node_id',
  );

  $$VariablesTableProcessedTableManager get variablesRefs {
    final manager = $$VariablesTableTableManager(
      $_db,
      $_db.variables,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_variablesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AlertsTable, List<Alert>> _alertsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.alerts,
    aliasName: 'nodes__id__alerts__node_id',
  );

  $$AlertsTableProcessedTableManager get alertsRefs {
    final manager = $$AlertsTableTableManager(
      $_db,
      $_db.alerts,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_alertsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OpenLogsTable, List<OpenLog>> _openLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.openLogs,
    aliasName: 'nodes__id__open_logs__node_id',
  );

  $$OpenLogsTableProcessedTableManager get openLogsRefs {
    final manager = $$OpenLogsTableTableManager(
      $_db,
      $_db.openLogs,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_openLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NodesTableFilterComposer extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NodeType, NodeType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<NodeTemplate?, NodeTemplate, String>
  get template => $composableBuilder(
    column: $table.template,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NodeStatus, NodeStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get parentId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> linksRefs(
    Expression<bool> Function($$LinksTableFilterComposer f) f,
  ) {
    final $$LinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.links,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LinksTableFilterComposer(
            $db: $db,
            $table: $db.links,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> emailsRefs(
    Expression<bool> Function($$EmailsTableFilterComposer f) f,
  ) {
    final $$EmailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emails,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailsTableFilterComposer(
            $db: $db,
            $table: $db.emails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> subscriptionsRefs(
    Expression<bool> Function($$SubscriptionsTableFilterComposer f) f,
  ) {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> platformsRefs(
    Expression<bool> Function($$PlatformsTableFilterComposer f) f,
  ) {
    final $$PlatformsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableFilterComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> variablesRefs(
    Expression<bool> Function($$VariablesTableFilterComposer f) f,
  ) {
    final $$VariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variables,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariablesTableFilterComposer(
            $db: $db,
            $table: $db.variables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> alertsRefs(
    Expression<bool> Function($$AlertsTableFilterComposer f) f,
  ) {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alerts,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertsTableFilterComposer(
            $db: $db,
            $table: $db.alerts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> openLogsRefs(
    Expression<bool> Function($$OpenLogsTableFilterComposer f) f,
  ) {
    final $$OpenLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.openLogs,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OpenLogsTableFilterComposer(
            $db: $db,
            $table: $db.openLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NodesTableOrderingComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get template => $composableBuilder(
    column: $table.template,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get parentId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NodeType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NodeTemplate?, String> get template =>
      $composableBuilder(column: $table.template, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NodeStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get parentId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> linksRefs<T extends Object>(
    Expression<T> Function($$LinksTableAnnotationComposer a) f,
  ) {
    final $$LinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.links,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LinksTableAnnotationComposer(
            $db: $db,
            $table: $db.links,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> emailsRefs<T extends Object>(
    Expression<T> Function($$EmailsTableAnnotationComposer a) f,
  ) {
    final $$EmailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emails,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailsTableAnnotationComposer(
            $db: $db,
            $table: $db.emails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> subscriptionsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> platformsRefs<T extends Object>(
    Expression<T> Function($$PlatformsTableAnnotationComposer a) f,
  ) {
    final $$PlatformsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableAnnotationComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> variablesRefs<T extends Object>(
    Expression<T> Function($$VariablesTableAnnotationComposer a) f,
  ) {
    final $$VariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variables,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.variables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> alertsRefs<T extends Object>(
    Expression<T> Function($$AlertsTableAnnotationComposer a) f,
  ) {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alerts,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertsTableAnnotationComposer(
            $db: $db,
            $table: $db.alerts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> openLogsRefs<T extends Object>(
    Expression<T> Function($$OpenLogsTableAnnotationComposer a) f,
  ) {
    final $$OpenLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.openLogs,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OpenLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.openLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodesTable,
          Node,
          $$NodesTableFilterComposer,
          $$NodesTableOrderingComposer,
          $$NodesTableAnnotationComposer,
          $$NodesTableCreateCompanionBuilder,
          $$NodesTableUpdateCompanionBuilder,
          (Node, $$NodesTableReferences),
          Node,
          PrefetchHooks Function({
            bool parentId,
            bool linksRefs,
            bool notesRefs,
            bool emailsRefs,
            bool subscriptionsRefs,
            bool platformsRefs,
            bool variablesRefs,
            bool alertsRefs,
            bool openLogsRefs,
          })
        > {
  $$NodesTableTableManager(_$AppDatabase db, $NodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$NodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$NodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<NodeType> type = const Value.absent(),
                Value<NodeTemplate?> template = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<NodeStatus> status = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => NodesCompanion(
                id: id,
                parentId: parentId,
                name: name,
                type: type,
                template: template,
                icon: icon,
                status: status,
                sortIndex: sortIndex,
                lastOpenedAt: lastOpenedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                required String name,
                required NodeType type,
                Value<NodeTemplate?> template = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<NodeStatus> status = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => NodesCompanion.insert(
                id: id,
                parentId: parentId,
                name: name,
                type: type,
                template: template,
                icon: icon,
                status: status,
                sortIndex: sortIndex,
                lastOpenedAt: lastOpenedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$NodesTable, Node>(table),
                          $$NodesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            parentId = false,
            linksRefs = false,
            notesRefs = false,
            emailsRefs = false,
            subscriptionsRefs = false,
            platformsRefs = false,
            variablesRefs = false,
            alertsRefs = false,
            openLogsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (linksRefs) db.links,
                if (notesRefs) db.notes,
                if (emailsRefs) db.emails,
                if (subscriptionsRefs) db.subscriptions,
                if (platformsRefs) db.platforms,
                if (variablesRefs) db.variables,
                if (alertsRefs) db.alerts,
                if (openLogsRefs) db.openLogs,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (parentId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$NodesTableReferences
                                ._parentIdTable(db),
                            referencedColumn:
                                $$NodesTableReferences._parentIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (linksRefs)
                    await $_getPrefetchedData<Node, $NodesTable, Link>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences._linksRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(db, table, p0).linksRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                  if (notesRefs)
                    await $_getPrefetchedData<Node, $NodesTable, Note>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences._notesRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(db, table, p0).notesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                  if (emailsRefs)
                    await $_getPrefetchedData<Node, $NodesTable, Email>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences._emailsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(db, table, p0).emailsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                  if (subscriptionsRefs)
                    await $_getPrefetchedData<Node, $NodesTable, Subscription>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences
                          ._subscriptionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(
                                db,
                                table,
                                p0,
                              ).subscriptionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                  if (platformsRefs)
                    await $_getPrefetchedData<Node, $NodesTable, PlatformRow>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences
                          ._platformsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(
                                db,
                                table,
                                p0,
                              ).platformsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                  if (variablesRefs)
                    await $_getPrefetchedData<Node, $NodesTable, VariableRow>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences
                          ._variablesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(
                                db,
                                table,
                                p0,
                              ).variablesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                  if (alertsRefs)
                    await $_getPrefetchedData<Node, $NodesTable, Alert>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences._alertsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(db, table, p0).alertsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                  if (openLogsRefs)
                    await $_getPrefetchedData<Node, $NodesTable, OpenLog>(
                      currentTable: table,
                      referencedTable: $$NodesTableReferences
                          ._openLogsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$NodesTableReferences(
                                db,
                                table,
                                p0,
                              ).openLogsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.nodeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodesTable,
      Node,
      $$NodesTableFilterComposer,
      $$NodesTableOrderingComposer,
      $$NodesTableAnnotationComposer,
      $$NodesTableCreateCompanionBuilder,
      $$NodesTableUpdateCompanionBuilder,
      (Node, $$NodesTableReferences),
      Node,
      PrefetchHooks Function({
        bool parentId,
        bool linksRefs,
        bool notesRefs,
        bool emailsRefs,
        bool subscriptionsRefs,
        bool platformsRefs,
        bool variablesRefs,
        bool alertsRefs,
        bool openLogsRefs,
      })
    >;
typedef $$LinksTableCreateCompanionBuilder =
    LinksCompanion Function({
      Value<int> id,
      required int nodeId,
      required String title,
      required String url,
      required LinkCategory category,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$LinksTableUpdateCompanionBuilder =
    LinksCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<String> title,
      Value<String> url,
      Value<LinkCategory> category,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$LinksTableReferences
    extends BaseReferences<_$AppDatabase, $LinksTable, Link> {
  $$LinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('links__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LinksTableFilterComposer extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LinkCategory, LinkCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LinksTableOrderingComposer
    extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LinkCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LinksTable,
          Link,
          $$LinksTableFilterComposer,
          $$LinksTableOrderingComposer,
          $$LinksTableAnnotationComposer,
          $$LinksTableCreateCompanionBuilder,
          $$LinksTableUpdateCompanionBuilder,
          (Link, $$LinksTableReferences),
          Link,
          PrefetchHooks Function({bool nodeId})
        > {
  $$LinksTableTableManager(_$AppDatabase db, $LinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$LinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<LinkCategory> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => LinksCompanion(
                id: id,
                nodeId: nodeId,
                title: title,
                url: url,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                required String title,
                required String url,
                required LinkCategory category,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => LinksCompanion.insert(
                id: id,
                nodeId: nodeId,
                title: title,
                url: url,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$LinksTable, Link>(table),
                          $$LinksTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$LinksTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$LinksTableReferences._nodeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LinksTable,
      Link,
      $$LinksTableFilterComposer,
      $$LinksTableOrderingComposer,
      $$LinksTableAnnotationComposer,
      $$LinksTableCreateCompanionBuilder,
      $$LinksTableUpdateCompanionBuilder,
      (Link, $$LinksTableReferences),
      Link,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      required int nodeId,
      Value<String?> title,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<String?> title,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, Note> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('notes__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, $$NotesTableReferences),
          Note,
          PrefetchHooks Function({bool nodeId})
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                nodeId: nodeId,
                title: title,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                Value<String?> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                nodeId: nodeId,
                title: title,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$NotesTable, Note>(table),
                          $$NotesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$NotesTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$NotesTableReferences._nodeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, $$NotesTableReferences),
      Note,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$EmailsTableCreateCompanionBuilder =
    EmailsCompanion Function({
      Value<int> id,
      required int nodeId,
      required String label,
      required String address,
      Value<String?> password,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$EmailsTableUpdateCompanionBuilder =
    EmailsCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<String> label,
      Value<String> address,
      Value<String?> password,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$EmailsTableReferences
    extends BaseReferences<_$AppDatabase, $EmailsTable, Email> {
  $$EmailsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('emails__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmailsTableFilterComposer
    extends Composer<_$AppDatabase, $EmailsTable> {
  $$EmailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmailsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailsTable> {
  $$EmailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailsTable> {
  $$EmailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailsTable,
          Email,
          $$EmailsTableFilterComposer,
          $$EmailsTableOrderingComposer,
          $$EmailsTableAnnotationComposer,
          $$EmailsTableCreateCompanionBuilder,
          $$EmailsTableUpdateCompanionBuilder,
          (Email, $$EmailsTableReferences),
          Email,
          PrefetchHooks Function({bool nodeId})
        > {
  $$EmailsTableTableManager(_$AppDatabase db, $EmailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EmailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EmailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EmailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => EmailsCompanion(
                id: id,
                nodeId: nodeId,
                label: label,
                address: address,
                password: password,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                required String label,
                required String address,
                Value<String?> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => EmailsCompanion.insert(
                id: id,
                nodeId: nodeId,
                label: label,
                address: address,
                password: password,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$EmailsTable, Email>(table),
                          $$EmailsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$EmailsTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$EmailsTableReferences._nodeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailsTable,
      Email,
      $$EmailsTableFilterComposer,
      $$EmailsTableOrderingComposer,
      $$EmailsTableAnnotationComposer,
      $$EmailsTableCreateCompanionBuilder,
      $$EmailsTableUpdateCompanionBuilder,
      (Email, $$EmailsTableReferences),
      Email,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$SubscriptionsTableCreateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<int> id,
      required int nodeId,
      required String serviceName,
      Value<String?> plan,
      Value<String?> price,
      Value<BillingCycle> cycle,
      Value<DateTime?> renewsAt,
      Value<SubStatus> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$SubscriptionsTableUpdateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<String> serviceName,
      Value<String?> plan,
      Value<String?> price,
      Value<BillingCycle> cycle,
      Value<DateTime?> renewsAt,
      Value<SubStatus> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$SubscriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription> {
  $$SubscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('subscriptions__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BillingCycle, BillingCycle, String>
  get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get renewsAt => $composableBuilder(
    column: $table.renewsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SubStatus, SubStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get renewsAt => $composableBuilder(
    column: $table.renewsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<String> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BillingCycle, String> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumn<DateTime> get renewsAt =>
      $composableBuilder(column: $table.renewsAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SubStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTable,
          Subscription,
          $$SubscriptionsTableFilterComposer,
          $$SubscriptionsTableOrderingComposer,
          $$SubscriptionsTableAnnotationComposer,
          $$SubscriptionsTableCreateCompanionBuilder,
          $$SubscriptionsTableUpdateCompanionBuilder,
          (Subscription, $$SubscriptionsTableReferences),
          Subscription,
          PrefetchHooks Function({bool nodeId})
        > {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SubscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<String> serviceName = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<String?> price = const Value.absent(),
                Value<BillingCycle> cycle = const Value.absent(),
                Value<DateTime?> renewsAt = const Value.absent(),
                Value<SubStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => SubscriptionsCompanion(
                id: id,
                nodeId: nodeId,
                serviceName: serviceName,
                plan: plan,
                price: price,
                cycle: cycle,
                renewsAt: renewsAt,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                required String serviceName,
                Value<String?> plan = const Value.absent(),
                Value<String?> price = const Value.absent(),
                Value<BillingCycle> cycle = const Value.absent(),
                Value<DateTime?> renewsAt = const Value.absent(),
                Value<SubStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                id: id,
                nodeId: nodeId,
                serviceName: serviceName,
                plan: plan,
                price: price,
                cycle: cycle,
                renewsAt: renewsAt,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$SubscriptionsTable, Subscription>(table),
                          $$SubscriptionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$SubscriptionsTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$SubscriptionsTableReferences
                                    ._nodeIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTable,
      Subscription,
      $$SubscriptionsTableFilterComposer,
      $$SubscriptionsTableOrderingComposer,
      $$SubscriptionsTableAnnotationComposer,
      $$SubscriptionsTableCreateCompanionBuilder,
      $$SubscriptionsTableUpdateCompanionBuilder,
      (Subscription, $$SubscriptionsTableReferences),
      Subscription,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$PlatformsTableCreateCompanionBuilder =
    PlatformsCompanion Function({
      Value<int> id,
      required int nodeId,
      required String platformName,
      Value<String?> account,
      Value<String?> url,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$PlatformsTableUpdateCompanionBuilder =
    PlatformsCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<String> platformName,
      Value<String?> account,
      Value<String?> url,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$PlatformsTableReferences
    extends BaseReferences<_$AppDatabase, $PlatformsTable, PlatformRow> {
  $$PlatformsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('platforms__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlatformsTableFilterComposer
    extends Composer<_$AppDatabase, $PlatformsTable> {
  $$PlatformsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformName => $composableBuilder(
    column: $table.platformName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get account => $composableBuilder(
    column: $table.account,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlatformsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlatformsTable> {
  $$PlatformsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformName => $composableBuilder(
    column: $table.platformName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get account => $composableBuilder(
    column: $table.account,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlatformsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlatformsTable> {
  $$PlatformsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platformName => $composableBuilder(
    column: $table.platformName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get account =>
      $composableBuilder(column: $table.account, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlatformsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlatformsTable,
          PlatformRow,
          $$PlatformsTableFilterComposer,
          $$PlatformsTableOrderingComposer,
          $$PlatformsTableAnnotationComposer,
          $$PlatformsTableCreateCompanionBuilder,
          $$PlatformsTableUpdateCompanionBuilder,
          (PlatformRow, $$PlatformsTableReferences),
          PlatformRow,
          PrefetchHooks Function({bool nodeId})
        > {
  $$PlatformsTableTableManager(_$AppDatabase db, $PlatformsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlatformsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PlatformsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlatformsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<String> platformName = const Value.absent(),
                Value<String?> account = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => PlatformsCompanion(
                id: id,
                nodeId: nodeId,
                platformName: platformName,
                account: account,
                url: url,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                required String platformName,
                Value<String?> account = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => PlatformsCompanion.insert(
                id: id,
                nodeId: nodeId,
                platformName: platformName,
                account: account,
                url: url,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$PlatformsTable, PlatformRow>(table),
                          $$PlatformsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$PlatformsTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$PlatformsTableReferences._nodeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlatformsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlatformsTable,
      PlatformRow,
      $$PlatformsTableFilterComposer,
      $$PlatformsTableOrderingComposer,
      $$PlatformsTableAnnotationComposer,
      $$PlatformsTableCreateCompanionBuilder,
      $$PlatformsTableUpdateCompanionBuilder,
      (PlatformRow, $$PlatformsTableReferences),
      PlatformRow,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$VariablesTableCreateCompanionBuilder =
    VariablesCompanion Function({
      Value<int> id,
      required int nodeId,
      required String varKey,
      Value<String> varValue,
      Value<bool> isSecret,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$VariablesTableUpdateCompanionBuilder =
    VariablesCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<String> varKey,
      Value<String> varValue,
      Value<bool> isSecret,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$VariablesTableReferences
    extends BaseReferences<_$AppDatabase, $VariablesTable, VariableRow> {
  $$VariablesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('variables__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VariablesTableFilterComposer
    extends Composer<_$AppDatabase, $VariablesTable> {
  $$VariablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get varKey => $composableBuilder(
    column: $table.varKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get varValue => $composableBuilder(
    column: $table.varValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSecret => $composableBuilder(
    column: $table.isSecret,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VariablesTableOrderingComposer
    extends Composer<_$AppDatabase, $VariablesTable> {
  $$VariablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get varKey => $composableBuilder(
    column: $table.varKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get varValue => $composableBuilder(
    column: $table.varValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSecret => $composableBuilder(
    column: $table.isSecret,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VariablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VariablesTable> {
  $$VariablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get varKey =>
      $composableBuilder(column: $table.varKey, builder: (column) => column);

  GeneratedColumn<String> get varValue =>
      $composableBuilder(column: $table.varValue, builder: (column) => column);

  GeneratedColumn<bool> get isSecret =>
      $composableBuilder(column: $table.isSecret, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VariablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VariablesTable,
          VariableRow,
          $$VariablesTableFilterComposer,
          $$VariablesTableOrderingComposer,
          $$VariablesTableAnnotationComposer,
          $$VariablesTableCreateCompanionBuilder,
          $$VariablesTableUpdateCompanionBuilder,
          (VariableRow, $$VariablesTableReferences),
          VariableRow,
          PrefetchHooks Function({bool nodeId})
        > {
  $$VariablesTableTableManager(_$AppDatabase db, $VariablesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$VariablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$VariablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$VariablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<String> varKey = const Value.absent(),
                Value<String> varValue = const Value.absent(),
                Value<bool> isSecret = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => VariablesCompanion(
                id: id,
                nodeId: nodeId,
                varKey: varKey,
                varValue: varValue,
                isSecret: isSecret,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                required String varKey,
                Value<String> varValue = const Value.absent(),
                Value<bool> isSecret = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => VariablesCompanion.insert(
                id: id,
                nodeId: nodeId,
                varKey: varKey,
                varValue: varValue,
                isSecret: isSecret,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$VariablesTable, VariableRow>(table),
                          $$VariablesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$VariablesTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$VariablesTableReferences._nodeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VariablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VariablesTable,
      VariableRow,
      $$VariablesTableFilterComposer,
      $$VariablesTableOrderingComposer,
      $$VariablesTableAnnotationComposer,
      $$VariablesTableCreateCompanionBuilder,
      $$VariablesTableUpdateCompanionBuilder,
      (VariableRow, $$VariablesTableReferences),
      VariableRow,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$AlertsTableCreateCompanionBuilder =
    AlertsCompanion Function({
      Value<int> id,
      required int nodeId,
      required String title,
      required DateTime fireAt,
      Value<int> reminderMinutesBefore,
      Value<bool> enabled,
      Value<bool> notified,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$AlertsTableUpdateCompanionBuilder =
    AlertsCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<String> title,
      Value<DateTime> fireAt,
      Value<int> reminderMinutesBefore,
      Value<bool> enabled,
      Value<bool> notified,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$AlertsTableReferences
    extends BaseReferences<_$AppDatabase, $AlertsTable, Alert> {
  $$AlertsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('alerts__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notified => $composableBuilder(
    column: $table.notified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notified => $composableBuilder(
    column: $table.notified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get fireAt =>
      $composableBuilder(column: $table.fireAt, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get notified =>
      $composableBuilder(column: $table.notified, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertsTable,
          Alert,
          $$AlertsTableFilterComposer,
          $$AlertsTableOrderingComposer,
          $$AlertsTableAnnotationComposer,
          $$AlertsTableCreateCompanionBuilder,
          $$AlertsTableUpdateCompanionBuilder,
          (Alert, $$AlertsTableReferences),
          Alert,
          PrefetchHooks Function({bool nodeId})
        > {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> fireAt = const Value.absent(),
                Value<int> reminderMinutesBefore = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> notified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => AlertsCompanion(
                id: id,
                nodeId: nodeId,
                title: title,
                fireAt: fireAt,
                reminderMinutesBefore: reminderMinutesBefore,
                enabled: enabled,
                notified: notified,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                required String title,
                required DateTime fireAt,
                Value<int> reminderMinutesBefore = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> notified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => AlertsCompanion.insert(
                id: id,
                nodeId: nodeId,
                title: title,
                fireAt: fireAt,
                reminderMinutesBefore: reminderMinutesBefore,
                enabled: enabled,
                notified: notified,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$AlertsTable, Alert>(table),
                          $$AlertsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$AlertsTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$AlertsTableReferences._nodeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertsTable,
      Alert,
      $$AlertsTableFilterComposer,
      $$AlertsTableOrderingComposer,
      $$AlertsTableAnnotationComposer,
      $$AlertsTableCreateCompanionBuilder,
      $$AlertsTableUpdateCompanionBuilder,
      (Alert, $$AlertsTableReferences),
      Alert,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$OpenLogsTableCreateCompanionBuilder =
    OpenLogsCompanion Function({
      Value<int> id,
      required int nodeId,
      Value<DateTime> openedAt,
    });
typedef $$OpenLogsTableUpdateCompanionBuilder =
    OpenLogsCompanion Function({
      Value<int> id,
      Value<int> nodeId,
      Value<DateTime> openedAt,
    });

final class $$OpenLogsTableReferences
    extends BaseReferences<_$AppDatabase, $OpenLogsTable, OpenLog> {
  $$OpenLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NodesTable _nodeIdTable(_$AppDatabase db) =>
      db.nodes.createAlias('open_logs__node_id__nodes__id');

  $$NodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<int>('node_id')!;

    final manager = $$NodesTableTableManager(
      $_db,
      $_db.nodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OpenLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OpenLogsTable> {
  $$OpenLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NodesTableFilterComposer get nodeId {
    final $$NodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableFilterComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OpenLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OpenLogsTable> {
  $$OpenLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NodesTableOrderingComposer get nodeId {
    final $$NodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableOrderingComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OpenLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpenLogsTable> {
  $$OpenLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  $$NodesTableAnnotationComposer get nodeId {
    final $$NodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.nodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NodesTableAnnotationComposer(
            $db: $db,
            $table: $db.nodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OpenLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OpenLogsTable,
          OpenLog,
          $$OpenLogsTableFilterComposer,
          $$OpenLogsTableOrderingComposer,
          $$OpenLogsTableAnnotationComposer,
          $$OpenLogsTableCreateCompanionBuilder,
          $$OpenLogsTableUpdateCompanionBuilder,
          (OpenLog, $$OpenLogsTableReferences),
          OpenLog,
          PrefetchHooks Function({bool nodeId})
        > {
  $$OpenLogsTableTableManager(_$AppDatabase db, $OpenLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$OpenLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$OpenLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$OpenLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nodeId = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
              }) =>
                  OpenLogsCompanion(id: id, nodeId: nodeId, openedAt: openedAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nodeId,
                Value<DateTime> openedAt = const Value.absent(),
              }) => OpenLogsCompanion.insert(
                id: id,
                nodeId: nodeId,
                openedAt: openedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$OpenLogsTable, OpenLog>(table),
                          $$OpenLogsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (nodeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nodeId,
                            referencedTable: $$OpenLogsTableReferences
                                ._nodeIdTable(db),
                            referencedColumn:
                                $$OpenLogsTableReferences._nodeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OpenLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OpenLogsTable,
      OpenLog,
      $$OpenLogsTableFilterComposer,
      $$OpenLogsTableOrderingComposer,
      $$OpenLogsTableAnnotationComposer,
      $$OpenLogsTableCreateCompanionBuilder,
      $$OpenLogsTableUpdateCompanionBuilder,
      (OpenLog, $$OpenLogsTableReferences),
      OpenLog,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
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
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$AppSettingsTable, AppSetting>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $AppSettingsTable,
                            AppSetting
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db, _db.nodes);
  $$LinksTableTableManager get links =>
      $$LinksTableTableManager(_db, _db.links);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$EmailsTableTableManager get emails =>
      $$EmailsTableTableManager(_db, _db.emails);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$PlatformsTableTableManager get platforms =>
      $$PlatformsTableTableManager(_db, _db.platforms);
  $$VariablesTableTableManager get variables =>
      $$VariablesTableTableManager(_db, _db.variables);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
  $$OpenLogsTableTableManager get openLogs =>
      $$OpenLogsTableTableManager(_db, _db.openLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}

mixin _$NodesDaoMixin on DatabaseAccessor<AppDatabase> {
  $NodesTable get nodes => attachedDatabase.nodes;
  $LinksTable get links => attachedDatabase.links;
  $NotesTable get notes => attachedDatabase.notes;
  $EmailsTable get emails => attachedDatabase.emails;
  $SubscriptionsTable get subscriptions => attachedDatabase.subscriptions;
  $PlatformsTable get platforms => attachedDatabase.platforms;
  $VariablesTable get variables => attachedDatabase.variables;
  $AlertsTable get alerts => attachedDatabase.alerts;
  $OpenLogsTable get openLogs => attachedDatabase.openLogs;
  NodesDaoManager get managers => NodesDaoManager(this);
}

class NodesDaoManager {
  final _$NodesDaoMixin _db;
  NodesDaoManager(this._db);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db.attachedDatabase, _db.nodes);
  $$LinksTableTableManager get links =>
      $$LinksTableTableManager(_db.attachedDatabase, _db.links);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db.attachedDatabase, _db.notes);
  $$EmailsTableTableManager get emails =>
      $$EmailsTableTableManager(_db.attachedDatabase, _db.emails);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db.attachedDatabase, _db.subscriptions);
  $$PlatformsTableTableManager get platforms =>
      $$PlatformsTableTableManager(_db.attachedDatabase, _db.platforms);
  $$VariablesTableTableManager get variables =>
      $$VariablesTableTableManager(_db.attachedDatabase, _db.variables);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db.attachedDatabase, _db.alerts);
  $$OpenLogsTableTableManager get openLogs =>
      $$OpenLogsTableTableManager(_db.attachedDatabase, _db.openLogs);
}

mixin _$ElementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $NodesTable get nodes => attachedDatabase.nodes;
  $LinksTable get links => attachedDatabase.links;
  $NotesTable get notes => attachedDatabase.notes;
  $EmailsTable get emails => attachedDatabase.emails;
  $SubscriptionsTable get subscriptions => attachedDatabase.subscriptions;
  $PlatformsTable get platforms => attachedDatabase.platforms;
  $VariablesTable get variables => attachedDatabase.variables;
  $AlertsTable get alerts => attachedDatabase.alerts;
  ElementsDaoManager get managers => ElementsDaoManager(this);
}

class ElementsDaoManager {
  final _$ElementsDaoMixin _db;
  ElementsDaoManager(this._db);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db.attachedDatabase, _db.nodes);
  $$LinksTableTableManager get links =>
      $$LinksTableTableManager(_db.attachedDatabase, _db.links);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db.attachedDatabase, _db.notes);
  $$EmailsTableTableManager get emails =>
      $$EmailsTableTableManager(_db.attachedDatabase, _db.emails);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db.attachedDatabase, _db.subscriptions);
  $$PlatformsTableTableManager get platforms =>
      $$PlatformsTableTableManager(_db.attachedDatabase, _db.platforms);
  $$VariablesTableTableManager get variables =>
      $$VariablesTableTableManager(_db.attachedDatabase, _db.variables);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db.attachedDatabase, _db.alerts);
}

mixin _$BackupDaoMixin on DatabaseAccessor<AppDatabase> {
  $NodesTable get nodes => attachedDatabase.nodes;
  $LinksTable get links => attachedDatabase.links;
  $NotesTable get notes => attachedDatabase.notes;
  $EmailsTable get emails => attachedDatabase.emails;
  $SubscriptionsTable get subscriptions => attachedDatabase.subscriptions;
  $PlatformsTable get platforms => attachedDatabase.platforms;
  $VariablesTable get variables => attachedDatabase.variables;
  $AlertsTable get alerts => attachedDatabase.alerts;
  $OpenLogsTable get openLogs => attachedDatabase.openLogs;
  BackupDaoManager get managers => BackupDaoManager(this);
}

class BackupDaoManager {
  final _$BackupDaoMixin _db;
  BackupDaoManager(this._db);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db.attachedDatabase, _db.nodes);
  $$LinksTableTableManager get links =>
      $$LinksTableTableManager(_db.attachedDatabase, _db.links);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db.attachedDatabase, _db.notes);
  $$EmailsTableTableManager get emails =>
      $$EmailsTableTableManager(_db.attachedDatabase, _db.emails);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db.attachedDatabase, _db.subscriptions);
  $$PlatformsTableTableManager get platforms =>
      $$PlatformsTableTableManager(_db.attachedDatabase, _db.platforms);
  $$VariablesTableTableManager get variables =>
      $$VariablesTableTableManager(_db.attachedDatabase, _db.variables);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db.attachedDatabase, _db.alerts);
  $$OpenLogsTableTableManager get openLogs =>
      $$OpenLogsTableTableManager(_db.attachedDatabase, _db.openLogs);
}
