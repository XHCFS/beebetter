import 'package:flutter/material.dart';
import 'package:beebetter/classes/EntryInfo.dart';

class DashboardLogic extends ChangeNotifier {

  String overallMood = "Happy";
  int overallMoodPercentage = 80;
  int totalEntries = 24;
  int daysTracked = 40;
  int streak = 15;

  List<int> moodValues = [3, 2, 4, 1, 2, 3, 0];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  DateTime? get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  List<EntryInfo> prompts = [];
  final int emotionLevels = 3;

  DashboardLogic() {
    prompts = [
      EntryInfo(
        id: "p1",
        title: "What's one small win you had today?",
        category: "productivity",
        emotionLevels: emotionLevels,
        isText: false,
      ),
      EntryInfo(
        id: "p2",
        title: "Reflect on your energy levels today.",
        category: "productivity",
        emotionLevels: emotionLevels,
        isText: true,
      ),
      EntryInfo(
        id: "p3",
        title: "Create a story using these three words.",
        category: "creativity",
        emotionLevels: emotionLevels,
        isText: false,
      ),
      EntryInfo(
        id: "p4",
        title: "What made you smile today?",
        category: "gratitude practice",
        emotionLevels: emotionLevels,
        isText: true,
      ),
    ];
  }

  void selectDay(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    notifyListeners();
  }

}