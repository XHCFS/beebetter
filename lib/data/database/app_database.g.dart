// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserTable extends User with TableInfo<$UserTable, UserData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, age];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
    );
  }

  @override
  $UserTable createAlias(String alias) {
    return $UserTable(attachedDatabase, alias);
  }
}

class UserData extends DataClass implements Insertable<UserData> {
  final int id;
  final String name;
  final int? age;
  const UserData({required this.id, required this.name, this.age});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    return map;
  }

  UserCompanion toCompanion(bool nullToAbsent) {
    return UserCompanion(
      id: Value(id),
      name: Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
    );
  }

  factory UserData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int?>(json['age']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int?>(age),
    };
  }

  UserData copyWith({
    int? id,
    String? name,
    Value<int?> age = const Value.absent(),
  }) => UserData(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age.present ? age.value : this.age,
  );
  UserData copyWithCompanion(UserCompanion data) {
    return UserData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, age);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age);
}

class UserCompanion extends UpdateCompanion<UserData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> age;
  const UserCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
  });
  UserCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.age = const Value.absent(),
  }) : name = Value(name);
  static Insertable<UserData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
    });
  }

  UserCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? age,
  }) {
    return UserCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age')
          ..write(')'))
        .toString();
  }
}

class $PromptsTable extends Prompts with TableInfo<$PromptsTable, Prompt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromptsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prompts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prompt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prompt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prompt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  $PromptsTable createAlias(String alias) {
    return $PromptsTable(attachedDatabase, alias);
  }
}

class Prompt extends DataClass implements Insertable<Prompt> {
  final int id;
  final String content;
  const Prompt({required this.id, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    return map;
  }

  PromptsCompanion toCompanion(bool nullToAbsent) {
    return PromptsCompanion(id: Value(id), content: Value(content));
  }

  factory Prompt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prompt(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
    };
  }

  Prompt copyWith({int? id, String? content}) =>
      Prompt(id: id ?? this.id, content: content ?? this.content);
  Prompt copyWithCompanion(PromptsCompanion data) {
    return Prompt(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prompt(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prompt && other.id == this.id && other.content == this.content);
}

class PromptsCompanion extends UpdateCompanion<Prompt> {
  final Value<int> id;
  final Value<String> content;
  const PromptsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
  });
  PromptsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
  }) : content = Value(content);
  static Insertable<Prompt> custom({
    Expression<int>? id,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
    });
  }

  PromptsCompanion copyWith({Value<int>? id, Value<String>? content}) {
    return PromptsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromptsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, Record> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _promptIdMeta = const VerificationMeta(
    'promptId',
  );
  @override
  late final GeneratedColumn<int> promptId = GeneratedColumn<int>(
    'prompt_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prompts (id)',
    ),
  );
  static const VerificationMeta _inputTypeMeta = const VerificationMeta(
    'inputType',
  );
  @override
  late final GeneratedColumn<int> inputType = GeneratedColumn<int>(
    'input_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    clientDefault: () => InputType.text.index,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user (id)',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    promptId,
    inputType,
    userId,
    title,
    content,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(
    Insertable<Record> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('prompt_id')) {
      context.handle(
        _promptIdMeta,
        promptId.isAcceptableOrUnknown(data['prompt_id']!, _promptIdMeta),
      );
    }
    if (data.containsKey('input_type')) {
      context.handle(
        _inputTypeMeta,
        inputType.isAcceptableOrUnknown(data['input_type']!, _inputTypeMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Record map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Record(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      promptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prompt_id'],
      ),
      inputType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}input_type'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class Record extends DataClass implements Insertable<Record> {
  final int id;
  final DateTime createdAt;
  final int? promptId;
  final int inputType;
  final int? userId;
  final String? title;
  final String? content;
  const Record({
    required this.id,
    required this.createdAt,
    this.promptId,
    required this.inputType,
    this.userId,
    this.title,
    this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || promptId != null) {
      map['prompt_id'] = Variable<int>(promptId);
    }
    map['input_type'] = Variable<int>(inputType);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      promptId: promptId == null && nullToAbsent
          ? const Value.absent()
          : Value(promptId),
      inputType: Value(inputType),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
    );
  }

  factory Record.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Record(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      promptId: serializer.fromJson<int?>(json['promptId']),
      inputType: serializer.fromJson<int>(json['inputType']),
      userId: serializer.fromJson<int?>(json['userId']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'promptId': serializer.toJson<int?>(promptId),
      'inputType': serializer.toJson<int>(inputType),
      'userId': serializer.toJson<int?>(userId),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String?>(content),
    };
  }

  Record copyWith({
    int? id,
    DateTime? createdAt,
    Value<int?> promptId = const Value.absent(),
    int? inputType,
    Value<int?> userId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> content = const Value.absent(),
  }) => Record(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    promptId: promptId.present ? promptId.value : this.promptId,
    inputType: inputType ?? this.inputType,
    userId: userId.present ? userId.value : this.userId,
    title: title.present ? title.value : this.title,
    content: content.present ? content.value : this.content,
  );
  Record copyWithCompanion(RecordsCompanion data) {
    return Record(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      promptId: data.promptId.present ? data.promptId.value : this.promptId,
      inputType: data.inputType.present ? data.inputType.value : this.inputType,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Record(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('promptId: $promptId, ')
          ..write('inputType: $inputType, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, promptId, inputType, userId, title, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Record &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.promptId == this.promptId &&
          other.inputType == this.inputType &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.content == this.content);
}

class RecordsCompanion extends UpdateCompanion<Record> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<int?> promptId;
  final Value<int> inputType;
  final Value<int?> userId;
  final Value<String?> title;
  final Value<String?> content;
  const RecordsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.promptId = const Value.absent(),
    this.inputType = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
  });
  RecordsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.promptId = const Value.absent(),
    this.inputType = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
  });
  static Insertable<Record> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<int>? promptId,
    Expression<int>? inputType,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (promptId != null) 'prompt_id': promptId,
      if (inputType != null) 'input_type': inputType,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
    });
  }

  RecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<int?>? promptId,
    Value<int>? inputType,
    Value<int?>? userId,
    Value<String?>? title,
    Value<String?>? content,
  }) {
    return RecordsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      promptId: promptId ?? this.promptId,
      inputType: inputType ?? this.inputType,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (promptId.present) {
      map['prompt_id'] = Variable<int>(promptId.value);
    }
    if (inputType.present) {
      map['input_type'] = Variable<int>(inputType.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('promptId: $promptId, ')
          ..write('inputType: $inputType, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $MoodsTable extends Moods with TableInfo<$MoodsTable, Mood> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES records (id)',
    ),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<int> source = GeneratedColumn<int>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    clientDefault: () => MoodSource.user.index,
  );
  @override
  List<GeneratedColumn> get $columns => [id, recordId, mood, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mood> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mood map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mood(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_id'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $MoodsTable createAlias(String alias) {
    return $MoodsTable(attachedDatabase, alias);
  }
}

class Mood extends DataClass implements Insertable<Mood> {
  final int id;
  final int recordId;
  final int? mood;
  final int source;
  const Mood({
    required this.id,
    required this.recordId,
    this.mood,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<int>(recordId);
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    map['source'] = Variable<int>(source);
    return map;
  }

  MoodsCompanion toCompanion(bool nullToAbsent) {
    return MoodsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      source: Value(source),
    );
  }

  factory Mood.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mood(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<int>(json['recordId']),
      mood: serializer.fromJson<int?>(json['mood']),
      source: serializer.fromJson<int>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int>(recordId),
      'mood': serializer.toJson<int?>(mood),
      'source': serializer.toJson<int>(source),
    };
  }

  Mood copyWith({
    int? id,
    int? recordId,
    Value<int?> mood = const Value.absent(),
    int? source,
  }) => Mood(
    id: id ?? this.id,
    recordId: recordId ?? this.recordId,
    mood: mood.present ? mood.value : this.mood,
    source: source ?? this.source,
  );
  Mood copyWithCompanion(MoodsCompanion data) {
    return Mood(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      mood: data.mood.present ? data.mood.value : this.mood,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mood(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('mood: $mood, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordId, mood, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mood &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.mood == this.mood &&
          other.source == this.source);
}

class MoodsCompanion extends UpdateCompanion<Mood> {
  final Value<int> id;
  final Value<int> recordId;
  final Value<int?> mood;
  final Value<int> source;
  const MoodsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.mood = const Value.absent(),
    this.source = const Value.absent(),
  });
  MoodsCompanion.insert({
    this.id = const Value.absent(),
    required int recordId,
    this.mood = const Value.absent(),
    this.source = const Value.absent(),
  }) : recordId = Value(recordId);
  static Insertable<Mood> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<int>? mood,
    Expression<int>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (mood != null) 'mood': mood,
      if (source != null) 'source': source,
    });
  }

  MoodsCompanion copyWith({
    Value<int>? id,
    Value<int>? recordId,
    Value<int?>? mood,
    Value<int>? source,
  }) {
    return MoodsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      mood: mood ?? this.mood,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('mood: $mood, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserTable user = $UserTable(this);
  late final $PromptsTable prompts = $PromptsTable(this);
  late final $RecordsTable records = $RecordsTable(this);
  late final $MoodsTable moods = $MoodsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    user,
    prompts,
    records,
    moods,
  ];
}

typedef $$UserTableCreateCompanionBuilder =
    UserCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> age,
    });
typedef $$UserTableUpdateCompanionBuilder =
    UserCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> age,
    });

final class $$UserTableReferences
    extends BaseReferences<_$AppDatabase, $UserTable, UserData> {
  $$UserTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecordsTable, List<Record>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(db.user.id, db.records.userId),
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserTableFilterComposer extends Composer<_$AppDatabase, $UserTable> {
  $$UserTableFilterComposer({
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

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserTableOrderingComposer extends Composer<_$AppDatabase, $UserTable> {
  $$UserTableOrderingComposer({
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

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTable> {
  $$UserTableAnnotationComposer({
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

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserTable,
          UserData,
          $$UserTableFilterComposer,
          $$UserTableOrderingComposer,
          $$UserTableAnnotationComposer,
          $$UserTableCreateCompanionBuilder,
          $$UserTableUpdateCompanionBuilder,
          (UserData, $$UserTableReferences),
          UserData,
          PrefetchHooks Function({bool recordsRefs})
        > {
  $$UserTableTableManager(_$AppDatabase db, $UserTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> age = const Value.absent(),
              }) => UserCompanion(id: id, name: name, age: age),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> age = const Value.absent(),
              }) => UserCompanion.insert(id: id, name: name, age: age),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UserTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({recordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recordsRefs) db.records],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recordsRefs)
                    await $_getPrefetchedData<UserData, $UserTable, Record>(
                      currentTable: table,
                      referencedTable: $$UserTableReferences._recordsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UserTableReferences(db, table, p0).recordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserTable,
      UserData,
      $$UserTableFilterComposer,
      $$UserTableOrderingComposer,
      $$UserTableAnnotationComposer,
      $$UserTableCreateCompanionBuilder,
      $$UserTableUpdateCompanionBuilder,
      (UserData, $$UserTableReferences),
      UserData,
      PrefetchHooks Function({bool recordsRefs})
    >;
typedef $$PromptsTableCreateCompanionBuilder =
    PromptsCompanion Function({Value<int> id, required String content});
typedef $$PromptsTableUpdateCompanionBuilder =
    PromptsCompanion Function({Value<int> id, Value<String> content});

final class $$PromptsTableReferences
    extends BaseReferences<_$AppDatabase, $PromptsTable, Prompt> {
  $$PromptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecordsTable, List<Record>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(db.prompts.id, db.records.promptId),
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.promptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PromptsTableFilterComposer
    extends Composer<_$AppDatabase, $PromptsTable> {
  $$PromptsTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.promptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PromptsTableOrderingComposer
    extends Composer<_$AppDatabase, $PromptsTable> {
  $$PromptsTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PromptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromptsTable> {
  $$PromptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.promptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PromptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromptsTable,
          Prompt,
          $$PromptsTableFilterComposer,
          $$PromptsTableOrderingComposer,
          $$PromptsTableAnnotationComposer,
          $$PromptsTableCreateCompanionBuilder,
          $$PromptsTableUpdateCompanionBuilder,
          (Prompt, $$PromptsTableReferences),
          Prompt,
          PrefetchHooks Function({bool recordsRefs})
        > {
  $$PromptsTableTableManager(_$AppDatabase db, $PromptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
              }) => PromptsCompanion(id: id, content: content),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
              }) => PromptsCompanion.insert(id: id, content: content),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PromptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recordsRefs) db.records],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recordsRefs)
                    await $_getPrefetchedData<Prompt, $PromptsTable, Record>(
                      currentTable: table,
                      referencedTable: $$PromptsTableReferences
                          ._recordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PromptsTableReferences(db, table, p0).recordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.promptId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PromptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromptsTable,
      Prompt,
      $$PromptsTableFilterComposer,
      $$PromptsTableOrderingComposer,
      $$PromptsTableAnnotationComposer,
      $$PromptsTableCreateCompanionBuilder,
      $$PromptsTableUpdateCompanionBuilder,
      (Prompt, $$PromptsTableReferences),
      Prompt,
      PrefetchHooks Function({bool recordsRefs})
    >;
typedef $$RecordsTableCreateCompanionBuilder =
    RecordsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<int?> promptId,
      Value<int> inputType,
      Value<int?> userId,
      Value<String?> title,
      Value<String?> content,
    });
typedef $$RecordsTableUpdateCompanionBuilder =
    RecordsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<int?> promptId,
      Value<int> inputType,
      Value<int?> userId,
      Value<String?> title,
      Value<String?> content,
    });

final class $$RecordsTableReferences
    extends BaseReferences<_$AppDatabase, $RecordsTable, Record> {
  $$RecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PromptsTable _promptIdTable(_$AppDatabase db) => db.prompts
      .createAlias($_aliasNameGenerator(db.records.promptId, db.prompts.id));

  $$PromptsTableProcessedTableManager? get promptId {
    final $_column = $_itemColumn<int>('prompt_id');
    if ($_column == null) return null;
    final manager = $$PromptsTableTableManager(
      $_db,
      $_db.prompts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_promptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UserTable _userIdTable(_$AppDatabase db) =>
      db.user.createAlias($_aliasNameGenerator(db.records.userId, db.user.id));

  $$UserTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UserTableTableManager(
      $_db,
      $_db.user,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MoodsTable, List<Mood>> _moodsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.moods,
    aliasName: $_aliasNameGenerator(db.records.id, db.moods.recordId),
  );

  $$MoodsTableProcessedTableManager get moodsRefs {
    final manager = $$MoodsTableTableManager(
      $_db,
      $_db.moods,
    ).filter((f) => f.recordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_moodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecordsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inputType => $composableBuilder(
    column: $table.inputType,
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

  $$PromptsTableFilterComposer get promptId {
    final $$PromptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promptId,
      referencedTable: $db.prompts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromptsTableFilterComposer(
            $db: $db,
            $table: $db.prompts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserTableFilterComposer get userId {
    final $$UserTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.user,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableFilterComposer(
            $db: $db,
            $table: $db.user,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> moodsRefs(
    Expression<bool> Function($$MoodsTableFilterComposer f) f,
  ) {
    final $$MoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moods,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodsTableFilterComposer(
            $db: $db,
            $table: $db.moods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inputType => $composableBuilder(
    column: $table.inputType,
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

  $$PromptsTableOrderingComposer get promptId {
    final $$PromptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promptId,
      referencedTable: $db.prompts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromptsTableOrderingComposer(
            $db: $db,
            $table: $db.prompts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserTableOrderingComposer get userId {
    final $$UserTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.user,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableOrderingComposer(
            $db: $db,
            $table: $db.user,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get inputType =>
      $composableBuilder(column: $table.inputType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $$PromptsTableAnnotationComposer get promptId {
    final $$PromptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promptId,
      referencedTable: $db.prompts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromptsTableAnnotationComposer(
            $db: $db,
            $table: $db.prompts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserTableAnnotationComposer get userId {
    final $$UserTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.user,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableAnnotationComposer(
            $db: $db,
            $table: $db.user,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> moodsRefs<T extends Object>(
    Expression<T> Function($$MoodsTableAnnotationComposer a) f,
  ) {
    final $$MoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moods,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.moods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordsTable,
          Record,
          $$RecordsTableFilterComposer,
          $$RecordsTableOrderingComposer,
          $$RecordsTableAnnotationComposer,
          $$RecordsTableCreateCompanionBuilder,
          $$RecordsTableUpdateCompanionBuilder,
          (Record, $$RecordsTableReferences),
          Record,
          PrefetchHooks Function({bool promptId, bool userId, bool moodsRefs})
        > {
  $$RecordsTableTableManager(_$AppDatabase db, $RecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> promptId = const Value.absent(),
                Value<int> inputType = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
              }) => RecordsCompanion(
                id: id,
                createdAt: createdAt,
                promptId: promptId,
                inputType: inputType,
                userId: userId,
                title: title,
                content: content,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> promptId = const Value.absent(),
                Value<int> inputType = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
              }) => RecordsCompanion.insert(
                id: id,
                createdAt: createdAt,
                promptId: promptId,
                inputType: inputType,
                userId: userId,
                title: title,
                content: content,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({promptId = false, userId = false, moodsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (moodsRefs) db.moods],
                  addJoins:
                      <
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
                        if (promptId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.promptId,
                                    referencedTable: $$RecordsTableReferences
                                        ._promptIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._promptIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable: $$RecordsTableReferences
                                        ._userIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._userIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (moodsRefs)
                        await $_getPrefetchedData<Record, $RecordsTable, Mood>(
                          currentTable: table,
                          referencedTable: $$RecordsTableReferences
                              ._moodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecordsTableReferences(db, table, p0).moodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordsTable,
      Record,
      $$RecordsTableFilterComposer,
      $$RecordsTableOrderingComposer,
      $$RecordsTableAnnotationComposer,
      $$RecordsTableCreateCompanionBuilder,
      $$RecordsTableUpdateCompanionBuilder,
      (Record, $$RecordsTableReferences),
      Record,
      PrefetchHooks Function({bool promptId, bool userId, bool moodsRefs})
    >;
typedef $$MoodsTableCreateCompanionBuilder =
    MoodsCompanion Function({
      Value<int> id,
      required int recordId,
      Value<int?> mood,
      Value<int> source,
    });
typedef $$MoodsTableUpdateCompanionBuilder =
    MoodsCompanion Function({
      Value<int> id,
      Value<int> recordId,
      Value<int?> mood,
      Value<int> source,
    });

final class $$MoodsTableReferences
    extends BaseReferences<_$AppDatabase, $MoodsTable, Mood> {
  $$MoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecordsTable _recordIdTable(_$AppDatabase db) => db.records
      .createAlias($_aliasNameGenerator(db.moods.recordId, db.records.id));

  $$RecordsTableProcessedTableManager get recordId {
    final $_column = $_itemColumn<int>('record_id')!;

    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodsTableFilterComposer extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableFilterComposer({
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

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  $$RecordsTableFilterComposer get recordId {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableOrderingComposer({
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

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecordsTableOrderingComposer get recordId {
    final $$RecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableOrderingComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$RecordsTableAnnotationComposer get recordId {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodsTable,
          Mood,
          $$MoodsTableFilterComposer,
          $$MoodsTableOrderingComposer,
          $$MoodsTableAnnotationComposer,
          $$MoodsTableCreateCompanionBuilder,
          $$MoodsTableUpdateCompanionBuilder,
          (Mood, $$MoodsTableReferences),
          Mood,
          PrefetchHooks Function({bool recordId})
        > {
  $$MoodsTableTableManager(_$AppDatabase db, $MoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recordId = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<int> source = const Value.absent(),
              }) => MoodsCompanion(
                id: id,
                recordId: recordId,
                mood: mood,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recordId,
                Value<int?> mood = const Value.absent(),
                Value<int> source = const Value.absent(),
              }) => MoodsCompanion.insert(
                id: id,
                recordId: recordId,
                mood: mood,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({recordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                    if (recordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recordId,
                                referencedTable: $$MoodsTableReferences
                                    ._recordIdTable(db),
                                referencedColumn: $$MoodsTableReferences
                                    ._recordIdTable(db)
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

typedef $$MoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodsTable,
      Mood,
      $$MoodsTableFilterComposer,
      $$MoodsTableOrderingComposer,
      $$MoodsTableAnnotationComposer,
      $$MoodsTableCreateCompanionBuilder,
      $$MoodsTableUpdateCompanionBuilder,
      (Mood, $$MoodsTableReferences),
      Mood,
      PrefetchHooks Function({bool recordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserTableTableManager get user => $$UserTableTableManager(_db, _db.user);
  $$PromptsTableTableManager get prompts =>
      $$PromptsTableTableManager(_db, _db.prompts);
  $$RecordsTableTableManager get records =>
      $$RecordsTableTableManager(_db, _db.records);
  $$MoodsTableTableManager get moods =>
      $$MoodsTableTableManager(_db, _db.moods);
}
