import 'package:flutter/material.dart';

class DashboardLogic extends ChangeNotifier {

  String overallMood = "Happy";
  int overallMoodPercentage = 80;
  int totalEntries = 24;
  int daysTracked = 40;
  int streak = 15;

  List<int> moodValues = [3, 2, 4, 1, 2, 3, 0];
  List<String> goals = [
    "Mindfulness",
    "Productivity",
    "Creative Writing",
  ];

}