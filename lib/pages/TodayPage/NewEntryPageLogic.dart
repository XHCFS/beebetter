import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beebetter/classes/EntryInfo.dart';

class NewEntryPageLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Variables Initialization
  // ---------------------------------------------------

  DateTime today = DateTime.now();
  String get formattedDay => DateFormat('EEEE').format(today);
  String get formattedDate => DateFormat('MMMM d, yyyy').format(today);

  final int emotionLevels = 3;

  bool canSelectNext = false;
  late EntryInfo entryInfo;


  // ---------------------------------------------------
  // Later will be loaded from Database or prompt generator
  // ---------------------------------------------------

  final List<List<String>> emotionItems = const [
    [
      "Joy",
      "Trust",
      "Fear",
      "Surprise",
      "Sadness",
      "Disgust",
      "Anger",
      "Anticipation",
    ],
    ["Happy", "Calm", "Excited"],
    ["Overwhelmed", "Empty", "Hopeful"],
  ];

  // ---------------------------------------------------
  // Constructor
  // ---------------------------------------------------

  NewEntryPageLogic() {
    entryInfo = EntryInfo(
      id: "entry",
      title: DateFormat('MMMM d, yyyy HH:mm').format(DateTime.now()),
      category: "default",
      emotionLevels: emotionLevels,
      isText: false,
    );
  }

  // ---------------------------------------------------
  // Functions
  // ---------------------------------------------------

  void updateCanContinue(bool value) {
    entryInfo.canContinue = value;
    notifyListeners();
  }

  void updateCanSelectNextForLevel(int level) {
    canSelectNext = entryInfo.emotions[level].isNotEmpty;
    notifyListeners();
  }

  void updateEntryInput(String value) {
    entryInfo.userInput = value;
    entryInfo.isVoiceLocked = value.isNotEmpty;
    notifyListeners();
  }

  void updateTitle(String value) {
    if (value.isEmpty) {
      entryInfo.title = DateFormat('MMMM d, yyyy hh:mm a').format(DateTime.now());
    } else {
      entryInfo.title = value;
    }
    notifyListeners();
  }


  void saveEntry() {

  }

}