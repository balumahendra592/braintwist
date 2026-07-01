import 'package:flutter/material.dart';
import '../services/achievement_service.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = AchievementService.getAll();
    final unlocked     = achievements.where((a) => a.unlocked).length;

    return Scaffold(
      backgroundColor: const Color(0xFF1B0A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B0A3A),
        foregroundColor: Colors.white,
        title: const Text('Achievements',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Progress header ────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B4E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$unlocked / ${achievements.length} Unlocked',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: unlocked / achievements.length,
                          backgroundColor:
                              const Color(0xFF7C3AED).withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF7C3AED)),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Achievement list ───────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: achievements.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final a = achievements[i];
                return _AchievementTile(achievement: a);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: unlocked
            ? const Color(0xFF2D1B4E)
            : const Color(0xFF1B0A3A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked
              ? const Color(0xFF7C3AED).withValues(alpha: 0.5)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Text(
            unlocked ? achievement.emoji : '🔒',
            style: TextStyle(
                fontSize: 30,
                color: unlocked ? null : Colors.white24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: unlocked ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: unlocked
                        ? const Color(0xFFB39DDB)
                        : Colors.white24,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF7C3AED), size: 20),
        ],
      ),
    );
  }
}
