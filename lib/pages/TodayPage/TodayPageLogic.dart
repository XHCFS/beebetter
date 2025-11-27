import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayPageLogic extends ChangeNotifier {
  // these will be synced with database later
  String username = "Name";
  int completedEntries = 0;
  int totalEntries = 3;

  DateTime today = DateTime.now();

  String get formattedDay => DateFormat('EEEE').format(today);
  String get formattedDate => DateFormat('MMMM d, yyyy').format(today);

  void incrementCompleted() {
    if (completedEntries < totalEntries) {
      completedEntries++;
      notifyListeners();
    }
  }

  void setUserName(String name) {
    username = name;
    notifyListeners();
  }

}