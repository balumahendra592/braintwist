import 'package:flutter/material.dart';
import '../services/ad_manager.dart';
import '../services/game_storage.dart';

class ResultOverlay extends StatefulWidget {
  final int stars;
  final int coinsEarned;
  final int levelIndex;
  final int totalLevels;

  const ResultOverlay({
    super.key,
    required this.stars,
    required this.coinsEarned,
    required this.levelIndex,
    required this.totalLevels,
  });

  @override
  State<ResultOverlay> createState() => _ResultOverlayState();
}

class _ResultOverlayState extends State<ResultOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    // Fire interstitial every 3 completed levels
    AdManager.onLevelComplete();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _hasNext => widget.levelIndex + 1 < widget.totalLevels;

  void _onWatchAd() {
    if (!AdManager.isRewardedReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready yet, try again shortly.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    AdManager.showRewarded(onRewarded: (coins) async {
      final amount = coins > 0 ? coins : 30;
      await GameStorage.addCoins(amount);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 +$amount coins added!'),
            backgroundColor: const Color(0xFF064E3B),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF1B0A3A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: const Color(0xFF7C3AED), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Win image ─────────────────────────
                  const Text('🎉', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 4),
                  const Text(
                    'SOLVED!',
                    style: TextStyle(
                      color: Color(0xFF7C3AED),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Stars ────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.star_rounded,
                          size: 48,
                          color: i < widget.stars
                              ? const Color(0xFFF59E0B)
                              : Colors.white24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.stars == 3
                        ? 'Perfect — no hints used!'
                        : widget.stars == 2
                            ? 'Great — 1 hint used'
                            : 'Good — keep practising!',
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  // ── Coins earned ──────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF10B981)
                              .withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🪙',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          '+${widget.coinsEarned} coins earned',
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Buttons ───────────────────────────
                  if (_hasNext)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                        ),
                        onPressed: () =>
                            Navigator.pop(context, ResultAction.next),
                        child: const Text('NEXT LEVEL →',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Watch ad for coins
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF7C3AED),
                        side: const BorderSide(color: Color(0xFF7C3AED)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Text('📺', style: TextStyle(fontSize: 16)),
                      label: const Text('Watch Ad for +30 Coins',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      onPressed: _onWatchAd,
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(
                            color: Colors.white24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                      ),
                      onPressed: () =>
                          Navigator.pop(context, ResultAction.home),
                      child: const Text('🏠 Back to Home',
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ResultAction { next, home }
