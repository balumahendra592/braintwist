import 'package:flutter/material.dart';
import '../services/game_storage.dart';
import '../data/puzzle_repository.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  final int startLevel;
  const LevelSelectScreen({super.key, this.startLevel = 0});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  static const _chapters = [
    {'title': '🌱 Easy Warm-up',   'range': '1–25',   'color': Color(0xFF059669), 'start': 0,  'end': 25},
    {'title': '🔥 Getting Tricky', 'range': '26–50',  'color': Color(0xFFD97706), 'start': 25, 'end': 50},
    {'title': '💥 Mind Benders',   'range': '51–75',  'color': Color(0xFFDC2626), 'start': 50, 'end': 75},
    {'title': '🧬 Expert Zone',    'range': '76–100', 'color': Color(0xFF7C3AED), 'start': 75, 'end': 100},
  ];

  @override
  Widget build(BuildContext context) {
    final total = PuzzleRepository.totalCount;

    return Scaffold(
      backgroundColor: const Color(0xFF1B0A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B0A3A),
        foregroundColor: Colors.white,
        title: const Text('Select Level',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _chapters.length,
        itemBuilder: (context, ci) {
          final chapter = _chapters[ci];
          final start   = chapter['start'] as int;
          final end     = chapter['end'] as int;
          final color   = chapter['color'] as Color;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chapter header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Text(chapter['title'] as String,
                        style: TextStyle(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Text('Levels ${chapter['range']}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
              // Level grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: end - start,
                itemBuilder: (context, i) {
                  final levelIndex = start + i;
                  final unlocked   = levelIndex < total &&
                      GameStorage.isLevelUnlocked(levelIndex);
                  final stars      = GameStorage.getLevelStars(levelIndex);

                  return GestureDetector(
                    onTap: unlocked
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    GameScreen(levelIndex: levelIndex),
                              ),
                            ).then((_) => setState(() {}))
                        : null,
                    child: _LevelTile(
                      number: levelIndex + 1,
                      unlocked: unlocked,
                      stars: stars,
                      color: color,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final int number;
  final bool unlocked;
  final int stars;
  final Color color;

  const _LevelTile({
    required this.number,
    required this.unlocked,
    required this.stars,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked ? color.withValues(alpha: 0.15) : const Color(0xFF2D1B4E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? color.withValues(alpha: 0.6) : Colors.white12,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!unlocked)
            const Icon(Icons.lock_rounded, color: Colors.white24, size: 20)
          else
            Text(
              '$number',
              style: TextStyle(
                color: unlocked ? color : Colors.white24,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          if (unlocked && stars > 0) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Icon(
                  Icons.star_rounded,
                  size: 10,
                  color: i < stars
                      ? const Color(0xFFF59E0B)
                      : Colors.white24,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
