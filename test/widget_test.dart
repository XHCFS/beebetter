// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beebetter/main.dart';
import 'package:beebetter/data/database/app_database.dart';

void main() {
  testWidgets('App initializes successfully', (WidgetTester tester) async {
    // Create a test database
    final db = AppDatabase.test();
    
    // Create a test user
    final userId = await db.into(db.user).insert(
      UserCompanion.insert(name: 'Test User'),
    );
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(db: db, userId: userId));
    await tester.pumpAndSettle();

    // Verify that the app loads (check for any text that should be present)
    // Since we don't know what's on the main page, just verify no errors occurred
    expect(tester.takeException(), isNull);
    
    // Clean up
    await db.close();
  });
}
