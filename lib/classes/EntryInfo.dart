
class EntryInfo {
  final String id;
  final String category;

  String title;
  String userInput;
  bool canContinue;
  bool isTextLocked;
  bool isVoiceLocked;
  bool isDone;
  int lastActiveTab;
  List<String> emotions;
  bool isText;

  EntryInfo({
    required this.id,
    required this.title,
    required this.category,
    required int emotionLevels,
    this.isText = false,
  })  : userInput = "",
        canContinue = false,
        isTextLocked = false,
        isVoiceLocked = false,
        isDone = false,
        lastActiveTab = 1,
        emotions = List.generate(emotionLevels, (_) => "");
}
