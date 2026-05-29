import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';

class DragDropPuzzle extends StatefulWidget {
  final Puzzle puzzle;
  final void Function(bool correct) onAnswer;

  const DragDropPuzzle({
    super.key,
    required this.puzzle,
    required this.onAnswer,
  });

  @override
  State<DragDropPuzzle> createState() => _DragDropPuzzleState();
}

class _DragDropPuzzleState extends State<DragDropPuzzle> {
  bool _dropped  = false;
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final dragLabel = widget.puzzle.dragItemLabel ?? 'Item';
    final dropLabel = widget.puzzle.dropZoneLabel  ?? 'Drop here';

    return Column(
      children: [
        // ── Drag item ──────────────────────────────
        if (!_dropped)
          Draggable<String>(
            data: dragLabel,
            feedback: _pill(dragLabel, const Color(0xFF7C3AED), dragging: true),
            childWhenDragging: _pill(dragLabel, Colors.white24),
            child: _pill(dragLabel, const Color(0xFF7C3AED)),
          )
        else
          _pill(dragLabel, Colors.white24),

        const SizedBox(height: 32),

        // ── Drop zone ──────────────────────────────
        DragTarget<String>(
          onWillAcceptWithDetails: (_) {
            setState(() => _hovering = true);
            return true;
          },
          onLeave: (_) => setState(() => _hovering = false),
          onAcceptWithDetails: (details) {
            setState(() {
              _hovering = false;
              _dropped  = true;
            });
            Future.delayed(const Duration(milliseconds: 700), () {
              widget.onAnswer(true);
            });
          },
          builder: (context, candidateData, rejectedData) {
            Color bg     = _hovering
                ? const Color(0xFF3B0764)
                : const Color(0xFF2D1B4E);
            Color border = _hovering
                ? const Color(0xFF7C3AED)
                : Colors.white24;

            if (_dropped) {
              bg     = const Color(0xFF064E3B);
              border = const Color(0xFF059669);
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: border,
                  width: 2,
                  style: _dropped ? BorderStyle.solid : BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Text(
                  _dropped ? '✅ $dragLabel dropped!' : dropLabel,
                  style: TextStyle(
                    color: _dropped
                        ? const Color(0xFF34D399)
                        : Colors.white38,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),
        const Text(
          'Drag the item into the box',
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
      ],
    );
  }

  Widget _pill(String label, Color color, {bool dragging = false}) =>
      Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: dragging ? 0.9 : 0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color, width: 1.5),
            boxShadow: dragging
                ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 16)]
                : null,
          ),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      );
}
