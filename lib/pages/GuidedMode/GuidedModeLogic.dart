import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:beebetter/classes/EntryInfo.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/prompting_system/services/prompt_selection_system.dart';
import 'package:beebetter/prompting_system/services/adaptation_system.dart';
import 'package:drift/drift.dart';

class GuidedModeLogic extends ChangeNotifier {
  final AppDatabase _db;
  final int _userId;
  final PromptSelectionSystem _promptSystem;
  final AdaptationService _adaptationService;
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
  bool _isLoadingPrompts = true;
  
  EntryInfo get currentPromptInfo {
    if (prompts.isEmpty) {
      // Return a default prompt if none loaded yet
      return EntryInfo(
        id: "loading",
        title: "Loading prompts...",
        category: "general",
        emotionLevels: emotionLevels,
      );
    }
    return prompts[currentPrompt];
  }

  String get currentPromptText => currentPromptInfo.title;
  String get currentPromptCategory => currentPromptInfo.category;
  int get totalPrompts => prompts.isEmpty ? 1 : prompts.length;

  // ---------------------------------------------------
  // Constructor
  // ---------------------------------------------------

  GuidedModeLogic(this._db, this._userId)
      : _promptSystem = PromptSelectionSystem(_db),
        _adaptationService = AdaptationService(_db) {
    // Initialize with a default prompt immediately to prevent empty list errors
    prompts = [
      EntryInfo(
        id: "loading",
        title: "Loading prompts...",
        category: "general",
        emotionLevels: emotionLevels,
      ),
    ];
    originalTotalPrompts = 1;
    _loadPrompts();
  }

  Future<void> _loadPrompts() async {
    try {
      _isLoadingPrompts = true;
      debugPrint('Loading prompts for user $_userId...');
      
      final ranked = await _promptSystem.rankPromptsForUser(
        userId: _userId,
        limit: 5,
      );

      debugPrint('Loaded ${ranked.length} prompts from system');

      if (ranked.isEmpty) {
        debugPrint('No prompts returned, using fallback prompts');
        // Fallback to default prompts if none available
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
            title: "What made you smile today?",
            category: "gratitude practice",
            emotionLevels: emotionLevels,
          ),
        ];
      } else {
        prompts = ranked.map((scored) {
          final prompt = scored.prompt;
          debugPrint('Adding prompt: ${prompt.content.substring(0, prompt.content.length > 50 ? 50 : prompt.content.length)}...');
          return EntryInfo(
            id: prompt.id.toString(),
            title: prompt.content,
            category: prompt.category ?? 'general',
            emotionLevels: emotionLevels,
          );
        }).toList();
      }

      originalTotalPrompts = prompts.length;
      _isLoadingPrompts = false;
      debugPrint('Prompts loaded successfully. Total: ${prompts.length}');
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error loading prompts: $e');
      debugPrint('Stack trace: $stackTrace');
      // Fallback to default prompts on error
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
          title: "What made you smile today?",
          category: "gratitude practice",
          emotionLevels: emotionLevels,
        ),
      ];
      originalTotalPrompts = prompts.length;
      _isLoadingPrompts = false;
      notifyListeners();
    }
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

  void submit(int index, CardSwiperController cardController) async {
    completedPrompts++;

    final removeIndex = index.clamp(0, prompts.length - 1);
    final completedPrompt = prompts[removeIndex];

    // Track prompt interaction
    if (completedPrompt.id != "done" && completedPrompt.id != "p1") {
      try {
        final promptId = int.tryParse(completedPrompt.id);
        if (promptId != null) {
          await _db.into(_db.promptInteractions).insert(
                PromptInteractionsCompanion.insert(
                  userId: _userId,
                  promptId: promptId,
                  completed: true,
                  skipped: false,
                ),
              );
        }
      } catch (e) {
        debugPrint('Error tracking prompt interaction: $e');
      }
    }

    if (prompts.length == 1) {
      prompts[0] = EntryInfo(
        id: "done",
        title: "Done!",
        category: "",
        emotionLevels: emotionLevels,
      );
      currentPrompt = 0;
      
      // Run adaptation after completing prompts
      _runAdaptation();
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

  Future<void> _runAdaptation() async {
    try {
      await _adaptationService.runAdaptation(_userId);
    } catch (e) {
      debugPrint('Error running adaptation: $e');
    }
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

  void deletePrompt(int index) async {
    if (index < 0 || index >= prompts.length) return;

    if (prompts[index].id == "done") return;

    final skippedPrompt = prompts[index];
    
    // Track skipped prompt
    if (skippedPrompt.id != "p1") {
      try {
        final promptId = int.tryParse(skippedPrompt.id);
        if (promptId != null) {
          await _db.into(_db.promptInteractions).insert(
                PromptInteractionsCompanion.insert(
                  userId: _userId,
                  promptId: promptId,
                  completed: false,
                  skipped: true,
                ),
              );
        }
      } catch (e) {
        debugPrint('Error tracking skipped prompt: $e');
      }
    }

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

  void shufflePrompts() {
    // TODO: we need to implement actual prompt shuffling logic here
    prompts.shuffle();
    currentPrompt = 0;
    notifyListeners();
  }

}

