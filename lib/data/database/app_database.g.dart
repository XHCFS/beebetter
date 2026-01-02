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
  static const VerificationMeta _currentDifficultyLevelMeta =
      const VerificationMeta('currentDifficultyLevel');
  @override
  late final GeneratedColumn<int> currentDifficultyLevel = GeneratedColumn<int>(
    'current_difficulty_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _journalingStreakMeta = const VerificationMeta(
    'journalingStreak',
  );
  @override
  late final GeneratedColumn<int> journalingStreak = GeneratedColumn<int>(
    'journaling_streak',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredCategoriesMeta =
      const VerificationMeta('preferredCategories');
  @override
  late final GeneratedColumn<String> preferredCategories =
      GeneratedColumn<String>(
        'preferred_categories',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastDifficultyAdjustmentMeta =
      const VerificationMeta('lastDifficultyAdjustment');
  @override
  late final GeneratedColumn<DateTime> lastDifficultyAdjustment =
      GeneratedColumn<DateTime>(
        'last_difficulty_adjustment',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    currentDifficultyLevel,
    journalingStreak,
    preferredCategories,
    lastDifficultyAdjustment,
  ];
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
    if (data.containsKey('current_difficulty_level')) {
      context.handle(
        _currentDifficultyLevelMeta,
        currentDifficultyLevel.isAcceptableOrUnknown(
          data['current_difficulty_level']!,
          _currentDifficultyLevelMeta,
        ),
      );
    }
    if (data.containsKey('journaling_streak')) {
      context.handle(
        _journalingStreakMeta,
        journalingStreak.isAcceptableOrUnknown(
          data['journaling_streak']!,
          _journalingStreakMeta,
        ),
      );
    }
    if (data.containsKey('preferred_categories')) {
      context.handle(
        _preferredCategoriesMeta,
        preferredCategories.isAcceptableOrUnknown(
          data['preferred_categories']!,
          _preferredCategoriesMeta,
        ),
      );
    }
    if (data.containsKey('last_difficulty_adjustment')) {
      context.handle(
        _lastDifficultyAdjustmentMeta,
        lastDifficultyAdjustment.isAcceptableOrUnknown(
          data['last_difficulty_adjustment']!,
          _lastDifficultyAdjustmentMeta,
        ),
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
      currentDifficultyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_difficulty_level'],
      ),
      journalingStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journaling_streak'],
      ),
      preferredCategories: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_categories'],
      ),
      lastDifficultyAdjustment: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_difficulty_adjustment'],
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
  final int? currentDifficultyLevel;
  final int? journalingStreak;
  final String? preferredCategories;
  final DateTime? lastDifficultyAdjustment;
  const UserData({
    required this.id,
    required this.name,
    this.age,
    this.currentDifficultyLevel,
    this.journalingStreak,
    this.preferredCategories,
    this.lastDifficultyAdjustment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || currentDifficultyLevel != null) {
      map['current_difficulty_level'] = Variable<int>(currentDifficultyLevel);
    }
    if (!nullToAbsent || journalingStreak != null) {
      map['journaling_streak'] = Variable<int>(journalingStreak);
    }
    if (!nullToAbsent || preferredCategories != null) {
      map['preferred_categories'] = Variable<String>(preferredCategories);
    }
    if (!nullToAbsent || lastDifficultyAdjustment != null) {
      map['last_difficulty_adjustment'] = Variable<DateTime>(
        lastDifficultyAdjustment,
      );
    }
    return map;
  }

  UserCompanion toCompanion(bool nullToAbsent) {
    return UserCompanion(
      id: Value(id),
      name: Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      currentDifficultyLevel: currentDifficultyLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(currentDifficultyLevel),
      journalingStreak: journalingStreak == null && nullToAbsent
          ? const Value.absent()
          : Value(journalingStreak),
      preferredCategories: preferredCategories == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredCategories),
      lastDifficultyAdjustment: lastDifficultyAdjustment == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDifficultyAdjustment),
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
      currentDifficultyLevel: serializer.fromJson<int?>(
        json['currentDifficultyLevel'],
      ),
      journalingStreak: serializer.fromJson<int?>(json['journalingStreak']),
      preferredCategories: serializer.fromJson<String?>(
        json['preferredCategories'],
      ),
      lastDifficultyAdjustment: serializer.fromJson<DateTime?>(
        json['lastDifficultyAdjustment'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int?>(age),
      'currentDifficultyLevel': serializer.toJson<int?>(currentDifficultyLevel),
      'journalingStreak': serializer.toJson<int?>(journalingStreak),
      'preferredCategories': serializer.toJson<String?>(preferredCategories),
      'lastDifficultyAdjustment': serializer.toJson<DateTime?>(
        lastDifficultyAdjustment,
      ),
    };
  }

  UserData copyWith({
    int? id,
    String? name,
    Value<int?> age = const Value.absent(),
    Value<int?> currentDifficultyLevel = const Value.absent(),
    Value<int?> journalingStreak = const Value.absent(),
    Value<String?> preferredCategories = const Value.absent(),
    Value<DateTime?> lastDifficultyAdjustment = const Value.absent(),
  }) => UserData(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age.present ? age.value : this.age,
    currentDifficultyLevel: currentDifficultyLevel.present
        ? currentDifficultyLevel.value
        : this.currentDifficultyLevel,
    journalingStreak: journalingStreak.present
        ? journalingStreak.value
        : this.journalingStreak,
    preferredCategories: preferredCategories.present
        ? preferredCategories.value
        : this.preferredCategories,
    lastDifficultyAdjustment: lastDifficultyAdjustment.present
        ? lastDifficultyAdjustment.value
        : this.lastDifficultyAdjustment,
  );
  UserData copyWithCompanion(UserCompanion data) {
    return UserData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      currentDifficultyLevel: data.currentDifficultyLevel.present
          ? data.currentDifficultyLevel.value
          : this.currentDifficultyLevel,
      journalingStreak: data.journalingStreak.present
          ? data.journalingStreak.value
          : this.journalingStreak,
      preferredCategories: data.preferredCategories.present
          ? data.preferredCategories.value
          : this.preferredCategories,
      lastDifficultyAdjustment: data.lastDifficultyAdjustment.present
          ? data.lastDifficultyAdjustment.value
          : this.lastDifficultyAdjustment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('currentDifficultyLevel: $currentDifficultyLevel, ')
          ..write('journalingStreak: $journalingStreak, ')
          ..write('preferredCategories: $preferredCategories, ')
          ..write('lastDifficultyAdjustment: $lastDifficultyAdjustment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    age,
    currentDifficultyLevel,
    journalingStreak,
    preferredCategories,
    lastDifficultyAdjustment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.currentDifficultyLevel == this.currentDifficultyLevel &&
          other.journalingStreak == this.journalingStreak &&
          other.preferredCategories == this.preferredCategories &&
          other.lastDifficultyAdjustment == this.lastDifficultyAdjustment);
}

class UserCompanion extends UpdateCompanion<UserData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> age;
  final Value<int?> currentDifficultyLevel;
  final Value<int?> journalingStreak;
  final Value<String?> preferredCategories;
  final Value<DateTime?> lastDifficultyAdjustment;
  const UserCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.currentDifficultyLevel = const Value.absent(),
    this.journalingStreak = const Value.absent(),
    this.preferredCategories = const Value.absent(),
    this.lastDifficultyAdjustment = const Value.absent(),
  });
  UserCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.age = const Value.absent(),
    this.currentDifficultyLevel = const Value.absent(),
    this.journalingStreak = const Value.absent(),
    this.preferredCategories = const Value.absent(),
    this.lastDifficultyAdjustment = const Value.absent(),
  }) : name = Value(name);
  static Insertable<UserData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<int>? currentDifficultyLevel,
    Expression<int>? journalingStreak,
    Expression<String>? preferredCategories,
    Expression<DateTime>? lastDifficultyAdjustment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (currentDifficultyLevel != null)
        'current_difficulty_level': currentDifficultyLevel,
      if (journalingStreak != null) 'journaling_streak': journalingStreak,
      if (preferredCategories != null)
        'preferred_categories': preferredCategories,
      if (lastDifficultyAdjustment != null)
        'last_difficulty_adjustment': lastDifficultyAdjustment,
    });
  }

  UserCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? age,
    Value<int?>? currentDifficultyLevel,
    Value<int?>? journalingStreak,
    Value<String?>? preferredCategories,
    Value<DateTime?>? lastDifficultyAdjustment,
  }) {
    return UserCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      currentDifficultyLevel:
          currentDifficultyLevel ?? this.currentDifficultyLevel,
      journalingStreak: journalingStreak ?? this.journalingStreak,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      lastDifficultyAdjustment:
          lastDifficultyAdjustment ?? this.lastDifficultyAdjustment,
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
    if (currentDifficultyLevel.present) {
      map['current_difficulty_level'] = Variable<int>(
        currentDifficultyLevel.value,
      );
    }
    if (journalingStreak.present) {
      map['journaling_streak'] = Variable<int>(journalingStreak.value);
    }
    if (preferredCategories.present) {
      map['preferred_categories'] = Variable<String>(preferredCategories.value);
    }
    if (lastDifficultyAdjustment.present) {
      map['last_difficulty_adjustment'] = Variable<DateTime>(
        lastDifficultyAdjustment.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('currentDifficultyLevel: $currentDifficultyLevel, ')
          ..write('journalingStreak: $journalingStreak, ')
          ..write('preferredCategories: $preferredCategories, ')
          ..write('lastDifficultyAdjustment: $lastDifficultyAdjustment')
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
  static const VerificationMeta _therapeuticFrameworkMeta =
      const VerificationMeta('therapeuticFramework');
  @override
  late final GeneratedColumn<String> therapeuticFramework =
      GeneratedColumn<String>(
        'therapeutic_framework',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _difficultyLevelMeta = const VerificationMeta(
    'difficultyLevel',
  );
  @override
  late final GeneratedColumn<int> difficultyLevel = GeneratedColumn<int>(
    'difficulty_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetMoodStatesMeta = const VerificationMeta(
    'targetMoodStates',
  );
  @override
  late final GeneratedColumn<String> targetMoodStates = GeneratedColumn<String>(
    'target_mood_states',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestTimeOfDayMeta = const VerificationMeta(
    'bestTimeOfDay',
  );
  @override
  late final GeneratedColumn<String> bestTimeOfDay = GeneratedColumn<String>(
    'best_time_of_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceCitationMeta = const VerificationMeta(
    'sourceCitation',
  );
  @override
  late final GeneratedColumn<String> sourceCitation = GeneratedColumn<String>(
    'source_citation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    therapeuticFramework,
    difficultyLevel,
    category,
    targetMoodStates,
    bestTimeOfDay,
    tags,
    sourceCitation,
    isActive,
  ];
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
    if (data.containsKey('therapeutic_framework')) {
      context.handle(
        _therapeuticFrameworkMeta,
        therapeuticFramework.isAcceptableOrUnknown(
          data['therapeutic_framework']!,
          _therapeuticFrameworkMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_therapeuticFrameworkMeta);
    }
    if (data.containsKey('difficulty_level')) {
      context.handle(
        _difficultyLevelMeta,
        difficultyLevel.isAcceptableOrUnknown(
          data['difficulty_level']!,
          _difficultyLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_difficultyLevelMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('target_mood_states')) {
      context.handle(
        _targetMoodStatesMeta,
        targetMoodStates.isAcceptableOrUnknown(
          data['target_mood_states']!,
          _targetMoodStatesMeta,
        ),
      );
    }
    if (data.containsKey('best_time_of_day')) {
      context.handle(
        _bestTimeOfDayMeta,
        bestTimeOfDay.isAcceptableOrUnknown(
          data['best_time_of_day']!,
          _bestTimeOfDayMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('source_citation')) {
      context.handle(
        _sourceCitationMeta,
        sourceCitation.isAcceptableOrUnknown(
          data['source_citation']!,
          _sourceCitationMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
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
      therapeuticFramework: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}therapeutic_framework'],
      )!,
      difficultyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty_level'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      targetMoodStates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_mood_states'],
      ),
      bestTimeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}best_time_of_day'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      sourceCitation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_citation'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  final String therapeuticFramework;
  final int difficultyLevel;
  final String? category;
  final String? targetMoodStates;
  final String? bestTimeOfDay;
  final String? tags;
  final String? sourceCitation;
  final bool isActive;
  const Prompt({
    required this.id,
    required this.content,
    required this.therapeuticFramework,
    required this.difficultyLevel,
    this.category,
    this.targetMoodStates,
    this.bestTimeOfDay,
    this.tags,
    this.sourceCitation,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['therapeutic_framework'] = Variable<String>(therapeuticFramework);
    map['difficulty_level'] = Variable<int>(difficultyLevel);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || targetMoodStates != null) {
      map['target_mood_states'] = Variable<String>(targetMoodStates);
    }
    if (!nullToAbsent || bestTimeOfDay != null) {
      map['best_time_of_day'] = Variable<String>(bestTimeOfDay);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || sourceCitation != null) {
      map['source_citation'] = Variable<String>(sourceCitation);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PromptsCompanion toCompanion(bool nullToAbsent) {
    return PromptsCompanion(
      id: Value(id),
      content: Value(content),
      therapeuticFramework: Value(therapeuticFramework),
      difficultyLevel: Value(difficultyLevel),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      targetMoodStates: targetMoodStates == null && nullToAbsent
          ? const Value.absent()
          : Value(targetMoodStates),
      bestTimeOfDay: bestTimeOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(bestTimeOfDay),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      sourceCitation: sourceCitation == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceCitation),
      isActive: Value(isActive),
    );
  }

  factory Prompt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prompt(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      therapeuticFramework: serializer.fromJson<String>(
        json['therapeuticFramework'],
      ),
      difficultyLevel: serializer.fromJson<int>(json['difficultyLevel']),
      category: serializer.fromJson<String?>(json['category']),
      targetMoodStates: serializer.fromJson<String?>(json['targetMoodStates']),
      bestTimeOfDay: serializer.fromJson<String?>(json['bestTimeOfDay']),
      tags: serializer.fromJson<String?>(json['tags']),
      sourceCitation: serializer.fromJson<String?>(json['sourceCitation']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'therapeuticFramework': serializer.toJson<String>(therapeuticFramework),
      'difficultyLevel': serializer.toJson<int>(difficultyLevel),
      'category': serializer.toJson<String?>(category),
      'targetMoodStates': serializer.toJson<String?>(targetMoodStates),
      'bestTimeOfDay': serializer.toJson<String?>(bestTimeOfDay),
      'tags': serializer.toJson<String?>(tags),
      'sourceCitation': serializer.toJson<String?>(sourceCitation),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Prompt copyWith({
    int? id,
    String? content,
    String? therapeuticFramework,
    int? difficultyLevel,
    Value<String?> category = const Value.absent(),
    Value<String?> targetMoodStates = const Value.absent(),
    Value<String?> bestTimeOfDay = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> sourceCitation = const Value.absent(),
    bool? isActive,
  }) => Prompt(
    id: id ?? this.id,
    content: content ?? this.content,
    therapeuticFramework: therapeuticFramework ?? this.therapeuticFramework,
    difficultyLevel: difficultyLevel ?? this.difficultyLevel,
    category: category.present ? category.value : this.category,
    targetMoodStates: targetMoodStates.present
        ? targetMoodStates.value
        : this.targetMoodStates,
    bestTimeOfDay: bestTimeOfDay.present
        ? bestTimeOfDay.value
        : this.bestTimeOfDay,
    tags: tags.present ? tags.value : this.tags,
    sourceCitation: sourceCitation.present
        ? sourceCitation.value
        : this.sourceCitation,
    isActive: isActive ?? this.isActive,
  );
  Prompt copyWithCompanion(PromptsCompanion data) {
    return Prompt(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      therapeuticFramework: data.therapeuticFramework.present
          ? data.therapeuticFramework.value
          : this.therapeuticFramework,
      difficultyLevel: data.difficultyLevel.present
          ? data.difficultyLevel.value
          : this.difficultyLevel,
      category: data.category.present ? data.category.value : this.category,
      targetMoodStates: data.targetMoodStates.present
          ? data.targetMoodStates.value
          : this.targetMoodStates,
      bestTimeOfDay: data.bestTimeOfDay.present
          ? data.bestTimeOfDay.value
          : this.bestTimeOfDay,
      tags: data.tags.present ? data.tags.value : this.tags,
      sourceCitation: data.sourceCitation.present
          ? data.sourceCitation.value
          : this.sourceCitation,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prompt(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('therapeuticFramework: $therapeuticFramework, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('category: $category, ')
          ..write('targetMoodStates: $targetMoodStates, ')
          ..write('bestTimeOfDay: $bestTimeOfDay, ')
          ..write('tags: $tags, ')
          ..write('sourceCitation: $sourceCitation, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    therapeuticFramework,
    difficultyLevel,
    category,
    targetMoodStates,
    bestTimeOfDay,
    tags,
    sourceCitation,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prompt &&
          other.id == this.id &&
          other.content == this.content &&
          other.therapeuticFramework == this.therapeuticFramework &&
          other.difficultyLevel == this.difficultyLevel &&
          other.category == this.category &&
          other.targetMoodStates == this.targetMoodStates &&
          other.bestTimeOfDay == this.bestTimeOfDay &&
          other.tags == this.tags &&
          other.sourceCitation == this.sourceCitation &&
          other.isActive == this.isActive);
}

class PromptsCompanion extends UpdateCompanion<Prompt> {
  final Value<int> id;
  final Value<String> content;
  final Value<String> therapeuticFramework;
  final Value<int> difficultyLevel;
  final Value<String?> category;
  final Value<String?> targetMoodStates;
  final Value<String?> bestTimeOfDay;
  final Value<String?> tags;
  final Value<String?> sourceCitation;
  final Value<bool> isActive;
  const PromptsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.therapeuticFramework = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.category = const Value.absent(),
    this.targetMoodStates = const Value.absent(),
    this.bestTimeOfDay = const Value.absent(),
    this.tags = const Value.absent(),
    this.sourceCitation = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  PromptsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required String therapeuticFramework,
    required int difficultyLevel,
    this.category = const Value.absent(),
    this.targetMoodStates = const Value.absent(),
    this.bestTimeOfDay = const Value.absent(),
    this.tags = const Value.absent(),
    this.sourceCitation = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : content = Value(content),
       therapeuticFramework = Value(therapeuticFramework),
       difficultyLevel = Value(difficultyLevel);
  static Insertable<Prompt> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? therapeuticFramework,
    Expression<int>? difficultyLevel,
    Expression<String>? category,
    Expression<String>? targetMoodStates,
    Expression<String>? bestTimeOfDay,
    Expression<String>? tags,
    Expression<String>? sourceCitation,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (therapeuticFramework != null)
        'therapeutic_framework': therapeuticFramework,
      if (difficultyLevel != null) 'difficulty_level': difficultyLevel,
      if (category != null) 'category': category,
      if (targetMoodStates != null) 'target_mood_states': targetMoodStates,
      if (bestTimeOfDay != null) 'best_time_of_day': bestTimeOfDay,
      if (tags != null) 'tags': tags,
      if (sourceCitation != null) 'source_citation': sourceCitation,
      if (isActive != null) 'is_active': isActive,
    });
  }

  PromptsCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String>? therapeuticFramework,
    Value<int>? difficultyLevel,
    Value<String?>? category,
    Value<String?>? targetMoodStates,
    Value<String?>? bestTimeOfDay,
    Value<String?>? tags,
    Value<String?>? sourceCitation,
    Value<bool>? isActive,
  }) {
    return PromptsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      therapeuticFramework: therapeuticFramework ?? this.therapeuticFramework,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      category: category ?? this.category,
      targetMoodStates: targetMoodStates ?? this.targetMoodStates,
      bestTimeOfDay: bestTimeOfDay ?? this.bestTimeOfDay,
      tags: tags ?? this.tags,
      sourceCitation: sourceCitation ?? this.sourceCitation,
      isActive: isActive ?? this.isActive,
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
    if (therapeuticFramework.present) {
      map['therapeutic_framework'] = Variable<String>(
        therapeuticFramework.value,
      );
    }
    if (difficultyLevel.present) {
      map['difficulty_level'] = Variable<int>(difficultyLevel.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetMoodStates.present) {
      map['target_mood_states'] = Variable<String>(targetMoodStates.value);
    }
    if (bestTimeOfDay.present) {
      map['best_time_of_day'] = Variable<String>(bestTimeOfDay.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (sourceCitation.present) {
      map['source_citation'] = Variable<String>(sourceCitation.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromptsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('therapeuticFramework: $therapeuticFramework, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('category: $category, ')
          ..write('targetMoodStates: $targetMoodStates, ')
          ..write('bestTimeOfDay: $bestTimeOfDay, ')
          ..write('tags: $tags, ')
          ..write('sourceCitation: $sourceCitation, ')
          ..write('isActive: $isActive')
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

class $PromptInteractionsTable extends PromptInteractions
    with TableInfo<$PromptInteractionsTable, PromptInteraction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromptInteractionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user (id)',
    ),
  );
  static const VerificationMeta _promptIdMeta = const VerificationMeta(
    'promptId',
  );
  @override
  late final GeneratedColumn<int> promptId = GeneratedColumn<int>(
    'prompt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prompts (id)',
    ),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    promptId,
    completed,
    skipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prompt_interactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromptInteraction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('prompt_id')) {
      context.handle(
        _promptIdMeta,
        promptId.isAcceptableOrUnknown(data['prompt_id']!, _promptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_promptIdMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    } else if (isInserting) {
      context.missing(_skippedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromptInteraction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromptInteraction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      promptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prompt_id'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
    );
  }

  @override
  $PromptInteractionsTable createAlias(String alias) {
    return $PromptInteractionsTable(attachedDatabase, alias);
  }
}

class PromptInteraction extends DataClass
    implements Insertable<PromptInteraction> {
  final int id;
  final int userId;
  final int promptId;
  final bool completed;
  final bool skipped;
  const PromptInteraction({
    required this.id,
    required this.userId,
    required this.promptId,
    required this.completed,
    required this.skipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['prompt_id'] = Variable<int>(promptId);
    map['completed'] = Variable<bool>(completed);
    map['skipped'] = Variable<bool>(skipped);
    return map;
  }

  PromptInteractionsCompanion toCompanion(bool nullToAbsent) {
    return PromptInteractionsCompanion(
      id: Value(id),
      userId: Value(userId),
      promptId: Value(promptId),
      completed: Value(completed),
      skipped: Value(skipped),
    );
  }

  factory PromptInteraction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromptInteraction(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      promptId: serializer.fromJson<int>(json['promptId']),
      completed: serializer.fromJson<bool>(json['completed']),
      skipped: serializer.fromJson<bool>(json['skipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'promptId': serializer.toJson<int>(promptId),
      'completed': serializer.toJson<bool>(completed),
      'skipped': serializer.toJson<bool>(skipped),
    };
  }

  PromptInteraction copyWith({
    int? id,
    int? userId,
    int? promptId,
    bool? completed,
    bool? skipped,
  }) => PromptInteraction(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    promptId: promptId ?? this.promptId,
    completed: completed ?? this.completed,
    skipped: skipped ?? this.skipped,
  );
  PromptInteraction copyWithCompanion(PromptInteractionsCompanion data) {
    return PromptInteraction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      promptId: data.promptId.present ? data.promptId.value : this.promptId,
      completed: data.completed.present ? data.completed.value : this.completed,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromptInteraction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('promptId: $promptId, ')
          ..write('completed: $completed, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, promptId, completed, skipped);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromptInteraction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.promptId == this.promptId &&
          other.completed == this.completed &&
          other.skipped == this.skipped);
}

class PromptInteractionsCompanion extends UpdateCompanion<PromptInteraction> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> promptId;
  final Value<bool> completed;
  final Value<bool> skipped;
  const PromptInteractionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.promptId = const Value.absent(),
    this.completed = const Value.absent(),
    this.skipped = const Value.absent(),
  });
  PromptInteractionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int promptId,
    required bool completed,
    required bool skipped,
  }) : userId = Value(userId),
       promptId = Value(promptId),
       completed = Value(completed),
       skipped = Value(skipped);
  static Insertable<PromptInteraction> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? promptId,
    Expression<bool>? completed,
    Expression<bool>? skipped,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (promptId != null) 'prompt_id': promptId,
      if (completed != null) 'completed': completed,
      if (skipped != null) 'skipped': skipped,
    });
  }

  PromptInteractionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? promptId,
    Value<bool>? completed,
    Value<bool>? skipped,
  }) {
    return PromptInteractionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      promptId: promptId ?? this.promptId,
      completed: completed ?? this.completed,
      skipped: skipped ?? this.skipped,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (promptId.present) {
      map['prompt_id'] = Variable<int>(promptId.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromptInteractionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('promptId: $promptId, ')
          ..write('completed: $completed, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }
}

class $UserAvoidedPromptsTable extends UserAvoidedPrompts
    with TableInfo<$UserAvoidedPromptsTable, UserAvoidedPrompt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserAvoidedPromptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user (id)',
    ),
  );
  static const VerificationMeta _promptIdMeta = const VerificationMeta(
    'promptId',
  );
  @override
  late final GeneratedColumn<int> promptId = GeneratedColumn<int>(
    'prompt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prompts (id)',
    ),
  );
  static const VerificationMeta _avoidedAtMeta = const VerificationMeta(
    'avoidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> avoidedAt = GeneratedColumn<DateTime>(
    'avoided_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, promptId, avoidedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_avoided_prompts';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserAvoidedPrompt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('prompt_id')) {
      context.handle(
        _promptIdMeta,
        promptId.isAcceptableOrUnknown(data['prompt_id']!, _promptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_promptIdMeta);
    }
    if (data.containsKey('avoided_at')) {
      context.handle(
        _avoidedAtMeta,
        avoidedAt.isAcceptableOrUnknown(data['avoided_at']!, _avoidedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, promptId};
  @override
  UserAvoidedPrompt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserAvoidedPrompt(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      promptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prompt_id'],
      )!,
      avoidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}avoided_at'],
      )!,
    );
  }

  @override
  $UserAvoidedPromptsTable createAlias(String alias) {
    return $UserAvoidedPromptsTable(attachedDatabase, alias);
  }
}

class UserAvoidedPrompt extends DataClass
    implements Insertable<UserAvoidedPrompt> {
  final int userId;
  final int promptId;
  final DateTime avoidedAt;
  const UserAvoidedPrompt({
    required this.userId,
    required this.promptId,
    required this.avoidedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['prompt_id'] = Variable<int>(promptId);
    map['avoided_at'] = Variable<DateTime>(avoidedAt);
    return map;
  }

  UserAvoidedPromptsCompanion toCompanion(bool nullToAbsent) {
    return UserAvoidedPromptsCompanion(
      userId: Value(userId),
      promptId: Value(promptId),
      avoidedAt: Value(avoidedAt),
    );
  }

  factory UserAvoidedPrompt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserAvoidedPrompt(
      userId: serializer.fromJson<int>(json['userId']),
      promptId: serializer.fromJson<int>(json['promptId']),
      avoidedAt: serializer.fromJson<DateTime>(json['avoidedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'promptId': serializer.toJson<int>(promptId),
      'avoidedAt': serializer.toJson<DateTime>(avoidedAt),
    };
  }

  UserAvoidedPrompt copyWith({
    int? userId,
    int? promptId,
    DateTime? avoidedAt,
  }) => UserAvoidedPrompt(
    userId: userId ?? this.userId,
    promptId: promptId ?? this.promptId,
    avoidedAt: avoidedAt ?? this.avoidedAt,
  );
  UserAvoidedPrompt copyWithCompanion(UserAvoidedPromptsCompanion data) {
    return UserAvoidedPrompt(
      userId: data.userId.present ? data.userId.value : this.userId,
      promptId: data.promptId.present ? data.promptId.value : this.promptId,
      avoidedAt: data.avoidedAt.present ? data.avoidedAt.value : this.avoidedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserAvoidedPrompt(')
          ..write('userId: $userId, ')
          ..write('promptId: $promptId, ')
          ..write('avoidedAt: $avoidedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, promptId, avoidedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserAvoidedPrompt &&
          other.userId == this.userId &&
          other.promptId == this.promptId &&
          other.avoidedAt == this.avoidedAt);
}

class UserAvoidedPromptsCompanion extends UpdateCompanion<UserAvoidedPrompt> {
  final Value<int> userId;
  final Value<int> promptId;
  final Value<DateTime> avoidedAt;
  final Value<int> rowid;
  const UserAvoidedPromptsCompanion({
    this.userId = const Value.absent(),
    this.promptId = const Value.absent(),
    this.avoidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserAvoidedPromptsCompanion.insert({
    required int userId,
    required int promptId,
    this.avoidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       promptId = Value(promptId);
  static Insertable<UserAvoidedPrompt> custom({
    Expression<int>? userId,
    Expression<int>? promptId,
    Expression<DateTime>? avoidedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (promptId != null) 'prompt_id': promptId,
      if (avoidedAt != null) 'avoided_at': avoidedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserAvoidedPromptsCompanion copyWith({
    Value<int>? userId,
    Value<int>? promptId,
    Value<DateTime>? avoidedAt,
    Value<int>? rowid,
  }) {
    return UserAvoidedPromptsCompanion(
      userId: userId ?? this.userId,
      promptId: promptId ?? this.promptId,
      avoidedAt: avoidedAt ?? this.avoidedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (promptId.present) {
      map['prompt_id'] = Variable<int>(promptId.value);
    }
    if (avoidedAt.present) {
      map['avoided_at'] = Variable<DateTime>(avoidedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserAvoidedPromptsCompanion(')
          ..write('userId: $userId, ')
          ..write('promptId: $promptId, ')
          ..write('avoidedAt: $avoidedAt, ')
          ..write('rowid: $rowid')
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
  late final $PromptInteractionsTable promptInteractions =
      $PromptInteractionsTable(this);
  late final $UserAvoidedPromptsTable userAvoidedPrompts =
      $UserAvoidedPromptsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    user,
    prompts,
    records,
    moods,
    promptInteractions,
    userAvoidedPrompts,
  ];
}

typedef $$UserTableCreateCompanionBuilder =
    UserCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> age,
      Value<int?> currentDifficultyLevel,
      Value<int?> journalingStreak,
      Value<String?> preferredCategories,
      Value<DateTime?> lastDifficultyAdjustment,
    });
typedef $$UserTableUpdateCompanionBuilder =
    UserCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> age,
      Value<int?> currentDifficultyLevel,
      Value<int?> journalingStreak,
      Value<String?> preferredCategories,
      Value<DateTime?> lastDifficultyAdjustment,
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

  static MultiTypedResultKey<$PromptInteractionsTable, List<PromptInteraction>>
  _promptInteractionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.promptInteractions,
        aliasName: $_aliasNameGenerator(
          db.user.id,
          db.promptInteractions.userId,
        ),
      );

  $$PromptInteractionsTableProcessedTableManager get promptInteractionsRefs {
    final manager = $$PromptInteractionsTableTableManager(
      $_db,
      $_db.promptInteractions,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _promptInteractionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserAvoidedPromptsTable, List<UserAvoidedPrompt>>
  _userAvoidedPromptsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userAvoidedPrompts,
        aliasName: $_aliasNameGenerator(
          db.user.id,
          db.userAvoidedPrompts.userId,
        ),
      );

  $$UserAvoidedPromptsTableProcessedTableManager get userAvoidedPromptsRefs {
    final manager = $$UserAvoidedPromptsTableTableManager(
      $_db,
      $_db.userAvoidedPrompts,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userAvoidedPromptsRefsTable($_db),
    );
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

  ColumnFilters<int> get currentDifficultyLevel => $composableBuilder(
    column: $table.currentDifficultyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalingStreak => $composableBuilder(
    column: $table.journalingStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredCategories => $composableBuilder(
    column: $table.preferredCategories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastDifficultyAdjustment => $composableBuilder(
    column: $table.lastDifficultyAdjustment,
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

  Expression<bool> promptInteractionsRefs(
    Expression<bool> Function($$PromptInteractionsTableFilterComposer f) f,
  ) {
    final $$PromptInteractionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promptInteractions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromptInteractionsTableFilterComposer(
            $db: $db,
            $table: $db.promptInteractions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userAvoidedPromptsRefs(
    Expression<bool> Function($$UserAvoidedPromptsTableFilterComposer f) f,
  ) {
    final $$UserAvoidedPromptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAvoidedPrompts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAvoidedPromptsTableFilterComposer(
            $db: $db,
            $table: $db.userAvoidedPrompts,
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

  ColumnOrderings<int> get currentDifficultyLevel => $composableBuilder(
    column: $table.currentDifficultyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalingStreak => $composableBuilder(
    column: $table.journalingStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredCategories => $composableBuilder(
    column: $table.preferredCategories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDifficultyAdjustment => $composableBuilder(
    column: $table.lastDifficultyAdjustment,
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

  GeneratedColumn<int> get currentDifficultyLevel => $composableBuilder(
    column: $table.currentDifficultyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get journalingStreak => $composableBuilder(
    column: $table.journalingStreak,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredCategories => $composableBuilder(
    column: $table.preferredCategories,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastDifficultyAdjustment => $composableBuilder(
    column: $table.lastDifficultyAdjustment,
    builder: (column) => column,
  );

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

  Expression<T> promptInteractionsRefs<T extends Object>(
    Expression<T> Function($$PromptInteractionsTableAnnotationComposer a) f,
  ) {
    final $$PromptInteractionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.promptInteractions,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PromptInteractionsTableAnnotationComposer(
                $db: $db,
                $table: $db.promptInteractions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> userAvoidedPromptsRefs<T extends Object>(
    Expression<T> Function($$UserAvoidedPromptsTableAnnotationComposer a) f,
  ) {
    final $$UserAvoidedPromptsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userAvoidedPrompts,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserAvoidedPromptsTableAnnotationComposer(
                $db: $db,
                $table: $db.userAvoidedPrompts,
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
          PrefetchHooks Function({
            bool recordsRefs,
            bool promptInteractionsRefs,
            bool userAvoidedPromptsRefs,
          })
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
                Value<int?> currentDifficultyLevel = const Value.absent(),
                Value<int?> journalingStreak = const Value.absent(),
                Value<String?> preferredCategories = const Value.absent(),
                Value<DateTime?> lastDifficultyAdjustment =
                    const Value.absent(),
              }) => UserCompanion(
                id: id,
                name: name,
                age: age,
                currentDifficultyLevel: currentDifficultyLevel,
                journalingStreak: journalingStreak,
                preferredCategories: preferredCategories,
                lastDifficultyAdjustment: lastDifficultyAdjustment,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> age = const Value.absent(),
                Value<int?> currentDifficultyLevel = const Value.absent(),
                Value<int?> journalingStreak = const Value.absent(),
                Value<String?> preferredCategories = const Value.absent(),
                Value<DateTime?> lastDifficultyAdjustment =
                    const Value.absent(),
              }) => UserCompanion.insert(
                id: id,
                name: name,
                age: age,
                currentDifficultyLevel: currentDifficultyLevel,
                journalingStreak: journalingStreak,
                preferredCategories: preferredCategories,
                lastDifficultyAdjustment: lastDifficultyAdjustment,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UserTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recordsRefs = false,
                promptInteractionsRefs = false,
                userAvoidedPromptsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recordsRefs) db.records,
                    if (promptInteractionsRefs) db.promptInteractions,
                    if (userAvoidedPromptsRefs) db.userAvoidedPrompts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recordsRefs)
                        await $_getPrefetchedData<UserData, $UserTable, Record>(
                          currentTable: table,
                          referencedTable: $$UserTableReferences
                              ._recordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserTableReferences(db, table, p0).recordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (promptInteractionsRefs)
                        await $_getPrefetchedData<
                          UserData,
                          $UserTable,
                          PromptInteraction
                        >(
                          currentTable: table,
                          referencedTable: $$UserTableReferences
                              ._promptInteractionsRefsTable(db),
                          managerFromTypedResult: (p0) => $$UserTableReferences(
                            db,
                            table,
                            p0,
                          ).promptInteractionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userAvoidedPromptsRefs)
                        await $_getPrefetchedData<
                          UserData,
                          $UserTable,
                          UserAvoidedPrompt
                        >(
                          currentTable: table,
                          referencedTable: $$UserTableReferences
                              ._userAvoidedPromptsRefsTable(db),
                          managerFromTypedResult: (p0) => $$UserTableReferences(
                            db,
                            table,
                            p0,
                          ).userAvoidedPromptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
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
      PrefetchHooks Function({
        bool recordsRefs,
        bool promptInteractionsRefs,
        bool userAvoidedPromptsRefs,
      })
    >;
typedef $$PromptsTableCreateCompanionBuilder =
    PromptsCompanion Function({
      Value<int> id,
      required String content,
      required String therapeuticFramework,
      required int difficultyLevel,
      Value<String?> category,
      Value<String?> targetMoodStates,
      Value<String?> bestTimeOfDay,
      Value<String?> tags,
      Value<String?> sourceCitation,
      Value<bool> isActive,
    });
typedef $$PromptsTableUpdateCompanionBuilder =
    PromptsCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String> therapeuticFramework,
      Value<int> difficultyLevel,
      Value<String?> category,
      Value<String?> targetMoodStates,
      Value<String?> bestTimeOfDay,
      Value<String?> tags,
      Value<String?> sourceCitation,
      Value<bool> isActive,
    });

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

  static MultiTypedResultKey<$PromptInteractionsTable, List<PromptInteraction>>
  _promptInteractionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.promptInteractions,
        aliasName: $_aliasNameGenerator(
          db.prompts.id,
          db.promptInteractions.promptId,
        ),
      );

  $$PromptInteractionsTableProcessedTableManager get promptInteractionsRefs {
    final manager = $$PromptInteractionsTableTableManager(
      $_db,
      $_db.promptInteractions,
    ).filter((f) => f.promptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _promptInteractionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserAvoidedPromptsTable, List<UserAvoidedPrompt>>
  _userAvoidedPromptsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userAvoidedPrompts,
        aliasName: $_aliasNameGenerator(
          db.prompts.id,
          db.userAvoidedPrompts.promptId,
        ),
      );

  $$UserAvoidedPromptsTableProcessedTableManager get userAvoidedPromptsRefs {
    final manager = $$UserAvoidedPromptsTableTableManager(
      $_db,
      $_db.userAvoidedPrompts,
    ).filter((f) => f.promptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userAvoidedPromptsRefsTable($_db),
    );
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

  ColumnFilters<String> get therapeuticFramework => $composableBuilder(
    column: $table.therapeuticFramework,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetMoodStates => $composableBuilder(
    column: $table.targetMoodStates,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bestTimeOfDay => $composableBuilder(
    column: $table.bestTimeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceCitation => $composableBuilder(
    column: $table.sourceCitation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  Expression<bool> promptInteractionsRefs(
    Expression<bool> Function($$PromptInteractionsTableFilterComposer f) f,
  ) {
    final $$PromptInteractionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promptInteractions,
      getReferencedColumn: (t) => t.promptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromptInteractionsTableFilterComposer(
            $db: $db,
            $table: $db.promptInteractions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userAvoidedPromptsRefs(
    Expression<bool> Function($$UserAvoidedPromptsTableFilterComposer f) f,
  ) {
    final $$UserAvoidedPromptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAvoidedPrompts,
      getReferencedColumn: (t) => t.promptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAvoidedPromptsTableFilterComposer(
            $db: $db,
            $table: $db.userAvoidedPrompts,
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

  ColumnOrderings<String> get therapeuticFramework => $composableBuilder(
    column: $table.therapeuticFramework,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMoodStates => $composableBuilder(
    column: $table.targetMoodStates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bestTimeOfDay => $composableBuilder(
    column: $table.bestTimeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceCitation => $composableBuilder(
    column: $table.sourceCitation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  GeneratedColumn<String> get therapeuticFramework => $composableBuilder(
    column: $table.therapeuticFramework,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get targetMoodStates => $composableBuilder(
    column: $table.targetMoodStates,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bestTimeOfDay => $composableBuilder(
    column: $table.bestTimeOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get sourceCitation => $composableBuilder(
    column: $table.sourceCitation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

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

  Expression<T> promptInteractionsRefs<T extends Object>(
    Expression<T> Function($$PromptInteractionsTableAnnotationComposer a) f,
  ) {
    final $$PromptInteractionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.promptInteractions,
          getReferencedColumn: (t) => t.promptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PromptInteractionsTableAnnotationComposer(
                $db: $db,
                $table: $db.promptInteractions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> userAvoidedPromptsRefs<T extends Object>(
    Expression<T> Function($$UserAvoidedPromptsTableAnnotationComposer a) f,
  ) {
    final $$UserAvoidedPromptsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userAvoidedPrompts,
          getReferencedColumn: (t) => t.promptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserAvoidedPromptsTableAnnotationComposer(
                $db: $db,
                $table: $db.userAvoidedPrompts,
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
          PrefetchHooks Function({
            bool recordsRefs,
            bool promptInteractionsRefs,
            bool userAvoidedPromptsRefs,
          })
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
                Value<String> therapeuticFramework = const Value.absent(),
                Value<int> difficultyLevel = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> targetMoodStates = const Value.absent(),
                Value<String?> bestTimeOfDay = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> sourceCitation = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => PromptsCompanion(
                id: id,
                content: content,
                therapeuticFramework: therapeuticFramework,
                difficultyLevel: difficultyLevel,
                category: category,
                targetMoodStates: targetMoodStates,
                bestTimeOfDay: bestTimeOfDay,
                tags: tags,
                sourceCitation: sourceCitation,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                required String therapeuticFramework,
                required int difficultyLevel,
                Value<String?> category = const Value.absent(),
                Value<String?> targetMoodStates = const Value.absent(),
                Value<String?> bestTimeOfDay = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> sourceCitation = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => PromptsCompanion.insert(
                id: id,
                content: content,
                therapeuticFramework: therapeuticFramework,
                difficultyLevel: difficultyLevel,
                category: category,
                targetMoodStates: targetMoodStates,
                bestTimeOfDay: bestTimeOfDay,
                tags: tags,
                sourceCitation: sourceCitation,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PromptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recordsRefs = false,
                promptInteractionsRefs = false,
                userAvoidedPromptsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recordsRefs) db.records,
                    if (promptInteractionsRefs) db.promptInteractions,
                    if (userAvoidedPromptsRefs) db.userAvoidedPrompts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recordsRefs)
                        await $_getPrefetchedData<
                          Prompt,
                          $PromptsTable,
                          Record
                        >(
                          currentTable: table,
                          referencedTable: $$PromptsTableReferences
                              ._recordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PromptsTableReferences(
                                db,
                                table,
                                p0,
                              ).recordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.promptId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (promptInteractionsRefs)
                        await $_getPrefetchedData<
                          Prompt,
                          $PromptsTable,
                          PromptInteraction
                        >(
                          currentTable: table,
                          referencedTable: $$PromptsTableReferences
                              ._promptInteractionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PromptsTableReferences(
                                db,
                                table,
                                p0,
                              ).promptInteractionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.promptId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userAvoidedPromptsRefs)
                        await $_getPrefetchedData<
                          Prompt,
                          $PromptsTable,
                          UserAvoidedPrompt
                        >(
                          currentTable: table,
                          referencedTable: $$PromptsTableReferences
                              ._userAvoidedPromptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PromptsTableReferences(
                                db,
                                table,
                                p0,
                              ).userAvoidedPromptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.promptId == item.id,
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
      PrefetchHooks Function({
        bool recordsRefs,
        bool promptInteractionsRefs,
        bool userAvoidedPromptsRefs,
      })
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
typedef $$PromptInteractionsTableCreateCompanionBuilder =
    PromptInteractionsCompanion Function({
      Value<int> id,
      required int userId,
      required int promptId,
      required bool completed,
      required bool skipped,
    });
typedef $$PromptInteractionsTableUpdateCompanionBuilder =
    PromptInteractionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> promptId,
      Value<bool> completed,
      Value<bool> skipped,
    });

final class $$PromptInteractionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PromptInteractionsTable,
          PromptInteraction
        > {
  $$PromptInteractionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserTable _userIdTable(_$AppDatabase db) => db.user.createAlias(
    $_aliasNameGenerator(db.promptInteractions.userId, db.user.id),
  );

  $$UserTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

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

  static $PromptsTable _promptIdTable(_$AppDatabase db) =>
      db.prompts.createAlias(
        $_aliasNameGenerator(db.promptInteractions.promptId, db.prompts.id),
      );

  $$PromptsTableProcessedTableManager get promptId {
    final $_column = $_itemColumn<int>('prompt_id')!;

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
}

class $$PromptInteractionsTableFilterComposer
    extends Composer<_$AppDatabase, $PromptInteractionsTable> {
  $$PromptInteractionsTableFilterComposer({
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

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

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
}

class $$PromptInteractionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PromptInteractionsTable> {
  $$PromptInteractionsTableOrderingComposer({
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

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

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
}

class $$PromptInteractionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromptInteractionsTable> {
  $$PromptInteractionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

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
}

class $$PromptInteractionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromptInteractionsTable,
          PromptInteraction,
          $$PromptInteractionsTableFilterComposer,
          $$PromptInteractionsTableOrderingComposer,
          $$PromptInteractionsTableAnnotationComposer,
          $$PromptInteractionsTableCreateCompanionBuilder,
          $$PromptInteractionsTableUpdateCompanionBuilder,
          (PromptInteraction, $$PromptInteractionsTableReferences),
          PromptInteraction,
          PrefetchHooks Function({bool userId, bool promptId})
        > {
  $$PromptInteractionsTableTableManager(
    _$AppDatabase db,
    $PromptInteractionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromptInteractionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromptInteractionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromptInteractionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> promptId = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
              }) => PromptInteractionsCompanion(
                id: id,
                userId: userId,
                promptId: promptId,
                completed: completed,
                skipped: skipped,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int promptId,
                required bool completed,
                required bool skipped,
              }) => PromptInteractionsCompanion.insert(
                id: id,
                userId: userId,
                promptId: promptId,
                completed: completed,
                skipped: skipped,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PromptInteractionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, promptId = false}) {
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
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$PromptInteractionsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$PromptInteractionsTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (promptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.promptId,
                                referencedTable:
                                    $$PromptInteractionsTableReferences
                                        ._promptIdTable(db),
                                referencedColumn:
                                    $$PromptInteractionsTableReferences
                                        ._promptIdTable(db)
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

typedef $$PromptInteractionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromptInteractionsTable,
      PromptInteraction,
      $$PromptInteractionsTableFilterComposer,
      $$PromptInteractionsTableOrderingComposer,
      $$PromptInteractionsTableAnnotationComposer,
      $$PromptInteractionsTableCreateCompanionBuilder,
      $$PromptInteractionsTableUpdateCompanionBuilder,
      (PromptInteraction, $$PromptInteractionsTableReferences),
      PromptInteraction,
      PrefetchHooks Function({bool userId, bool promptId})
    >;
typedef $$UserAvoidedPromptsTableCreateCompanionBuilder =
    UserAvoidedPromptsCompanion Function({
      required int userId,
      required int promptId,
      Value<DateTime> avoidedAt,
      Value<int> rowid,
    });
typedef $$UserAvoidedPromptsTableUpdateCompanionBuilder =
    UserAvoidedPromptsCompanion Function({
      Value<int> userId,
      Value<int> promptId,
      Value<DateTime> avoidedAt,
      Value<int> rowid,
    });

final class $$UserAvoidedPromptsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $UserAvoidedPromptsTable,
          UserAvoidedPrompt
        > {
  $$UserAvoidedPromptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserTable _userIdTable(_$AppDatabase db) => db.user.createAlias(
    $_aliasNameGenerator(db.userAvoidedPrompts.userId, db.user.id),
  );

  $$UserTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

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

  static $PromptsTable _promptIdTable(_$AppDatabase db) =>
      db.prompts.createAlias(
        $_aliasNameGenerator(db.userAvoidedPrompts.promptId, db.prompts.id),
      );

  $$PromptsTableProcessedTableManager get promptId {
    final $_column = $_itemColumn<int>('prompt_id')!;

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
}

class $$UserAvoidedPromptsTableFilterComposer
    extends Composer<_$AppDatabase, $UserAvoidedPromptsTable> {
  $$UserAvoidedPromptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get avoidedAt => $composableBuilder(
    column: $table.avoidedAt,
    builder: (column) => ColumnFilters(column),
  );

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
}

class $$UserAvoidedPromptsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserAvoidedPromptsTable> {
  $$UserAvoidedPromptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get avoidedAt => $composableBuilder(
    column: $table.avoidedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
}

class $$UserAvoidedPromptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserAvoidedPromptsTable> {
  $$UserAvoidedPromptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get avoidedAt =>
      $composableBuilder(column: $table.avoidedAt, builder: (column) => column);

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
}

class $$UserAvoidedPromptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserAvoidedPromptsTable,
          UserAvoidedPrompt,
          $$UserAvoidedPromptsTableFilterComposer,
          $$UserAvoidedPromptsTableOrderingComposer,
          $$UserAvoidedPromptsTableAnnotationComposer,
          $$UserAvoidedPromptsTableCreateCompanionBuilder,
          $$UserAvoidedPromptsTableUpdateCompanionBuilder,
          (UserAvoidedPrompt, $$UserAvoidedPromptsTableReferences),
          UserAvoidedPrompt,
          PrefetchHooks Function({bool userId, bool promptId})
        > {
  $$UserAvoidedPromptsTableTableManager(
    _$AppDatabase db,
    $UserAvoidedPromptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserAvoidedPromptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserAvoidedPromptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserAvoidedPromptsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<int> promptId = const Value.absent(),
                Value<DateTime> avoidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserAvoidedPromptsCompanion(
                userId: userId,
                promptId: promptId,
                avoidedAt: avoidedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int userId,
                required int promptId,
                Value<DateTime> avoidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserAvoidedPromptsCompanion.insert(
                userId: userId,
                promptId: promptId,
                avoidedAt: avoidedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserAvoidedPromptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, promptId = false}) {
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
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$UserAvoidedPromptsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$UserAvoidedPromptsTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (promptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.promptId,
                                referencedTable:
                                    $$UserAvoidedPromptsTableReferences
                                        ._promptIdTable(db),
                                referencedColumn:
                                    $$UserAvoidedPromptsTableReferences
                                        ._promptIdTable(db)
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

typedef $$UserAvoidedPromptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserAvoidedPromptsTable,
      UserAvoidedPrompt,
      $$UserAvoidedPromptsTableFilterComposer,
      $$UserAvoidedPromptsTableOrderingComposer,
      $$UserAvoidedPromptsTableAnnotationComposer,
      $$UserAvoidedPromptsTableCreateCompanionBuilder,
      $$UserAvoidedPromptsTableUpdateCompanionBuilder,
      (UserAvoidedPrompt, $$UserAvoidedPromptsTableReferences),
      UserAvoidedPrompt,
      PrefetchHooks Function({bool userId, bool promptId})
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
  $$PromptInteractionsTableTableManager get promptInteractions =>
      $$PromptInteractionsTableTableManager(_db, _db.promptInteractions);
  $$UserAvoidedPromptsTableTableManager get userAvoidedPrompts =>
      $$UserAvoidedPromptsTableTableManager(_db, _db.userAvoidedPrompts);
}
