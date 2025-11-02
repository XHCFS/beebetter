// lib/data/database/tables.dart

import 'package:drift/drift.dart';

part 'tables.g.dart';

enum Mood {
  cheerful,
  content,
  proud,
  optimistic,
  excited,
  enthusiastic,
  playful,
  satisfied,
  grateful,
  compassionate,
  affectionate,
  warm,
  sentimental,
  tender,
  caring,
  romantic,
  passionate,
  lonely,
  disappointed,
  hurt,
  guilty,
  depressed,
  grief,
  isolated,
  hopeless,
  amazed,
  astonished,
  confused,
  shocked,
  perplexed,
  disoriented,
  startled,
  frustrated,
  irritated,
  enraged,
  resentful,
  jealous,
  contemptuous,
  furious,
  annoyed,
  interested,
  curious,
  eager,
  hopeful,
  alert,
  expectant,
  confident,
  secure,
  faithful,
  assured,
  reliable,
  supported,
  accepted,
  anxious,
  insecure,
  scared,
  nervous,
  terrified,
  panicked,
  helpless,
  apprehensive,
}

enum MoodSource {
  user,
  ai,
}

enum InputType {
  text,
  voice,
  written,
}

// possibly add several profiles
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get age => integer().nullable()();
}

// additional fields to be added once prompting system designed
class Prompts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class PromptCategoryLinks extends Table {
  IntColumn get promptId => integer().references(Prompts, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();

  @override
  Set<Column> get primaryKey => {promptId, categoryId};
}

class Records extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get promptId => integer().references(Prompts, #id).nullable()();
  IntColumn get inputType => intEnum<InputType>().withDefault(Constant(0))();

  // under the assumption there can be several seperate user profiles on the same device
  IntColumn get userId => integer().references(Users, #id).nullable()();

  // optional title for manual entries
  TextColumn get title => text().nullable()(); 

  // will be null in the case of voice entry
  TextColumn get content => text().nullable()();
}

class Moods extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId => integer().references(Records, #id)();
  IntColumn get mood => intEnum<Mood>().nullable()();

  // source defines whether recorded mood is inferred by a model or not. will be useful in training
  IntColumn get source => intEnum<MoodSource>().withDefault(Constant(0))();
}
