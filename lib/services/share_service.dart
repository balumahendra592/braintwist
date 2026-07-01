import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareResult({
    required int levelNumber,
    required int stars,
  }) async {
    final starStr = List.generate(stars, (_) => '⭐').join();
    await Share.share(
      'I just solved Level $levelNumber in Brain Twist! $starStr\n'
      '🧠 Can you beat me?\n#BrainTwist #PuzzleGame',
      subject: 'Brain Twist – Level $levelNumber',
    );
  }

  static Future<void> shareAchievement(String emoji, String title) async {
    await Share.share(
      'I just unlocked "$title" $emoji in Brain Twist! 🧠\n#BrainTwist',
      subject: 'Brain Twist Achievement',
    );
  }
}
