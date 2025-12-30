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

  List<EntryInfo> entries = [];
  final int emotionLevels = 3;

  DashboardLogic() {
    entries = [
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

    entries[0].userInput = '''A small win today was...\n
- achievement 1\n
- achievement 2\n
- achievement 3\n
    ''';
    entries[1].userInput = '''I had low energy in the morning
im not sure why''';
    entries[2].userInput = '''Once upon a time, a kitty came across a little bunny protecting its house from little mushrooms. 
The mushrooms were jumping over the fences and trying to get into the house. In a panic, the bunny tried to drive them away 
He grabbed his little carrot gun and started shooting carrots on the mushroom. The carrots were too small to hurt them but it was effective!
It somehow made the mushrooms go away, hmm but why is that. The kitty wanted to help the little bunny so it started thinking.
Finally, she came up with a plan and immediately started taking action. She collected a lot of carrots and went the bunny's house. 
On the sight of so many bright orange carrots, all the mushrooms came running to the kitty.
Some mushrooms offered the bunny some carrots and they all enjoyed the yummy carrots.''';
    entries[3].userInput = "I made my friend laugh";

    entries[0].emotions = ["Happy", "Motivated", "Proud"];
    entries[1].emotions = ["Tired", "Low energy", "Confused"];
    entries[2].emotions = ["Happy", "Excited", "Playful"];
    entries[3].emotions = ["Happy", "Motivated", "Proud"];
  }

  void selectDay(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    notifyListeners();
  }

}