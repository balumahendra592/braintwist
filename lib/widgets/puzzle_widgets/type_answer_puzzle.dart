import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';

class TypeAnswerPuzzle extends StatefulWidget {
  final Puzzle puzzle;
  final void Function(bool correct) onAnswer;

  const TypeAnswerPuzzle({
    super.key,
    required this.puzzle,
    required this.onAnswer,
  });

  @override
  State<TypeAnswerPuzzle> createState() => _TypeAnswerPuzzleState();
}

class _TypeAnswerPuzzleState extends State<TypeAnswerPuzzle> {
  final _ctrl = TextEditingController();
  bool _answered = false;
  bool? _correct;

  void _submit() {
    if (_answered) return;
    final answer  = _ctrl.text.trim().toLowerCase();
    final correct = answer == (widget.puzzle.correctAnswer ?? '').toLowerCase();
    setState(() {
      _answered = true;
      _correct  = correct;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      widget.onAnswer(correct);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = const Color(0xFF7C3AED);
    if (_answered) {
      borderColor =
          _correct! ? const Color(0xFF059669) : const Color(0xFFDC2626);
    }

    return Column(
      children: [
        TextField(
          controller: _ctrl,
          enabled: !_answered,
          textCapitalization: TextCapitalization.none,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF2D1B4E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 2.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
          ),
          onSubmitted: (_) => _submit(),
        ),
        if (_answered) ...[
          const SizedBox(height: 12),
          Text(
            _correct! ? '✅ Correct!' : '❌ Wrong!',
            style: TextStyle(
              color: _correct!
                  ? const Color(0xFF34D399)
                  : const Color(0xFFFCA5A5),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _answered
                  ? Colors.white24
                  : const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _answered ? null : _submit,
            child: const Text('SUBMIT',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1)),
          ),
        ),
      ],
    );
  }
}
