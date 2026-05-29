import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';

class MultiChoicePuzzle extends StatefulWidget {
  final Puzzle puzzle;
  final void Function(bool correct) onAnswer;

  const MultiChoicePuzzle({
    super.key,
    required this.puzzle,
    required this.onAnswer,
  });

  @override
  State<MultiChoicePuzzle> createState() => _MultiChoicePuzzleState();
}

class _MultiChoicePuzzleState extends State<MultiChoicePuzzle> {
  int? _selected;
  bool _answered = false;

  void _tap(int index) {
    if (_answered) return;
    setState(() {
      _selected = index;
      _answered = true;
    });
    final correct = index == widget.puzzle.correctOptionIndex;
    Future.delayed(const Duration(milliseconds: 600), () {
      widget.onAnswer(correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.puzzle.options ?? [];
    return Column(
      children: List.generate(options.length, (i) {
        Color bg     = const Color(0xFF2D1B4E);
        Color border = Colors.white24;
        Color text   = Colors.white;

        if (_answered && _selected == i) {
          final correct = i == widget.puzzle.correctOptionIndex;
          bg     = correct ? const Color(0xFF064E3B) : const Color(0xFF7F1D1D);
          border = correct ? const Color(0xFF059669) : const Color(0xFFDC2626);
          text   = correct ? const Color(0xFF34D399) : const Color(0xFFFCA5A5);
        } else if (_answered && i == widget.puzzle.correctOptionIndex) {
          bg     = const Color(0xFF064E3B);
          border = const Color(0xFF059669);
          text   = const Color(0xFF34D399);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            onTap: () => _tap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border, width: 1.5),
              ),
              child: Text(
                options[i],
                style: TextStyle(
                    color: text, fontSize: 15, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }),
    );
  }
}
