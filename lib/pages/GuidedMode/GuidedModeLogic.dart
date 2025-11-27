import 'package:flutter/material.dart';

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

  int currentPrompt = 0;
  int completedPrompts = 1;
  bool canContinue = false;

  int get totalPrompts => prompts.length;

  String get currentPromptText => prompts[currentPrompt];
  String get currentPromptCategory => promptsCategory[currentPrompt];



  void updateCanContinue(bool value) {
    if(completedPrompts <= totalPrompts) {
      canContinue = value;
    }
    else{
        canContinue = false;
    }
    notifyListeners();
  }

  void submit(String entry)
  {
    if(completedPrompts < totalPrompts) {
      completedPrompts++;
    }
    print(entry);
    canContinue = false;
    notifyListeners();
  }

  void nextPrompt() {
    if (currentPrompt < totalPrompts - 1) {
      currentPrompt++;
      canContinue = false;
      notifyListeners();
    }
  }

  void previousPrompt() {
    if (currentPrompt > 0) {
      currentPrompt--;
      notifyListeners();
    }
  }

  void shufflePrompts() {
    final combined = List.generate(prompts.length, (i) => {
      'prompt': prompts[i],
      'category': promptsCategory[i],
    });
    combined.shuffle();
    for (int i = 0; i < combined.length; i++) {
      prompts[i] = combined[i]['prompt']!;
      promptsCategory[i] = combined[i]['category']!;
    }
    notifyListeners();
  }
}
