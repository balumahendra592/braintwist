// import 'package:flutter/material.dart';
// import '../data/puzzle_repository.dart';
// import '../models/puzzle_model.dart';
// import '../services/game_storage.dart';
// import '../services/ad_manager.dart';
// import '../services/sound_service.dart';
// import '../services/analytics_service.dart';
// import '../widgets/puzzle_widgets/multi_choice_puzzle.dart';
// import '../widgets/puzzle_widgets/type_answer_puzzle.dart';
// import '../widgets/puzzle_widgets/tap_target_puzzle.dart';
// import '../widgets/puzzle_widgets/drag_drop_puzzle.dart';
// import '../widgets/puzzle_widgets/visual_trick_puzzle.dart';
// import 'result_overlay.dart';

// class GameScreen extends StatefulWidget {
//   final int levelIndex;
//   const GameScreen({super.key, required this.levelIndex});

//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   late int _levelIndex;
//   late Puzzle _puzzle;
//   int _hintsUsed = 0;
//   bool _hintVisible = false;
//   bool _answered = false;
//   bool _showLoseAnim = false;
//   int _widgetKey = 0; // forces puzzle widget rebuild on next level

//   static const int hintCost = 10;

//   @override
//   void initState() {
//     super.initState();
//     _loadLevel(widget.levelIndex);
//     GameStorage.incrementGames();
//   }

//   void _loadLevel(int index) {
//     _levelIndex = index;
//     _puzzle = PuzzleRepository.getByLevel(index);
//     _hintsUsed = 0;
//     _hintVisible = false;
//     _answered = false;
//     _widgetKey++;
//     AnalyticsService.logLevelStart(index);
//   }

//   Future<void> _onAnswer(bool correct) async {
//     if (_answered) return;
//     setState(() => _answered = true);

//     if (correct) {
//       SoundService.correct();
//       final stars = GameStorage.calculateStars(_hintsUsed);
//       await GameStorage.completeLevel(_levelIndex);
//       await GameStorage.saveLevelStars(_levelIndex, stars);
//       await GameStorage.addScore(100 - (_hintsUsed * 20));
//       await GameStorage.addCoins(_puzzle.coinReward);
//       if (_hintsUsed == 0) await GameStorage.incrementHintFreeLevels();
//       AnalyticsService.logLevelComplete(
//         levelIndex: _levelIndex,
//         stars: stars,
//         hintsUsed: _hintsUsed,
//       );

//       if (!mounted) return;
//       final result = await Navigator.push<ResultAction>(
//         context,
//         PageRouteBuilder(
//           opaque: false,
//           pageBuilder: (_, __, ___) => ResultOverlay(
//             stars: stars,
//             coinsEarned: _puzzle.coinReward,
//             levelIndex: _levelIndex,
//             totalLevels: PuzzleRepository.totalCount,
//           ),
//         ),
//       );

//       if (!mounted) return;
//       if (result == ResultAction.next) {
//         final next = _levelIndex + 1;
//         if (next < PuzzleRepository.totalCount) {
//           setState(() => _loadLevel(next));
//         } else {
//           Navigator.popUntil(context, (r) => r.isFirst);
//         }
//       } else {
//         Navigator.pop(context);
//       }
//     } else {
//       SoundService.wrong();
//       setState(() => _showLoseAnim = true);
//       await Future.delayed(const Duration(milliseconds: 1600));
//       if (mounted) {
//         setState(() {
//           _showLoseAnim = false;
//           _loadLevel(_levelIndex);
//         });
//       }
//     }
//   }

//   void _watchAdForCoins() {
//     if (!AdManager.isRewardedReady) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Ad not ready yet, try again in a moment.'),
//           backgroundColor: Color(0xFF2D1B4E),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }
//     AdManager.showRewarded(onRewarded: (coins) async {
//       await GameStorage.addCoins(coins > 0 ? coins : 30);
//       if (mounted) {
//         setState(() {});
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('🎉 +${coins > 0 ? coins : 30} coins earned!'),
//             backgroundColor: const Color(0xFF064E3B),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     });
//   }

//   Future<void> _useHint() async {
//     if (!GameStorage.canAfford(hintCost)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Not enough coins! Watch a rewarded ad to earn coins.'),
//           backgroundColor: Color(0xFF78350F),
//         ),
//       );
//       return;
//     }
//     await GameStorage.spendCoins(hintCost);
//     SoundService.hint();
//     AnalyticsService.logHintUsed(_levelIndex);
//     setState(() {
//       _hintsUsed++;
//       _hintVisible = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final total = PuzzleRepository.totalCount;

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: const Color(0xFF1B0A3A),
//           body: SafeArea(
//             child: Column(
//               children: [
//                 // ── Top bar ──────────────────────────────
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(Icons.arrow_back_rounded,
//                             color: Colors.white70),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Level ${_levelIndex + 1}',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 16),
//                             ),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: LinearProgressIndicator(
//                                 value: (_levelIndex + 1) / total,
//                                 backgroundColor: const Color(0xFF3B0764),
//                                 valueColor: const AlwaysStoppedAnimation(
//                                     Color(0xFF7C3AED)),
//                                 minHeight: 5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       _coinChip(),
//                     ],
//                   ),
//                 ),

//                 // ── Question card ─────────────────────────
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2D1B4E),
//                       borderRadius: BorderRadius.circular(18),
//                       border:
//                           Border.all(color: const Color(0xFF7C3AED), width: 1),
//                     ),
//                     child: Text(
//                       _puzzle.question,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         height: 1.4,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),

//                 // ── Hint box ─────────────────────────────
//                 if (_hintVisible)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF78350F).withValues(alpha: 0.4),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                             color: const Color(0xFFD97706), width: 1),
//                       ),
//                       child: Row(
//                         children: [
//                           const Text('💡', style: TextStyle(fontSize: 18)),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               _puzzle.hintText,
//                               style: const TextStyle(
//                                   color: Color(0xFFFCD34D), fontSize: 14),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                 // ── Puzzle widget ─────────────────────────
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(16),
//                     child: _buildPuzzleWidget(),
//                   ),
//                 ),

//                 // ── Hint buttons ──────────────────────────
//                 if (!_answered && !_hintVisible)
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: const Color(0xFFD97706),
//                               side: const BorderSide(color: Color(0xFFD97706)),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                             ),
//                             icon: const Text('💡',
//                                 style: TextStyle(fontSize: 15)),
//                             label: const Text('Hint (-$hintCost coins)',
//                                 style: TextStyle(
//                                     fontSize: 13, fontWeight: FontWeight.w600)),
//                             onPressed: _useHint,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: const Color(0xFF7C3AED),
//                               side: const BorderSide(color: Color(0xFF7C3AED)),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                             ),
//                             icon: const Text('📺',
//                                 style: TextStyle(fontSize: 15)),
//                             label: const Text('Watch Ad (+30)',
//                                 style: TextStyle(
//                                     fontSize: 13, fontWeight: FontWeight.w600)),
//                             onPressed: _watchAdForCoins,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 // ── Banner ad ─────────────────────────────
//                 if (AdManager.bannerAd != null)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: AdManager.bannerWidget() ?? const SizedBox.shrink(),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         // ── Lose image overlay ────────────────────
//         if (_showLoseAnim)
//           Positioned.fill(
//             child: IgnorePointer(
//               child: Container(
//                 color: Colors.black54,
//                 child: const Center(
//                   child: Text('😢', style: TextStyle(fontSize: 96)),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildPuzzleWidget() {
//     switch (_puzzle.type) {
//       case PuzzleType.multiChoice:
//         return MultiChoicePuzzle(
//           key: ValueKey(_widgetKey),
//           puzzle: _puzzle,
//           onAnswer: _onAnswer,
//         );
//       case PuzzleType.typeAnswer:
//         return TypeAnswerPuzzle(
//           key: ValueKey(_widgetKey),
//           puzzle: _puzzle,
//           onAnswer: _onAnswer,
//         );
//       case PuzzleType.tapTarget:
//         return TapTargetPuzzle(
//           key: ValueKey(_widgetKey),
//           puzzle: _puzzle,
//           onAnswer: _onAnswer,
//         );
//       case PuzzleType.dragDrop:
//         return DragDropPuzzle(
//           key: ValueKey(_widgetKey),
//           puzzle: _puzzle,
//           onAnswer: _onAnswer,
//         );
//       case PuzzleType.visualTrick:
//         return VisualTrickPuzzle(
//           key: ValueKey(_widgetKey),
//           puzzle: _puzzle,
//           onAnswer: _onAnswer,
//         );
//     }
//   }

//   Widget _coinChip() => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         decoration: BoxDecoration(
//           color: const Color(0xFF10B981).withValues(alpha: 0.15),
//           borderRadius: BorderRadius.circular(20),
//           border:
//               Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.monetization_on_rounded,
//                 color: Color(0xFF10B981), size: 15),
//             const SizedBox(width: 4),
//             Text(
//               '${GameStorage.getCoins()}',
//               style: const TextStyle(
//                   color: Color(0xFF10B981),
//                   fontWeight: FontWeight.w700,
//                   fontSize: 13),
//             ),
//           ],
//         ),
//       );
// }
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../data/puzzle_repository.dart';
import '../models/puzzle_model.dart';
import '../services/game_storage.dart';
import '../services/ad_manager.dart';
import '../services/sound_service.dart';
import '../services/analytics_service.dart';
import '../widgets/puzzle_widgets/multi_choice_puzzle.dart';
import '../widgets/puzzle_widgets/type_answer_puzzle.dart';
import '../widgets/puzzle_widgets/tap_target_puzzle.dart';
import '../widgets/puzzle_widgets/drag_drop_puzzle.dart';
import '../widgets/puzzle_widgets/visual_trick_puzzle.dart';
import 'result_overlay.dart';

class GameScreen extends StatefulWidget {
  final int levelIndex;
  const GameScreen({super.key, required this.levelIndex});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _levelIndex;
  late Puzzle _puzzle;
  int _hintsUsed = 0;
  bool _hintVisible = false;
  bool _answered = false;
  bool _showLoseAnim = false;
  int _widgetKey = 0; // forces puzzle widget rebuild on next level

  // ── This screen's own banner — never shared with another screen ────
  // _bannerAdWidget is built ONCE when the ad finishes loading and then
  // reused as the same Widget instance on every subsequent build(). This
  // avoids constructing a brand-new AdWidget(ad: _bannerAd!) every time
  // setState fires for unrelated reasons (answering, hint usage, etc.),
  // which — combined with unkeyed conditional children in the Column
  // below — was causing Flutter's element-diffing to occasionally tear
  // down and remount the underlying platform view in a way that tripped
  // the "AdWidget already in the Widget tree" assertion.
  BannerAd? _bannerAd;
  Widget? _bannerAdWidget;
  bool _bannerLoaded = false;

  static const int hintCost = 10;

  @override
  void initState() {
    super.initState();
    _loadLevel(widget.levelIndex);
    GameStorage.incrementGames();
    _loadOwnBanner();
  }

  void _loadOwnBanner() {
    _bannerAd = AdManager.createBanner(
      onLoaded: () {
        if (mounted) {
          setState(() {
            _bannerLoaded = true;
            _bannerAdWidget = AdWidget(ad: _bannerAd!); // build ONCE
          });
        }
      },
      onFailed: () {
        if (mounted) setState(() => _bannerLoaded = false);
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  void _loadLevel(int index) {
    _levelIndex = index;
    _puzzle = PuzzleRepository.getByLevel(index);
    _hintsUsed = 0;
    _hintVisible = false;
    _answered = false;
    _widgetKey++;
    AnalyticsService.logLevelStart(index);
  }

  Future<void> _onAnswer(bool correct) async {
    if (_answered) return;
    setState(() => _answered = true);

    if (correct) {
      SoundService.correct();
      final stars = GameStorage.calculateStars(_hintsUsed);
      await GameStorage.completeLevel(_levelIndex);
      await GameStorage.saveLevelStars(_levelIndex, stars);
      await GameStorage.addScore(100 - (_hintsUsed * 20));
      await GameStorage.addCoins(_puzzle.coinReward);
      if (_hintsUsed == 0) await GameStorage.incrementHintFreeLevels();
      AnalyticsService.logLevelComplete(
        levelIndex: _levelIndex,
        stars: stars,
        hintsUsed: _hintsUsed,
      );

      if (!mounted) return;
      final result = await Navigator.push<ResultAction>(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => ResultOverlay(
            stars: stars,
            coinsEarned: _puzzle.coinReward,
            levelIndex: _levelIndex,
            totalLevels: PuzzleRepository.totalCount,
          ),
        ),
      );

      if (!mounted) return;
      if (result == ResultAction.next) {
        final next = _levelIndex + 1;
        if (next < PuzzleRepository.totalCount) {
          setState(() => _loadLevel(next));
        } else {
          Navigator.popUntil(context, (r) => r.isFirst);
        }
      } else {
        Navigator.pop(context);
      }
    } else {
      SoundService.wrong();
      setState(() => _showLoseAnim = true);
      await Future.delayed(const Duration(milliseconds: 1600));
      if (mounted) {
        setState(() {
          _showLoseAnim = false;
          _loadLevel(_levelIndex);
        });
      }
    }
  }

  void _watchAdForCoins() {
    if (!AdManager.isRewardedReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready yet, try again in a moment.'),
          backgroundColor: Color(0xFF2D1B4E),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    AdManager.showRewarded(onRewarded: (coins) async {
      await GameStorage.addCoins(coins > 0 ? coins : 30);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 +${coins > 0 ? coins : 30} coins earned!'),
            backgroundColor: const Color(0xFF064E3B),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  Future<void> _useHint() async {
    if (!GameStorage.canAfford(hintCost)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins! Watch a rewarded ad to earn coins.'),
          backgroundColor: Color(0xFF78350F),
        ),
      );
      return;
    }
    await GameStorage.spendCoins(hintCost);
    SoundService.hint();
    AnalyticsService.logHintUsed(_levelIndex);
    setState(() {
      _hintsUsed++;
      _hintVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = PuzzleRepository.totalCount;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF1B0A3A),
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────
                KeyedSubtree(
                  key: const ValueKey('top_bar'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white70),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Level ${_levelIndex + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (_levelIndex + 1) / total,
                                  backgroundColor: const Color(0xFF3B0764),
                                  valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF7C3AED)),
                                  minHeight: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _coinChip(),
                      ],
                    ),
                  ),
                ),

                // ── Question card ─────────────────────────
                KeyedSubtree(
                  key: const ValueKey('question_card'),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D1B4E),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: const Color(0xFF7C3AED), width: 1),
                      ),
                      child: Text(
                        _puzzle.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                // ── Hint box ─────────────────────────────
                if (_hintVisible)
                  KeyedSubtree(
                    key: const ValueKey('hint_box'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF78350F).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFD97706), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _puzzle.hintText,
                                style: const TextStyle(
                                    color: Color(0xFFFCD34D), fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Puzzle widget ─────────────────────────
                KeyedSubtree(
                  key: const ValueKey('puzzle_area'),
                  child: Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildPuzzleWidget(),
                    ),
                  ),
                ),

                // ── Hint buttons ──────────────────────────
                if (!_answered && !_hintVisible)
                  KeyedSubtree(
                    key: const ValueKey('hint_buttons'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFD97706),
                                side:
                                    const BorderSide(color: Color(0xFFD97706)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Text('💡',
                                  style: TextStyle(fontSize: 15)),
                              label: const Text('Hint (-$hintCost coins)',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              onPressed: _useHint,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF7C3AED),
                                side:
                                    const BorderSide(color: Color(0xFF7C3AED)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Text('📺',
                                  style: TextStyle(fontSize: 15)),
                              label: const Text('Watch Ad (+30)',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              onPressed: _watchAdForCoins,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Banner ad (this screen's own instance, built once) ─
                if (_bannerLoaded &&
                    _bannerAdWidget != null &&
                    _bannerAd != null)
                  KeyedSubtree(
                    key: const ValueKey('banner_ad'),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: _bannerAdWidget!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // ── Lose image overlay ────────────────────
        if (_showLoseAnim)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: Text('😢', style: TextStyle(fontSize: 96)),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPuzzleWidget() {
    switch (_puzzle.type) {
      case PuzzleType.multiChoice:
        return MultiChoicePuzzle(
          key: ValueKey(_widgetKey),
          puzzle: _puzzle,
          onAnswer: _onAnswer,
        );
      case PuzzleType.typeAnswer:
        return TypeAnswerPuzzle(
          key: ValueKey(_widgetKey),
          puzzle: _puzzle,
          onAnswer: _onAnswer,
        );
      case PuzzleType.tapTarget:
        return TapTargetPuzzle(
          key: ValueKey(_widgetKey),
          puzzle: _puzzle,
          onAnswer: _onAnswer,
        );
      case PuzzleType.dragDrop:
        return DragDropPuzzle(
          key: ValueKey(_widgetKey),
          puzzle: _puzzle,
          onAnswer: _onAnswer,
        );
      case PuzzleType.visualTrick:
        return VisualTrickPuzzle(
          key: ValueKey(_widgetKey),
          puzzle: _puzzle,
          onAnswer: _onAnswer,
        );
    }
  }

  Widget _coinChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.monetization_on_rounded,
                color: Color(0xFF10B981), size: 15),
            const SizedBox(width: 4),
            Text(
              '${GameStorage.getCoins()}',
              style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
          ],
        ),
      );
}
