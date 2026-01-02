// lib/data/database/tables.dart

import 'package:drift/drift.dart';

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

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get age => integer().nullable()();

  IntColumn get currentDifficultyLevel => integer().nullable()();
  IntColumn get journalingStreak => integer().nullable()();
  TextColumn get preferredCategories => text().nullable()();
  DateTimeColumn get lastDifficultyAdjustment => dateTime().nullable()();

}

class Prompts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();


  TextColumn get therapeuticFramework => text()();
  IntColumn get difficultyLevel => integer()();
  TextColumn get category => text().nullable()();

  // IntColumn get estimatedTimeMinutes => integer()(); // Might remoce later

  // JSON encoded list of Mood enum indexes
  TextColumn get targetMoodStates => text().nullable()();

  // morning / afternoon / evening / night
  TextColumn get bestTimeOfDay => text().nullable()();

  // tags for filtering & clustering
  TextColumn get tags => text().nullable()();

  // citation or reference
  TextColumn get sourceCitation => text().nullable()();

  // Prompts can be deactivated instead of deleted
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Records extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get promptId => integer().references(Prompts, #id).nullable()();
  IntColumn get inputType => integer()
      .clientDefault(() => InputType.text.index)();

  // under the assumption there can be several seperate user profiles on the same device
  IntColumn get userId => integer().references(User, #id).nullable()();

  // optional title for manual entries
  TextColumn get title => text().nullable()(); 

  // will be null in the case of voice entry
  TextColumn get content => text().nullable()();
}

class Moods extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId => integer().references(Records, #id)();
  IntColumn get mood => integer().nullable()();

  // source defines whether recorded mood is inferred by a model or not. will be useful in training
  IntColumn get source => integer()
      .clientDefault(() => MoodSource.user.index)();
}

class PromptInteractions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(User, #id)();
  IntColumn get promptId => integer().references(Prompts, #id)();
  BoolColumn get completed => boolean()(); 
  BoolColumn get skipped => boolean()(); 
}

class UserAvoidedPrompts extends Table {
  IntColumn get userId => integer().references(User, #id)();
  IntColumn get promptId => integer().references(Prompts, #id)();
  DateTimeColumn get avoidedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, promptId};
}
