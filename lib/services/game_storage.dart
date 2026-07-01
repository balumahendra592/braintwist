import 'package:shared_preferences/shared_preferences.dart';

class GameStorage {
  static SharedPreferences? _prefs;

  static const _keyCompletedLevels = 'completed_levels';
  static const _keyCoins           = 'coins';
  static const _keyTotalScore      = 'total_score';
  static const _keyTotalGames      = 'total_games';
  static const _keySoundEnabled    = 'sound_enabled';
  static const _keyMusicEnabled    = 'music_enabled';
  static const _keyVibrationEnabled = 'vibration_enabled';
  static const _keySessionCount      = 'session_count';
  static const _keyLastPlayDate      = 'last_play_date';
  static const _keyCurrentStreak     = 'current_streak';
  static const _keyBestStreak        = 'best_streak';
  static const _keyHintFreeLevels    = 'hint_free_levels';
  static const _keyTotalCoinsEarned  = 'total_coins_earned';

  // ── Init ────────────────────────────────────────
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Give new users 50 starter coins
    if (!_prefs!.containsKey(_keyCoins)) {
      await _prefs!.setInt(_keyCoins, 50);
    }
    // Increment session count (used for rate-us prompt)
    await _prefs!.setInt(_keySessionCount, getSessionCount() + 1);
    // Update daily streak
    await _updateStreak();
  }

  // ── Streak ──────────────────────────────────────
  static int getCurrentStreak() => _prefs!.getInt(_keyCurrentStreak) ?? 0;
  static int getBestStreak()    => _prefs!.getInt(_keyBestStreak) ?? 0;

  static Future<int> _updateStreak() async {
    final today = _dateStr(DateTime.now());
    final last  = _prefs!.getString(_keyLastPlayDate) ?? '';
    if (last == today) return getCurrentStreak(); // already played today

    final current = getCurrentStreak();
    final yesterday = _dateStr(DateTime.now().subtract(const Duration(days: 1)));
    final newStreak = last == yesterday ? current + 1 : 1;

    await _prefs!.setString(_keyLastPlayDate, today);
    await _prefs!.setInt(_keyCurrentStreak, newStreak);
    if (newStreak > getBestStreak()) {
      await _prefs!.setInt(_keyBestStreak, newStreak);
    }
    return newStreak;
  }

  static String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ── Hint-free level counter ──────────────────────
  static int getHintFreeLevels() => _prefs!.getInt(_keyHintFreeLevels) ?? 0;

  static Future<void> incrementHintFreeLevels() async =>
      _prefs!.setInt(_keyHintFreeLevels, getHintFreeLevels() + 1);

  // ── Total coins earned (lifetime) ───────────────
  static int getTotalCoinsEarned() => _prefs!.getInt(_keyTotalCoinsEarned) ?? 0;

  // ── Levels ──────────────────────────────────────
  static int getCompletedLevels() =>
      _prefs!.getInt(_keyCompletedLevels) ?? 0;

  static Future<void> completeLevel(int levelIndex) async {
    if (levelIndex + 1 > getCompletedLevels()) {
      await _prefs!.setInt(_keyCompletedLevels, levelIndex + 1);
    }
  }

  static bool isLevelUnlocked(int levelIndex) =>
      levelIndex == 0 || levelIndex <= getCompletedLevels();

  // ── Stars ───────────────────────────────────────
  static int getLevelStars(int levelIndex) =>
      _prefs!.getInt('stars_$levelIndex') ?? 0;

  static Future<void> saveLevelStars(int levelIndex, int stars) async {
    final existing = getLevelStars(levelIndex);
    if (stars > existing) {
      await _prefs!.setInt('stars_$levelIndex', stars);
    }
  }

  // Calculate stars: 3 = no hints, 2 = 1 hint, 1 = 2+ hints
  static int calculateStars(int hintsUsed) {
    if (hintsUsed == 0) return 3;
    if (hintsUsed == 1) return 2;
    return 1;
  }

  // ── Coins ───────────────────────────────────────
  static int getCoins() => _prefs!.getInt(_keyCoins) ?? 50;

  static Future<void> addCoins(int amount) async {
    await _prefs!.setInt(_keyCoins, getCoins() + amount);
    await _prefs!.setInt(_keyTotalCoinsEarned, getTotalCoinsEarned() + amount);
  }

  static Future<bool> spendCoins(int amount) async {
    if (getCoins() < amount) return false;
    await _prefs!.setInt(_keyCoins, getCoins() - amount);
    return true;
  }

  static bool canAfford(int amount) => getCoins() >= amount;

  // ── Score ───────────────────────────────────────
  static int getTotalScore() => _prefs!.getInt(_keyTotalScore) ?? 0;

  static Future<void> addScore(int points) async =>
      await _prefs!.setInt(_keyTotalScore, getTotalScore() + points);

  // ── Game count ──────────────────────────────────
  static int getTotalGames() => _prefs!.getInt(_keyTotalGames) ?? 0;

  static Future<void> incrementGames() async =>
      await _prefs!.setInt(_keyTotalGames, getTotalGames() + 1);

  // ── Settings ────────────────────────────────────
  static bool isSoundEnabled()     => _prefs!.getBool(_keySoundEnabled) ?? true;
  static bool isMusicEnabled()     => _prefs!.getBool(_keyMusicEnabled) ?? true;
  static bool isVibrationEnabled() => _prefs!.getBool(_keyVibrationEnabled) ?? true;

  static Future<void> setSoundEnabled(bool v)     async => await _prefs!.setBool(_keySoundEnabled, v);
  static Future<void> setMusicEnabled(bool v)     async => await _prefs!.setBool(_keyMusicEnabled, v);
  static Future<void> setVibrationEnabled(bool v) async => await _prefs!.setBool(_keyVibrationEnabled, v);

  // ── Session ─────────────────────────────────────
  static int getSessionCount() => _prefs!.getInt(_keySessionCount) ?? 0;

  // ── Reset ───────────────────────────────────────
  static Future<void> resetAll() async => await _prefs!.clear();
}