import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:beebetter/classes/EntryInfo.dart';

class GuidedModeLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Variables Initialization
  // ---------------------------------------------------

  final int emotionLevels = 3;
  int currentPrompt = 0;
  int completedPrompts = 1;
  bool canSelectNext = false;
  late final int originalTotalPrompts;

  double deleteDragProgress = 0.0;
  bool isDraggingToDelete = false;

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
  // Inputs
  // ---------------------------------------------------

  List<EntryInfo> prompts = [];
  EntryInfo get currentPromptInfo => prompts[currentPrompt];

  String get currentPromptText => currentPromptInfo.title;
  String get currentPromptCategory => currentPromptInfo.category;
  int get totalPrompts => prompts.length;

  // ---------------------------------------------------
  // Constructor
  // ---------------------------------------------------

  GuidedModeLogic() {
    prompts = [
      EntryInfo(
        id: "p1",
        title: "What's one small win you had today?",
        category: "productivity",
        emotionLevels: emotionLevels,
      ),
      EntryInfo(
        id: "p2",
        title: "Reflect on your energy levels today.",
        category: "productivity",
        emotionLevels: emotionLevels,
      ),
      EntryInfo(
        id: "p3",
        title: "Create a story using these three words.",
        category: "creativity",
        emotionLevels: emotionLevels,
      ),
      EntryInfo(
        id: "p4",
        title: "What made you smile today?",
        category: "gratitude practice",
        emotionLevels: emotionLevels,
      ),
    ];

    originalTotalPrompts = prompts.length;
  }


  // ---------------------------------------------------
  // Inputs
  // ---------------------------------------------------

  void updateCanContinue(bool value) {
    final prompt = currentPromptInfo;

    if (prompt.isDone) return;

    prompt.canContinue = value;
    notifyListeners();
  }

  void updatePromptInput(int index, String value) {
    final prompt = prompts[index];

    prompt.userInput = value;
    prompt.isVoiceLocked = value.isNotEmpty;

    notifyListeners();
  }

  void submit(int index, CardSwiperController cardController) {
    completedPrompts++;

    final removeIndex = index.clamp(0, prompts.length - 1);

    if (prompts.length == 1) {
      prompts[0] = EntryInfo(
        id: "done",
        title: "Done!",
        category: "",
        emotionLevels: emotionLevels,
      );
      currentPrompt = 0;
    } else {
      if (prompts[removeIndex].id != "done") {
        prompts.removeAt(removeIndex);

        if (currentPrompt > removeIndex) {
          currentPrompt--;
        }

        currentPrompt = currentPrompt.clamp(0, prompts.length - 1);
      }
    }

    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prompts.isNotEmpty) {
        cardController.moveTo(currentPrompt);
      }
    });
    updateCanSelectNextForLevel(0);
  }


  // ---------------------------------------------------
  // Emotions Selection
  // ---------------------------------------------------
  void selectEmotion(int level, String emotion) {
    final prompt = currentPromptInfo;

    if (level >= prompt.emotions.length) return;

    prompt.emotions[level] = emotion;
    canSelectNext = emotion.isNotEmpty;

    notifyListeners();
  }

  void submitEmotion(int currentEmotionLevel) {
    final prompt = currentPromptInfo;

    if (currentEmotionLevel == emotionLevels - 1) {
      prompt.isDone = true;
      prompt.canContinue = false;
    }

    notifyListeners();
  }

  void updateCanSelectNextForLevel(int level) {
    final prompt = currentPromptInfo;

    if (level >= prompt.emotions.length) return;

    canSelectNext = prompt.emotions[level].isNotEmpty;
    notifyListeners();
  }

  Future<void> onNextEmotionLevel(int level, int promptIndex, CardSwiperController cardController) async {
    if (level >= emotionLevels) return;

    if (level == emotionLevels - 1) {
      submitEmotion(level);
      cardController.swipe(CardSwiperDirection.left);
      await Future.delayed(const Duration(milliseconds: 300));
      submit(promptIndex, cardController);
    } else {
      updateCanSelectNextForLevel(level + 1);
    }
  }



  // ---------------------------------------------------
  // Delete Prompt
  // ---------------------------------------------------

  void updateDeleteDrag(double dy) {
    deleteDragProgress = (dy / 150).clamp(0.0, 1.0);
    isDraggingToDelete = deleteDragProgress > 0.15;
    notifyListeners();
  }

  void resetDeleteDrag() {
    deleteDragProgress = 0.0;
    isDraggingToDelete = false;
    notifyListeners();
  }

  void deletePrompt(int index) {
    if (index < 0 || index >= prompts.length) return;

    if (prompts[index].id == "done") return;

    prompts.removeAt(index);
    prompts.add(createNewPrompt());

    if (currentPrompt >= prompts.length) {
      currentPrompt = prompts.length - 1;
    }

    notifyListeners();
  }


  EntryInfo createNewPrompt() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    int lastTab = prompts.isNotEmpty ? prompts[0].lastActiveTab : 0;

    return EntryInfo(
      id: id,
      title: "New prompt!!", // TODO: get a new prompt from prompt generator
      category: "reflection",
      emotionLevels: emotionLevels,
      lastActiveTab: lastTab,
    );
  }


  // ---------------------------------------------------
  // Cards Navigation
  // ---------------------------------------------------

  void updateAllCardsLastActiveTab(int tabIndex) {
    for (var prompt in prompts) {
      prompt.lastActiveTab = tabIndex;
    }
    notifyListeners();
  }


  void previousPrompt(CardSwiperController controller) {
    if (currentPrompt <= 0) return;

    currentPrompt--;
    controller.moveTo(currentPrompt);
    notifyListeners();
  }

  void onSwipe(int? currentIndex) {
    if (currentIndex == null) return;
    if (currentIndex < 0 || currentIndex >= prompts.length) return;

    updateCanSelectNextForLevel(0);

    currentPrompt = currentIndex;
    notifyListeners();
  }

  /// Move current card to the back of the deck (shuffle animation)
  void moveCardToBack(int index) {
    if (index < 0 || index >= prompts.length) return;
    if (prompts[index].id == "done") return;

    // Move the card to the end
    final card = prompts.removeAt(index);
    prompts.add(card);

    // Adjust current prompt index
    // After moving a card to the back, the next card takes its place
    // So if we're at index 0 and move it to back, we stay at 0 (which is now the next card)
    // If we're at index 2 and move it to back, we stay at 2 (which is now the next card)
    // But if we move a card before current, we need to adjust
    if (currentPrompt > index) {
      currentPrompt--;
    }
    // If currentPrompt == index, we want to stay at the same index (which now has the next card)
    // No adjustment needed in that case

    notifyListeners();
  }

  /// Skip current prompt and get a new one
  void skipPrompt(int index) {
    if (index < 0 || index >= prompts.length) return;
    if (prompts[index].id == "done") return;

    // Replace with new prompt
    prompts[index] = createNewPrompt();
    
    notifyListeners();
  }

  void shufflePrompts() {
    // TODO: we need to implement actual prompt shuffling logic here
    prompts.shuffle();
    currentPrompt = 0;
    notifyListeners();
  }

}

