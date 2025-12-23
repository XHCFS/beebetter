import 'package:flutter/material.dart';
import 'package:beebetter/widgets/Cards/PromptCard/PromptCardInfo.dart';

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

  List<PromptCardInfo> prompts = [];
  final int emotionLevels = 3;

  DashboardLogic() {
    prompts = [
      PromptCardInfo(
        id: "p1",
        prompt: "What's one small win you had today?",
        category: "productivity",
        emotionLevels: emotionLevels,
        isText: false,
      ),
      PromptCardInfo(
        id: "p2",
        prompt: "Reflect on your energy levels today.",
        category: "productivity",
        emotionLevels: emotionLevels,
        isText: true,
      ),
      PromptCardInfo(
        id: "p3",
        prompt: "Create a story using these three words.",
        category: "creativity",
        emotionLevels: emotionLevels,
        isText: false,
      ),
      PromptCardInfo(
        id: "p4",
        prompt: "What made you smile today?",
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