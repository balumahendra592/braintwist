import 'package:flutter/material.dart';
import '../services/game_storage.dart';
import '../data/puzzle_repository.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _maybeShowRateUs();
  }

  void _maybeShowRateUs() {
    if (GameStorage.getSessionCount() == 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xFF2D1B4E),
            title: const Text('Enjoying Brain Twist? 🧠',
                style: TextStyle(color: Colors.white)),
            content: const Text(
              'Rate us 5 stars on the Play Store — it helps us make more puzzles!',
              style: TextStyle(color: Color(0xFFB39DDB)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Later', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED)),
                onPressed: () => Navigator.pop(context),
                child: const Text('Rate Now ⭐'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = GameStorage.getCompletedLevels();
    final coins     = GameStorage.getCoins();
    final score     = GameStorage.getTotalScore();
    final total     = PuzzleRepository.totalCount;

    int easyStars   = 0;
    int mediumStars = 0;
    int hardStars   = 0;
    int expertStars = 0;
    for (int i = 0;  i < 25;  i++) { easyStars   += GameStorage.getLevelStars(i); }
    for (int i = 25; i < 50;  i++) { mediumStars += GameStorage.getLevelStars(i); }
    for (int i = 50; i < 75;  i++) { hardStars   += GameStorage.getLevelStars(i); }
    for (int i = 75; i < 100; i++) { expertStars += GameStorage.getLevelStars(i); }

    return Scaffold(
      backgroundColor: const Color(0xFF1B0A3A),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chip(Icons.star_rounded, '$score', const Color(0xFFF59E0B)),
                  const Text(
                    'BRAIN TWIST',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  Row(
                    children: [
                      _chip(Icons.monetization_on_rounded, '$coins',
                          const Color(0xFF10B981)),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()),
                        ).then((_) => setState(() {})),
                        child: const Icon(Icons.settings_rounded,
                            color: Colors.white54, size: 26),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Brain icon + progress ─────────────────
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.45),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                  child: Text('🧠', style: TextStyle(fontSize: 50))),
            ),
            const SizedBox(height: 10),
            Text(
              '$completed / $total Levels Solved',
              style: const TextStyle(color: Color(0xFFB39DDB), fontSize: 13),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total > 0 ? completed / total : 0,
                  backgroundColor: const Color(0xFF3B0764),
                  valueColor:
                      const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
                  minHeight: 8,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Chapter cards ─────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _chapterCard(
                      context,
                      emoji: '🌱',
                      title: 'Easy Warm-up',
                      sub: 'Levels 1–25',
                      stars: easyStars,
                      maxStars: 75,
                      color: const Color(0xFF059669),
                      bg: const Color(0xFF064E3B),
                      startLevel: 0,
                    ),
                    const SizedBox(height: 12),
                    _chapterCard(
                      context,
                      emoji: '🔥',
                      title: 'Getting Tricky',
                      sub: 'Levels 26–50',
                      stars: mediumStars,
                      maxStars: 75,
                      color: const Color(0xFFD97706),
                      bg: const Color(0xFF78350F),
                      startLevel: 25,
                    ),
                    const SizedBox(height: 12),
                    _chapterCard(
                      context,
                      emoji: '💥',
                      title: 'Mind Benders',
                      sub: 'Levels 51–75',
                      stars: hardStars,
                      maxStars: 75,
                      color: const Color(0xFFDC2626),
                      bg: const Color(0xFF7F1D1D),
                      startLevel: 50,
                    ),
                    const SizedBox(height: 12),
                    _chapterCard(
                      context,
                      emoji: '🧬',
                      title: 'Expert Zone',
                      sub: 'Levels 76–100',
                      stars: expertStars,
                      maxStars: 75,
                      color: const Color(0xFF7C3AED),
                      bg: const Color(0xFF3B0764),
                      startLevel: 75,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── Play button ───────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    shadowColor:
                        const Color(0xFF7C3AED).withValues(alpha: 0.5),
                  ),
                  onPressed: () {
                    final nextLevel = completed < total ? completed : 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LevelSelectScreen(startLevel: nextLevel),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: const Text(
                    'PLAY',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      );

  Widget _chapterCard(
    BuildContext context, {
    required String emoji,
    required String title,
    required String sub,
    required int stars,
    required int maxStars,
    required Color color,
    required Color bg,
    required int startLevel,
  }) =>
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LevelSelectScreen(startLevel: startLevel)),
        ).then((_) => setState(() {})),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: color,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    Text(sub,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: i <
                                  (stars / maxStars * 5).round()
                              ? const Color(0xFFF59E0B)
                              : Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      );
}
