import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/services/database_service.dart';

/// Singleton provider for database service
/// This ensures we have a single instance of the database throughout the app
class DatabaseProvider {
  static DatabaseService? _instance;
  static AppDatabase? _database;

  /// Get the database service instance
  static DatabaseService get instance {
    if (_instance == null) {
      _database = AppDatabase();
      _instance = DatabaseService(_database!);
    }
    return _instance!;
  }

  /// Get the database instance directly (if needed)
  static AppDatabase get database {
    if (_database == null) {
      _database = AppDatabase();
      _instance = DatabaseService(_database!);
    }
    return _database!;
  }

  /// Close the database (useful for testing or cleanup)
  static Future<void> close() async {
    await _database?.close();
    _instance = null;
    _database = null;
  }
}

