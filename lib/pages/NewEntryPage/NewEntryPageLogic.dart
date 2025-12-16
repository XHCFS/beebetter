import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEntryPageLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Variables Initialization
  // ---------------------------------------------------

  DateTime today = DateTime.now();
  String get formattedDay => DateFormat('EEEE').format(today);
  String get formattedDate => DateFormat('MMMM d, yyyy').format(today);

  bool isTextLocked = false;
  bool isVoiceLocked = false;
  int lastActiveTab = 1;
  int emotionLevels = 3;
  bool canContinue = false;
  String userInput = "";
  String title = "";

  late List<String> emotions;

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
    emotions = List.generate(emotionLevels, (_) => "");
  }

  // ---------------------------------------------------
  // Functions
  // ---------------------------------------------------

  void updateCanContinue(bool value) {
    canContinue = value;
    notifyListeners();
  }

  void updatePromptInput(String value) {
    userInput = value;
    isVoiceLocked = value.isNotEmpty;

    notifyListeners();
  }
  void updateTitle(String value) {
    title = value;

    notifyListeners();
  }

  void saveEntry(){

  }

}