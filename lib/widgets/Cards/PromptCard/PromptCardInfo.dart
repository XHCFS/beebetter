
class PromptCardInfo {
  final String id;
  final String prompt;
  final String category;

  String userInput;
  bool canContinue;
  bool isTextLocked;
  bool isVoiceLocked;
  bool isDone;
  int lastActiveTab;
  List<String> emotions;

  PromptCardInfo({
    required this.id,
    required this.prompt,
    required this.category,
    required int emotionLevels,
  })  : userInput = "",
        canContinue = false,
        isTextLocked = false,
        isVoiceLocked = false,
        isDone = false,
        lastActiveTab = 1,
        emotions = List.generate(emotionLevels, (_) => "");
}
