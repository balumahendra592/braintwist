enum PuzzleType {
  multiChoice,    // 4 option buttons
  tapTarget,      // tap a specific widget on screen
  dragDrop,       // drag item to correct position
  typeAnswer,     // keyboard text input
  visualTrick,    // tap something unexpected (the question text, a hidden element)
}

class Puzzle {
  final int id;
  final String question;
  final PuzzleType type;
  final String chapter;       // 'easy' | 'medium' | 'hard'
  final int levelNumber;

  // For multiChoice
  final List<String>? options;
  final int? correctOptionIndex;

  // For tapTarget / visualTrick
  final String? correctTargetId;

  // For typeAnswer
  final String? correctAnswer;     // exact string, lowercased for comparison

  // For dragDrop
  final String? dragItemLabel;
  final String? dropZoneLabel;

  final String hintText;
  final int coinReward;

  const Puzzle({
    required this.id,
    required this.question,
    required this.type,
    required this.chapter,
    required this.levelNumber,
    this.options,
    this.correctOptionIndex,
    this.correctTargetId,
    this.correctAnswer,
    this.dragItemLabel,
    this.dropZoneLabel,
    required this.hintText,
    this.coinReward = 10,
  });
}