import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beebetter/pages/MainPage/MainPage.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/prompting_system/services/prompt_initalizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final db = AppDatabase();
  
  // Initialize prompts from JSON
  try {
    final initService = PromptInitializationService(db);
    final jsonContent = await rootBundle.loadString('assets/prompts.json');
    await initService.initializePromptsFromJson(jsonContent);
  } catch (e) {
    debugPrint('Failed to initialize prompts: $e');
  }
  
  // Get or create default user
  final users = await db.select(db.user).get();
  int userId;
  if (users.isEmpty) {
    userId = await db.into(db.user).insert(
      UserCompanion.insert(name: 'User'),
    );
  } else {
    userId = users.first.id;
  }
  
  runApp(MyApp(db: db, userId: userId));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  final int userId;
  
  const MyApp({super.key, required this.db, required this.userId});

  @override
  Widget build(BuildContext context) {
    final colorAccent = Colors.orangeAccent;
    final baseScheme = ColorScheme.fromSeed(seedColor: Colors.orangeAccent);
    final baseInversePrimary = baseScheme.inversePrimary;
    final lightInversePrimary = lighten(baseInversePrimary, 0.08);
    final colorScheme = ColorScheme.fromSeed(seedColor: colorAccent).copyWith(
      inversePrimary: lightInversePrimary,
      error: Colors.redAccent,
    );

    return MaterialApp(
      title: 'BEEbetter',
      theme: ThemeData(
        colorScheme: colorScheme,
      ),
      home: MainPage(db: db, userId: userId),
    );
  }
}


Color lighten(Color color, [double amount = 0.1]) {
  // Convert to HSL to adjust lightness
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}