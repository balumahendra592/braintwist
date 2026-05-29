import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';

/// Generic tap-target puzzle.
/// The puzzle data must supply [correctTargetId].
/// This widget renders a set of tappable items; the puzzle_repository
/// defines what those items are via the [options] list and marks the
/// correct one with [correctTargetId] matching the option string.
class TapTargetPuzzle extends StatefulWidget {
  final Puzzle puzzle;
  final void Function(bool correct) onAnswer;

  const TapTargetPuzzle({
    super.key,
    required this.puzzle,
    required this.onAnswer,
  });

  @override
  State<TapTargetPuzzle> createState() => _TapTargetPuzzleState();
}

class _TapTargetPuzzleState extends State<TapTargetPuzzle> {
  String? _tapped;
  bool _answered = false;

  void _tap(String id) {
    if (_answered) return;
    setState(() {
      _tapped   = id;
      _answered = true;
    });
    final correct = id == widget.puzzle.correctTargetId;
    Future.delayed(const Duration(milliseconds: 600), () {
      widget.onAnswer(correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.puzzle.options ?? [];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: items.map((item) {
        final isCorrect = item == widget.puzzle.correctTargetId;
        Color bg     = const Color(0xFF2D1B4E);
        Color border = Colors.white24;

        if (_answered && _tapped == item) {
          bg     = isCorrect ? const Color(0xFF064E3B) : const Color(0xFF7F1D1D);
          border = isCorrect ? const Color(0xFF059669) : const Color(0xFFDC2626);
        } else if (_answered && isCorrect) {
          bg     = const Color(0xFF064E3B);
          border = const Color(0xFF059669);
        }

        return GestureDetector(
          onTap: () => _tap(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1.5),
            ),
            child: Text(
              item,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );
  }
}
