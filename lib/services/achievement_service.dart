import 'package:shared_preferences/shared_preferences.dart';
import 'game_storage.dart';

class AchievementDef {
  final String id;
  final String emoji;
  final String title;
  final String description;
  const AchievementDef({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
  });
}

class Achievement extends AchievementDef {
  final bool unlocked;
  const Achievement({
    required super.id,
    required super.emoji,
    required super.title,
    required super.description,
    required this.unlocked,
  });
}

class AchievementService {
  static const _prefix = 'ach_';
  static SharedPreferences? _prefs;

  static const all = <AchievementDef>[
    AchievementDef(id: 'first_solve',  emoji: '🧠', title: 'First Step',     description: 'Complete your first level'),
    AchievementDef(id: 'perfect_star', emoji: '⭐', title: 'Perfectionist',  description: 'Finish a level with 3 stars (no hints)'),
    AchievementDef(id: 'hint_free_10', emoji: '💎', title: 'No Peeking',     description: 'Complete 10 levels without any hints'),
    AchievementDef(id: 'chapter_1',    emoji: '🌱', title: 'Easy Rider',     description: 'Complete all 25 Easy levels'),
    AchievementDef(id: 'chapter_2',    emoji: '🔥', title: 'Tricky Thinker', description: 'Complete all 25 Getting Tricky levels'),
    AchievementDef(id: 'chapter_3',    emoji: '💥', title: 'Mind Bender',    description: 'Complete all 25 Mind Bender levels'),
    AchievementDef(id: 'chapter_4',    emoji: '🧬', title: 'Expert Brain',   description: 'Complete all 25 Expert Zone levels'),
    AchievementDef(id: 'halfway',      emoji: '🏅', title: 'Halfway Hero',   description: 'Complete 50 levels'),
    AchievementDef(id: 'brain_master', emoji: '🏆', title: 'Brain Master',   description: 'Complete all 100 levels'),
    AchievementDef(id: 'coin_1000',    emoji: '🪙', title: 'Coin Hoarder',   description: 'Earn 1 000 coins in total'),
    AchievementDef(id: 'week_streak',  emoji: '📅', title: 'Week Warrior',   description: 'Maintain a 7-day daily streak'),
  ];

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool isUnlocked(String id) =>
      _prefs?.getBool('$_prefix$id') ?? false;

  /// Call after every correct answer. Returns newly unlocked achievements.
  static Future<List<AchievementDef>> checkAndUnlock({
    required int levelIndex,
    required int stars,
    required int hintsUsed,
  }) async {
    await init();
    final completed  = GameStorage.getCompletedLevels();
    final coins      = GameStorage.getTotalCoinsEarned();
    final streak     = GameStorage.getCurrentStreak();
    final hintFree   = GameStorage.getHintFreeLevels();

    final conditions = <String, bool>{
      'first_solve':  completed >= 1,
      'perfect_star': stars == 3,
      'hint_free_10': hintFree >= 10,
      'chapter_1':    completed >= 25,
      'chapter_2':    completed >= 50,
      'chapter_3':    completed >= 75,
      'chapter_4':    completed >= 100,
      'halfway':      completed >= 50,
      'brain_master': completed >= 100,
      'coin_1000':    coins >= 1000,
      'week_streak':  streak >= 7,
    };

    final newly = <AchievementDef>[];
    for (final def in all) {
      if (!isUnlocked(def.id) && (conditions[def.id] ?? false)) {
        await _prefs!.setBool('$_prefix${def.id}', true);
        newly.add(def);
      }
    }
    return newly;
  }

  static List<Achievement> getAll() => all
      .map((d) => Achievement(
            id: d.id,
            emoji: d.emoji,
            title: d.title,
            description: d.description,
            unlocked: isUnlocked(d.id),
          ))
      .toList();

  static int get unlockedCount => all.where((d) => isUnlocked(d.id)).length;
}
