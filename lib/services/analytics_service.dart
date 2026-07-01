import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final _fa = FirebaseAnalytics.instance;

  static Future<void> logLevelStart(int levelIndex) =>
      _fa.logLevelStart(levelName: 'level_${levelIndex + 1}');

  static Future<void> logLevelComplete({
    required int levelIndex,
    required int stars,
    required int hintsUsed,
  }) =>
      _fa.logEvent(name: 'level_complete', parameters: {
        'level': levelIndex + 1,
        'stars': stars,
        'hints_used': hintsUsed,
      });

  static Future<void> logHintUsed(int levelIndex) =>
      _fa.logEvent(name: 'hint_used', parameters: {'level': levelIndex + 1});

  static Future<void> logAchievement(String id) =>
      _fa.logUnlockAchievement(id: id);

  static Future<void> logShare() => _fa.logShare(
        contentType: 'level_result',
        itemId: 'result',
        method: 'native',
      );

  static Future<void> logStreakUpdated(int days) =>
      _fa.logEvent(name: 'streak_updated', parameters: {'days': days});
}
