import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

// NOTE:
// To use the database elsewhere in the app:
// import 'package:beebetter/data/database/app_database.dart';
// final db = AppDatabase();

@DriftDatabase(tables: [User, Prompts, Records, Moods])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

/// Opens a persistent SQLite database file.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Get the app's document directory (e.g., /data/user/0/com.example.app/app_flutter)
    final dbFolder = await getApplicationDocumentsDirectory();
    // Make sure the folder exists
    final file = File(p.join(dbFolder.path, 'beebetter.sqlite'));
    // Return a NativeDatabase that writes to that file
    return NativeDatabase(file);
  });
}

