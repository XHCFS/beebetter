import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class GuidedModeLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Variables Initialization
  // ---------------------------------------------------

  int emotionLevels = 3;
  int currentPrompt = 0;
  int completedPrompts = 1;
  bool canSelectNext = false;
  late final int originalTotalPrompts;

  // ---------------------------------------------------
  // Later will be loaded from Database or prompt generator
  // ---------------------------------------------------

  List<String> prompts = [
    "What's one small win you had today?",
    "Reflect on your energy levels today. What patterns do you notice?",
    "Create a story using these three words: whisper, journey, light.",
    "What made you smile today?"
  ];

  List<String> promptsCategory = [
    "productivity",
    "productivity",
    "creativity",
    "gratitude practice"
  ];

  final List<String> items = const [
    "Joy",
    "Trust",
    "Fear",
    "Surprise",
    "Sadness",
    "Disgust",
    "Anger",
    "Anticipation",
  ];

  // ---------------------------------------------------
  // Inputs
  // ---------------------------------------------------

  List<String> userInputs = [];
  List<bool> canContinue = [];
  List<bool> isTextLocked = [];
  List<bool> isVoiceLocked = [];
  List<int> lastActiveTab = [];
  List<bool> isDone = [];

  List<List<String>> Emotions =[];


  int get totalPrompts => prompts.length;

  String get currentPromptText => prompts[currentPrompt];
  String get currentPromptCategory => promptsCategory[currentPrompt];

  // ---------------------------------------------------
  // Constructor
  // ---------------------------------------------------

  GuidedModeLogic() {
    final total = prompts.length;
    originalTotalPrompts = total;
    userInputs = List.generate(total, (_) => "");
    canContinue = List.generate(total, (_) => false);
    isTextLocked = List.generate(total, (_) => false);
    isVoiceLocked = List.generate(total, (_) => false);
    lastActiveTab = List.generate(total, (_) => 1);
    isDone = List.generate(total, (_) => false);
    Emotions = List.generate(total, (_) => List.generate(emotionLevels, (_) => ""));
  }

  // ---------------------------------------------------
  // Inputs
  // ---------------------------------------------------

  void updateCanContinue(bool value) {
    if (isDone[currentPrompt]) return;

    canContinue[currentPrompt] = value;

    notifyListeners();
  }


  void updatePromptInput(int index, String value) {
    userInputs[index] = value;

    if (userInputs[index].isNotEmpty) {
      isVoiceLocked[index] = true; // lock voice tab
    } else {
      isVoiceLocked[index] = false; // unlock if empty
    }

    notifyListeners();
  }


  void submit(CardSwiperController cardController) {
    completedPrompts++;

    // Remove the current card first
    if (prompts.length == 1) {
      // Last card -> replace with Done!
      prompts[0] = "Done!";
      promptsCategory[0] = "";
      userInputs[0] = "";
      canContinue[0] = false;
      isTextLocked[0] = true;
      isVoiceLocked[0] = true;
      lastActiveTab[0] = 1;
      isDone[0] = true;
      Emotions[0] = List.generate(emotionLevels, (_) => "");
    } else {
      prompts.removeAt(currentPrompt);
      promptsCategory.removeAt(currentPrompt);
      userInputs.removeAt(currentPrompt);
      canContinue.removeAt(currentPrompt);
      isTextLocked.removeAt(currentPrompt);
      isVoiceLocked.removeAt(currentPrompt);
      lastActiveTab.removeAt(currentPrompt);
      isDone.removeAt(currentPrompt);
      Emotions.removeAt(currentPrompt);
    }
    if (prompts.isEmpty) {
      currentPrompt = 0;
    } else {
      currentPrompt = currentPrompt.clamp(0, prompts.length - 1);
    }

    // After removing, always clamp currentPrompt to valid index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prompts.isNotEmpty) {
        cardController.moveTo(currentPrompt);
      }
    });

    notifyListeners();
  }




  // ---------------------------------------------------
  // Emotions Selection
  // ---------------------------------------------------
  void selectEmotion(int level, String emotion)
  {
    if (currentPrompt >= Emotions.length || level >= emotionLevels) return;
    Emotions[currentPrompt][level] = emotion;
    if (emotion != ""){
        canSelectNext = true;
      }
    else {
      canSelectNext = false;
    }
    notifyListeners();
  }
  void submitEmotion(int currentEmotionLevel)  // when user presses next
  {
    if(currentEmotionLevel == emotionLevels - 1) {
      isDone[currentPrompt] = true;
      canContinue[currentPrompt] = false;
    }
    notifyListeners();
  }

  void updateCanSelectNextForLevel(int level) {
    canSelectNext = Emotions[currentPrompt][level].isNotEmpty;
    notifyListeners();
  }

  // ---------------------------------------------------
  // Cards Navigation
  // ---------------------------------------------------

  // void nextPrompt() {
  //   if (currentPrompt < totalPrompts - 1) {
  //     currentPrompt++;
  //     notifyListeners();
  //   }
  // }

  void previousPrompt(CardSwiperController cardSwiperController) {
    if (currentPrompt > 0) {
      currentPrompt -- ;
      cardSwiperController.moveTo(currentPrompt);
      notifyListeners();
    }
  }

  void onSwipe(int? currentIndex) {
    if (currentIndex != null) {
      currentPrompt = currentIndex;
      notifyListeners();
    }
  }

  void shufflePrompts() {
    // TODO: we need to implement actual prompt shuffling logic here
    final combined = List.generate(prompts.length, (i) => {
      'prompt': prompts[i],
      'category': promptsCategory[i],
      'input': userInputs[i],
    });

    combined.shuffle();

    for (int i = 0; i < combined.length; i++) {
      prompts[i] = combined[i]['prompt']!;
      promptsCategory[i] = combined[i]['category']!;
      userInputs[i] = combined[i]['input']!;
    }
    notifyListeners();
  }
}
