import 'package:flutter/material.dart';
import 'tts_fab.dart';
import 'package:provider/provider.dart';
import '../accessibility/tts_fab_alignment_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  late Alignment _currentAlignment;
  
  @override
  void initState() {
    super.initState();
    // Initialize with the widget's initialAlignment
    _currentAlignment = widget.initialAlignment;
    
    // Set initial alignment from provider or use widget's initialAlignment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alignmentProvider = Provider.of<TTSFabAlignmentProvider>(context, listen: false);
      
      // Always update the current alignment from the provider
      _currentAlignment = alignmentProvider.alignment;
      
      // If we have a specific initialAlignment from the widget, update the provider
      if (widget.initialAlignment != Alignment.bottomRight) {
        alignmentProvider.alignment = widget.initialAlignment;
        _currentAlignment = widget.initialAlignment;
      }
      
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Consumer<TTSFabAlignmentProvider>(
                builder: (context, alignmentProvider, child) {
                  // Always use the alignment from the provider
                  final alignment = alignmentProvider.alignment;
                  // Update our local tracking of the alignment
                  _currentAlignment = alignment;
                  
                  return AnimatedAlign(
                    alignment: alignment,
                    duration: Duration(milliseconds: 200),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        // Calculate new position based on drag delta
                        final dx = details.delta.dx / constraints.maxWidth;
                        final dy = details.delta.dy / constraints.maxHeight;
                        
                        // Calculate new alignment, clamping to ensure it stays within screen bounds
                        final newAlignment = alignment + Alignment(dx * 2, dy * 2);
                        final clampedX = newAlignment.x.clamp(-0.95, 0.95);
                        final clampedY = newAlignment.y.clamp(-0.95, 0.95);
                        
                        // Update the provider with the new alignment
                        alignmentProvider.alignment = Alignment(clampedX, clampedY);
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
          ),
        );
      },
    );
  }
}
