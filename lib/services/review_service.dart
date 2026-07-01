import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const _keyLastReviewedLevel = 'last_reviewed_level';
  static const _minSessions = 3;

  // Milestone levels that trigger a review prompt
  static const _reviewMilestones = {5, 25, 50};

  /// Call this after a level is completed.
  /// [completedLevel] is 1-based (level number, not index).
  /// [sessionCount] is fetched from GameStorage.
  static Future<void> maybeRequestReview({
    required int completedLevel,
    required int sessionCount,
  }) async {
    if (!_reviewMilestones.contains(completedLevel)) return;
    if (sessionCount < _minSessions) return;

    final prefs = await SharedPreferences.getInstance();
    final lastReviewed = prefs.getInt(_keyLastReviewedLevel) ?? 0;

    // Don't re-prompt for the same or lower milestone
    if (completedLevel <= lastReviewed) return;

    final inAppReview = InAppReview.instance;
    if (!await inAppReview.isAvailable()) return;

    await prefs.setInt(_keyLastReviewedLevel, completedLevel);
    await inAppReview.requestReview();
  }
}
