import 'package:flutter/material.dart';
import 'tts_fab.dart';
import 'package:provider/provider.dart';
import '../accessibility/tts_fab_alignment_provider.dart';

class DraggableTTSFab extends StatefulWidget {
  final String text;
  final double fontSize;
  final double volume;
  final Alignment initialAlignment;
  const DraggableTTSFab({
    required this.text,
    required this.fontSize,
    required this.volume,
    this.initialAlignment = Alignment.bottomRight,
    super.key,
  });

  @override
  State<DraggableTTSFab> createState() => _DraggableTTSFabState();
}

class _DraggableTTSFabState extends State<DraggableTTSFab> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Consumer<TTSFabAlignmentProvider>(
              builder: (context, alignmentProvider, child) {
                return AnimatedAlign(
                  alignment: alignmentProvider.alignment,
                  duration: Duration(milliseconds: 200),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final dx = details.delta.dx / constraints.maxWidth;
                      final dy = details.delta.dy / constraints.maxHeight;
                      final newAlignment = alignmentProvider.alignment + Alignment(dx * 2, dy * 2);
                      alignmentProvider.alignment = newAlignment;
                    },
                    child: TTSFab(
                      text: widget.text,
                      fontSize: widget.fontSize,
                      volume: widget.volume,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
