import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';

class VisualTrickPuzzle extends StatefulWidget {
  final Puzzle puzzle;
  final void Function(bool correct) onAnswer;

  const VisualTrickPuzzle({
    super.key,
    required this.puzzle,
    required this.onAnswer,
  });

  @override
  State<VisualTrickPuzzle> createState() => _VisualTrickPuzzleState();
}

class _VisualTrickPuzzleState extends State<VisualTrickPuzzle> {
  bool _answered = false;

  void _tap(String targetId) {
    if (_answered) return;
    setState(() => _answered = true);
    final correct = targetId == widget.puzzle.correctTargetId;
    Future.delayed(const Duration(milliseconds: 600), () {
      widget.onAnswer(correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.puzzle.correctTargetId) {
      // ── Stroop variants ──────────────────────────────────────
      case 'red_word':
      case 'blue_word':
      case 'green_word':
      case 'yellow_word':
        return _stroopGame();

      // ── T-shirt holes ────────────────────────────────────────
      case 'eight_holes':
        return _tshirtHolesPuzzle();

      // ── Hidden character grids ───────────────────────────────
      case 'eight_hidden':
        return _hiddenGrid(
          tiles: ['3', '6', '8', 'B', '9', '0', 'G', 'E', 'S', 'Q'],
          ids:   ['w0', 'w1', 'eight_hidden', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8', 'w9'],
          successMsg: '🎉 There it is — the number 8!',
        );
      case 'b_hidden':
        return _hiddenGrid(
          tiles: ['8','8','8','B','8','8','8','8','8','8','8','8'],
          ids:   ['w0','w1','w2','b_hidden','w4','w5','w6','w7','w8','w9','w10','w11'],
          successMsg: '🎉 Found it! B was hiding among the 8s!',
        );
      case 'c_hidden':
        return _hiddenGrid(
          tiles: ['O','O','O','O','O','C','O','O','O','O','O','O'],
          ids:   ['w0','w1','w2','w3','w4','c_hidden','w6','w7','w8','w9','w10','w11'],
          successMsg: '🎉 Sharp eyes! C hides easily among Os!',
        );
      case 'nine_hidden':
        return _hiddenGrid(
          tiles: ['6','6','6','6','6','6','6','9','6','6','6','6'],
          ids:   ['w0','w1','w2','w3','w4','w5','w6','nine_hidden','w8','w9','w10','w11'],
          successMsg: '🎉 9 found! A 9 upside-down looks like a 6 too!',
        );
      case 'p_hidden':
        return _hiddenGrid(
          tiles: ['F','F','F','F','F','F','F','F','P','F','F','F'],
          ids:   ['w0','w1','w2','w3','w4','w5','w6','w7','p_hidden','w9','w10','w11'],
          successMsg: '🎉 There\'s the P — disguised among the Fs!',
        );

      // ── Emoji odd-one-out ────────────────────────────────────
      case 'odd_smiley':
        return _emojiOddGrid(
          normal: '😊', odd: '😮', oddPos: 9,
          rows: 4, cols: 4,
          successMsg: '🎉 Got it — the surprised face was hiding!',
        );
      case 'odd_star':
        return _emojiOddGrid(
          normal: '★', odd: '☆', oddPos: 11,
          rows: 4, cols: 4,
          successMsg: '🎉 That hollow star gave itself away!',
        );
      case 'odd_triangle':
        return _emojiOddGrid(
          normal: '▲', odd: '△', oddPos: 6,
          rows: 4, cols: 4,
          successMsg: '🎉 The hollow triangle was the imposter!',
        );
      case 'odd_moon':
        return _emojiOddGrid(
          normal: '🌙', odd: '☀️', oddPos: 7,
          rows: 3, cols: 5,
          successMsg: '🎉 The sun was hiding among the moons!',
        );

      // ── Flip / upside-down ───────────────────────────────────
      case 'flip_6':
        return _flipGame(
          displayChar: '6',
          choices: [
            ('9', 'wrong_9'), ('b', 'wrong_b'), ('6', 'flip_6'), ('p', 'wrong_p'),
          ],
          successMsg: '🎉 It IS a 6 — just shown upside down as a 9!',
        );
      case 'flip_mom':
        return _flipGame(
          displayChar: 'WOW',
          choices: [
            ('MOM', 'flip_mom'), ('WOW', 'wrong_WOW'), ('WOM', 'wrong_WOM'), ('MOW', 'wrong_MOW'),
          ],
          successMsg: '🎉 WOW upside down spells MOM! W → M, O → O, W → M.',
        );

      // ── Count puzzles ────────────────────────────────────────
      case 'count_f':
        return _countFGame();
      case 'count_dots_7':
        return _countDotsGame();
      case 'count_squares_6':
        return _countSquaresGame();
      case 'count_triangles_5':
        return _countTrianglesGame();

      // ── Optical illusions ────────────────────────────────────
      case 'mueller_same':
        return _muellerLyerGame();
      case 'ebbinghaus':
        return _ebbinghausGame();

      // ── Fallback (level 100 meta-trick) ──────────────────────
      default:
        return _fallback();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // STROOP EFFECT
  // ═══════════════════════════════════════════════════════════

  Widget _stroopGame() {
    final targetId = widget.puzzle.correctTargetId ?? '';
    final colorName = {
      'red_word': 'RED',
      'blue_word': 'BLUE',
      'green_word': 'GREEN',
      'yellow_word': 'YELLOW',
    }[targetId] ?? 'RED';

    return Column(
      children: [
        Text(
          'Focus on INK COLOR — not the word!\nTap the word printed in $colorName',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _colorWord('BLUE',   const Color(0xFF3B82F6), 'blue_word'),
            _colorWord('GREEN',  const Color(0xFF10B981), 'green_word'),
            _colorWord('RED',    const Color(0xFFEF4444), 'red_word'),
            _colorWord('YELLOW', const Color(0xFFD97706), 'yellow_word'),
          ],
        ),
        if (_answered) ...[
          const SizedBox(height: 16),
          Text(
            '🎉 $colorName — the ink, not what it says!',
            style: const TextStyle(color: Color(0xFF34D399), fontSize: 15, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _colorWord(String text, Color color, String id) {
    final isCorrect = id == widget.puzzle.correctTargetId;
    return GestureDetector(
      onTap: () => _tap(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _answered && isCorrect ? color.withValues(alpha: 0.2) : const Color(0xFF2D1B4E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _answered && isCorrect ? color : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // T-SHIRT HOLES
  // ═══════════════════════════════════════════════════════════

  Widget _tshirtHolesPuzzle() {
    final opts = [
      ('2 holes', 'wrong_2'),
      ('4 holes', 'wrong_4'),
      ('6 holes', 'wrong_6'),
      ('8 holes', 'eight_holes'),
    ];
    return Column(
      children: [
        const Text('👕', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 12),
        const Text(
          'Count EVERY hole — front AND back of each opening:',
          style: TextStyle(color: Colors.white60, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12, runSpacing: 12,
          alignment: WrapAlignment.center,
          children: opts.map((o) {
            final isCorrect = o.$2 == 'eight_holes';
            Color bg = const Color(0xFF2D1B4E);
            Color border = Colors.white24;
            if (_answered && isCorrect) {
              bg = const Color(0xFF064E3B);
              border = const Color(0xFF059669);
            }
            return GestureDetector(
              onTap: () => _tap(o.$2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: Text(o.$1,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            );
          }).toList(),
        ),
        if (_answered) ...[
          const SizedBox(height: 16),
          const Text('🎉 Neck=2, Arms=4, Bottom=2 → 8 total!',
              style: TextStyle(color: Color(0xFF34D399), fontSize: 14, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HIDDEN CHARACTER GRID
  // ═══════════════════════════════════════════════════════════

  Widget _hiddenGrid({
    required List<String> tiles,
    required List<String> ids,
    required String successMsg,
  }) {
    return Column(
      children: [
        Wrap(
          spacing: 10, runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(tiles.length, (i) {
            final isCorrect = ids[i] == widget.puzzle.correctTargetId;
            Color bg = const Color(0xFF2D1B4E);
            Color border = Colors.white24;
            if (_answered && isCorrect) {
              bg = const Color(0xFF064E3B);
              border = const Color(0xFF059669);
            }
            return GestureDetector(
              onTap: () => _tap(ids[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 58, height: 58,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: Center(
                  child: Text(tiles[i],
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                ),
              ),
            );
          }),
        ),
        if (_answered) ...[
          const SizedBox(height: 16),
          Text(successMsg,
              style: const TextStyle(color: Color(0xFF34D399), fontSize: 14, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // EMOJI ODD-ONE-OUT GRID
  // ═══════════════════════════════════════════════════════════

  Widget _emojiOddGrid({
    required String normal,
    required String odd,
    required int oddPos,
    required int rows,
    required int cols,
    required String successMsg,
  }) {
    final total = rows * cols;
    return Column(
      children: [
        Wrap(
          spacing: 6, runSpacing: 6,
          alignment: WrapAlignment.center,
          children: List.generate(total, (i) {
            final isOdd = i == oddPos;
            final emoji = isOdd ? odd : normal;
            final tapId = isOdd ? (widget.puzzle.correctTargetId ?? 'wrong') : 'wrong_$i';
            return GestureDetector(
              onTap: () => _tap(tapId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: _answered && isOdd ? const Color(0xFF064E3B) : const Color(0xFF2D1B4E),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _answered && isOdd ? const Color(0xFF059669) : Colors.white24,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
            );
          }),
        ),
        if (_answered) ...[
          const SizedBox(height: 16),
          Text(successMsg,
              style: const TextStyle(color: Color(0xFF34D399), fontSize: 14, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FLIP / UPSIDE-DOWN
  // ═══════════════════════════════════════════════════════════

  Widget _flipGame({
    required String displayChar,
    required List<(String label, String id)> choices,
    required String successMsg,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF7C3AED), width: 1.5),
          ),
          child: RotatedBox(
            quarterTurns: 2,
            child: Text(
              displayChar,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w900,
                letterSpacing: 6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text('↕ Flip it right-side up in your mind',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 20),
        _choiceButtons(choices),
        if (_answered) ...[
          const SizedBox(height: 16),
          Text(successMsg,
              style: const TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // COUNT F IN PASSAGE
  // ═══════════════════════════════════════════════════════════

  Widget _countFGame() {
    const passage =
        'FINISHED FILES ARE THE\nRESULT OF YEARS OF\nSCIENTIFIC STUDY COMBINED\nWITH THE EXPERIENCE OF YEARS';
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            passage,
            style: TextStyle(
                color: Colors.white, fontSize: 15, height: 1.9,
                fontWeight: FontWeight.w500, letterSpacing: 1.2),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Count every F — uppercase only',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 20),
        _choiceButtons([
          ('3', 'wrong_3'), ('4', 'wrong_4'), ('5', 'wrong_5'), ('6', 'count_f'),
        ]),
        if (_answered) ...[
          const SizedBox(height: 16),
          const Text(
            '🎉 SIX! People skip the Fs in "OF"\nbecause "of" sounds like "ov"!',
            style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // COUNT DOTS
  // ═══════════════════════════════════════════════════════════

  Widget _countDotsGame() {
    // 7 dots: row1=3, row2=2, row3=2
    const grid = [
      [1, 0, 1, 0, 1],
      [0, 1, 0, 1, 0],
      [1, 0, 1, 0, 0],
    ];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: grid
                .map((row) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row
                          .map((cell) => SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(
                                  child: cell == 1
                                      ? Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                        )
                                      : const SizedBox(),
                                ),
                              ))
                          .toList(),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        _choiceButtons([
          ('5', 'wrong_5'), ('6', 'wrong_6'), ('7', 'count_dots_7'), ('8', 'wrong_8'),
        ]),
        if (_answered) ...[
          const SizedBox(height: 16),
          const Text('🎉 7 dots! Row 1: 3, Row 2: 2, Row 3: 2 = 7!',
              style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // COUNT SQUARES
  // ═══════════════════════════════════════════════════════════

  Widget _countSquaresGame() {
    // 3 squares side by side: 3 individual + 2 pairs + 1 trio = 6
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _squareTile(), _squareTile(), _squareTile(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text('Squares sharing sides can be combined!',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 20),
        _choiceButtons([
          ('3', 'wrong_3'), ('4', 'wrong_4'), ('6', 'count_squares_6'), ('9', 'wrong_9'),
        ]),
        if (_answered) ...[
          const SizedBox(height: 16),
          const Text('🎉 3 singles + 2 pairs + 1 triple = 6 squares!',
              style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  Widget _squareTile() => Container(
        width: 68, height: 68,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white, width: 2),
        ),
      );

  // ═══════════════════════════════════════════════════════════
  // COUNT TRIANGLES
  // ═══════════════════════════════════════════════════════════

  Widget _countTrianglesGame() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const CustomPaint(
            size: Size(200, 174),
            painter: _TrianglePainter(),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Count EVERY triangle — big, small, and hidden!',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 20),
        _choiceButtons([
          ('3', 'wrong_3'), ('4', 'wrong_4'), ('5', 'count_triangles_5'), ('6', 'wrong_6'),
        ]),
        if (_answered) ...[
          const SizedBox(height: 16),
          const Text('🎉 4 small triangles + 1 big outer triangle = 5!',
              style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // MÜLLER-LYER ILLUSION
  // ═══════════════════════════════════════════════════════════

  Widget _muellerLyerGame() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const CustomPaint(
            size: Size(300, 110),
            painter: _MuellerPainter(),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Trust maths, not your eyes!',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 20),
        _choiceButtons([
          ('Line A is longer', 'wrong_a'),
          ('Both SAME length ✓', 'mueller_same'),
          ('Line B is longer', 'wrong_b'),
          ('Impossible to tell', 'wrong_unc'),
        ]),
        if (_answered) ...[
          const SizedBox(height: 16),
          const Text('🎉 Same length! Arrow direction tricks your brain!',
              style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // EBBINGHAUS ILLUSION
  // ═══════════════════════════════════════════════════════════

  Widget _ebbinghausGame() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ebbGroup(centerR: 26, surroundR: 40, count: 5, label: 'A'),
              const Text('vs',
                  style: TextStyle(color: Colors.white38, fontSize: 18, fontWeight: FontWeight.w600)),
              _ebbGroup(centerR: 26, surroundR: 11, count: 7, label: 'B'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text('Compare only the ORANGE circles',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 20),
        _choiceButtons([
          ('A is bigger', 'wrong_a'),
          ('B is bigger', 'wrong_b'),
          ('They\'re the SAME', 'ebbinghaus'),
          ('Can\'t tell', 'wrong_unc'),
        ]),
        if (_answered) ...[
          const SizedBox(height: 16),
          const Text(
            '🎉 Identical! Big surroundings make A look smaller.\nSmall surroundings make B look bigger.',
            style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _ebbGroup({required double centerR, required double surroundR, required int count, required String label}) {
    final totalR = centerR + surroundR * 2.4;
    final size = totalR * 2 + 8;
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _EbbPainter(centerR: centerR, surroundR: surroundR, count: count),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // GENERIC CHOICE BUTTONS
  // ═══════════════════════════════════════════════════════════

  Widget _choiceButtons(List<(String label, String id)> choices) {
    return Wrap(
      spacing: 12, runSpacing: 12,
      alignment: WrapAlignment.center,
      children: choices.map((c) {
        final isCorrect = c.$2 == widget.puzzle.correctTargetId;
        Color bg = const Color(0xFF2D1B4E);
        Color border = Colors.white24;
        if (_answered && isCorrect) {
          bg = const Color(0xFF064E3B);
          border = const Color(0xFF059669);
        }
        return GestureDetector(
          onTap: () => _tap(c.$2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1.5),
            ),
            child: Text(c.$1,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FALLBACK (meta-trick / level 100)
  // ═══════════════════════════════════════════════════════════

  Widget _fallback() {
    return Column(
      children: [
        const Text(
          'Think outside the box!',
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => _tap(widget.puzzle.correctTargetId ?? ''),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B4E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF7C3AED), width: 1.5),
            ),
            child: const Text('Tap here!',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CUSTOM PAINTERS
// ─────────────────────────────────────────────────────────────

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final top = Offset(size.width / 2, 0);
    final bl = Offset(0, size.height);
    final br = Offset(size.width, size.height);

    // Outer triangle
    canvas.drawLine(top, bl, paint);
    canvas.drawLine(top, br, paint);
    canvas.drawLine(bl, br, paint);

    // Midpoints connecting to form 4 inner triangles
    final midLeft   = Offset((top.dx + bl.dx) / 2, (top.dy + bl.dy) / 2);
    final midRight  = Offset((top.dx + br.dx) / 2, (top.dy + br.dy) / 2);
    final midBottom = Offset((bl.dx + br.dx) / 2, (bl.dy + br.dy) / 2);

    canvas.drawLine(midLeft, midRight, paint);
    canvas.drawLine(midLeft, midBottom, paint);
    canvas.drawLine(midRight, midBottom, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MuellerPainter extends CustomPainter {
  const _MuellerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const arrowLen = 18.0;
    const lineStart = 36.0;
    final lineEnd = size.width - 36.0;
    final lineLen = lineEnd - lineStart;

    void drawLabel(String text, Offset pos) {
      final tp = TextPainter(
        text: TextSpan(
            text: text, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos);
    }

    // Line A (top) — outward arrows (looks longer)
    final yA = size.height * 0.3;
    canvas.drawLine(Offset(lineStart, yA), Offset(lineEnd, yA), paint);
    canvas.drawLine(Offset(lineStart, yA), Offset(lineStart - arrowLen, yA - arrowLen), paint);
    canvas.drawLine(Offset(lineStart, yA), Offset(lineStart - arrowLen, yA + arrowLen), paint);
    canvas.drawLine(Offset(lineEnd, yA), Offset(lineEnd + arrowLen, yA - arrowLen), paint);
    canvas.drawLine(Offset(lineEnd, yA), Offset(lineEnd + arrowLen, yA + arrowLen), paint);
    drawLabel('A', Offset(4, yA - 8));

    // Line B (bottom) — inward arrows (looks shorter)
    final yB = size.height * 0.72;
    canvas.drawLine(Offset(lineStart, yB), Offset(lineEnd, yB), paint);
    canvas.drawLine(Offset(lineStart, yB), Offset(lineStart + arrowLen, yB - arrowLen), paint);
    canvas.drawLine(Offset(lineStart, yB), Offset(lineStart + arrowLen, yB + arrowLen), paint);
    canvas.drawLine(Offset(lineEnd, yB), Offset(lineEnd - arrowLen, yB - arrowLen), paint);
    canvas.drawLine(Offset(lineEnd, yB), Offset(lineEnd - arrowLen, yB + arrowLen), paint);
    drawLabel('B', Offset(4, yB - 8));

    // Mark both endpoints with tiny ticks to prove equal length
    final tickPaint = Paint()
      ..color = const Color(0xFF7C3AED).withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    void tick(double x, double y) {
      canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), tickPaint);
    }
    tick(lineStart, yA); tick(lineEnd, yA);
    tick(lineStart, yB); tick(lineEnd, yB);

    // Show line length hint
    final hintPaint = Paint()
      ..color = const Color(0xFF7C3AED).withValues(alpha: 0.3)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(lineStart, yA + 6), Offset(lineStart, yB - 6), hintPaint);
    canvas.drawLine(Offset(lineEnd, yA + 6), Offset(lineEnd, yB - 6), hintPaint);
    drawLabel('${lineLen.toInt()}px', Offset(size.width / 2 - 18, size.height - 14));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _EbbPainter extends CustomPainter {
  final double centerR, surroundR;
  final int count;
  const _EbbPainter({required this.centerR, required this.surroundR, required this.count});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final dist = centerR + surroundR + 6;

    final surroundPaint = Paint()..color = Colors.white.withValues(alpha: 0.25);
    final centerPaint = Paint()..color = Colors.orange;

    for (int i = 0; i < count; i++) {
      final angle = (2 * math.pi * i / count) - math.pi / 2;
      final sx = cx + dist * math.cos(angle);
      final sy = cy + dist * math.sin(angle);
      canvas.drawCircle(Offset(sx, sy), surroundR, surroundPaint);
    }
    canvas.drawCircle(Offset(cx, cy), centerR, centerPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
