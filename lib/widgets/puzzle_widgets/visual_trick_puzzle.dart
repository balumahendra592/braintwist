import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';

/// Visual trick puzzle — the answer is tapping something unexpected.
/// For puzzle 25: "Tap the word that is RED" — the word "RED" in the
/// question text itself is styled in red; tapping it is the answer.
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
      case 'red_word':
        return _redWordPuzzle();
      case 'eight_holes':
        return _tshirtHolesPuzzle();
      case 'eight_hidden':
        return _findEightPuzzle();
      default:
        return _fallback();
    }
  }

  Widget _redWordPuzzle() {
    return Column(
      children: [
        const Text(
          'Look carefully at the words below:',
          style: TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _colorWord('BLUE',   Colors.blue,   'blue_word'),
            _colorWord('GREEN',  Colors.green,  'green_word'),
            _colorWord('RED',    Colors.red,    'red_word'),
            _colorWord('YELLOW', Colors.yellow, 'yellow_word'),
          ],
        ),
        const SizedBox(height: 24),
        if (_answered)
          const Text(
            '🎉 Yes! RED is the word that IS red!',
            style: TextStyle(
                color: Color(0xFF34D399),
                fontSize: 15,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _colorWord(String text, Color color, String id) {
    return GestureDetector(
      onTap: () => _tap(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _answered && id == 'red_word'
              ? color.withValues(alpha: 0.2)
              : const Color(0xFF2D1B4E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _answered && id == 'red_word' ? color : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _tshirtHolesPuzzle() {
    // Options: 2, 4, 6, 8 — correct is 8 (neck + 2 arms + bottom = 4 openings × 2 sides = 8)
    final options = ['2 holes', '4 holes', '6 holes', '8 holes'];
    const correctId = 'eight_holes';
    return Column(
      children: [
        const Text('👕', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        const Text(
          'Count every hole (front AND back of each opening):',
          style: TextStyle(color: Colors.white60, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: options.map((opt) {
            final id = opt == '8 holes' ? 'eight_holes' : opt;
            final isCorrect = id == correctId;
            Color bg     = const Color(0xFF2D1B4E);
            Color border = Colors.white24;
            if (_answered && opt == '8 holes') {
              bg     = const Color(0xFF064E3B);
              border = const Color(0xFF059669);
            } else if (_answered && isCorrect) {
              bg     = const Color(0xFF064E3B);
              border = const Color(0xFF059669);
            }
            return GestureDetector(
              onTap: () => _tap(id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: Text(opt,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _findEightPuzzle() {
    return Column(
      children: [
        const Text(
          'The number EIGHT is hidden below.\nFind it and tap it!',
          style: TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _numberTile('3', 'three'),
            _numberTile('6', 'six'),
            _numberTile('8', 'eight_hidden'),
            _numberTile('B', 'letter_b'),
            _numberTile('9', 'nine'),
            _numberTile('0', 'zero'),
          ],
        ),
        const SizedBox(height: 16),
        if (_answered)
          const Text('🎉 That\'s 8!',
              style: TextStyle(
                  color: Color(0xFF34D399),
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _numberTile(String label, String id) {
    final isCorrect = id == 'eight_hidden';
    Color bg     = const Color(0xFF2D1B4E);
    Color border = Colors.white24;
    if (_answered && isCorrect) {
      bg     = const Color(0xFF064E3B);
      border = const Color(0xFF059669);
    }
    return GestureDetector(
      onTap: () => _tap(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }

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
