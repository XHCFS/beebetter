import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class GuidedModeLogic extends ChangeNotifier {
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

  List<String> userInputs = [];
  List<bool> canContinue = [];
  List<bool> isDone = [];


  int currentPrompt = 0;
  int completedPrompts = 1;

  int get totalPrompts => prompts.length;

  String get currentPromptText => prompts[currentPrompt];
  String get currentPromptCategory => promptsCategory[currentPrompt];


  GuidedModeLogic() {
    final total = prompts.length;
    userInputs = List.generate(total, (_) => "");
    canContinue = List.generate(total, (_) => false);
    isDone = List.generate(total, (_) => false);
  }

  void updateCanContinue(bool value) {
    if(isDone[currentPrompt]) return;

    if(completedPrompts <= totalPrompts) {
      canContinue[currentPrompt] = value;
    }
    else{
        canContinue[currentPrompt]  = false;
    }
    notifyListeners();
  }

  void updatePromptInput(int index, String value) {
    userInputs[index] = value;
    notifyListeners();
  }

  void submit(String entry)
  {
    if(completedPrompts < totalPrompts) {
      completedPrompts++;
    }
    canContinue[currentPrompt]  = false;
    isDone[currentPrompt] = true;
    notifyListeners();
  }

  void nextPrompt() {
    if (currentPrompt < totalPrompts - 1) {
      currentPrompt++;
      notifyListeners();
    }
  }

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
