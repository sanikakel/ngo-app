import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSFab extends StatefulWidget {
  final String text;
  final double fontSize;
  final double volume;
  const TTSFab({required this.text, required this.fontSize, required this.volume, super.key});

  @override
  State<TTSFab> createState() => _TTSFabState();
}

class _TTSFabState extends State<TTSFab> {
  late FlutterTts flutterTts;
  bool isPlaying = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setVolume(widget.volume);
    flutterTts.setCompletionHandler(() {
      setState(() => isPlaying = false);
    });
    flutterTts.setCancelHandler(() {
      setState(() => isPlaying = false);
    });
  }

  @override
  void didUpdateWidget(covariant TTSFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    flutterTts.setVolume(widget.volume);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  String _extractTextFrom(BuildContext context) {
    // Always use the provided text if it's not empty
    if (widget.text.isNotEmpty) {
      return widget.text;
    }
    
    // Only fall back to UI extraction if no text was provided
    StringBuffer buffer = StringBuffer();
    
    void visitor(Element element) {
      // Extract text from Text widgets
      if (element.widget is Text) {
        final Text textWidget = element.widget as Text;
        final String textData = textWidget.data ?? '';
        if (textData.isNotEmpty && textData != 'Screen reader text-to-speech') {
          buffer.write(textData);
          buffer.write('. ');
        }
      }
      
      // Extract text from TextField widgets
      else if (element.widget is TextField) {
        final TextField textField = element.widget as TextField;
        if (textField.decoration?.labelText != null) {
          buffer.write(textField.decoration!.labelText);
          buffer.write('. ');
        }
      }
      
      // Continue traversing the widget tree
      element.visitChildren(visitor);
    }
    
    // Start from the current context and traverse down
    context.visitChildElements(visitor);
    
    return buffer.toString();
  }

  Future<void> _speak() async {
    setState(() => isPlaying = true);
    await flutterTts.stop();
    
    // Use the provided text if available, otherwise extract from screen
    String screenText = widget.text.isNotEmpty ? widget.text : _extractTextFrom(context);
    
    // If still no text was found, use a default message
    if (screenText.isEmpty) {
      screenText = 'No readable text found on this screen.';
    }
    
    // Set speech rate to a comfortable pace
    await flutterTts.setSpeechRate(0.5);
    
    // Speak the text
    await flutterTts.speak(screenText);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedOpacity(
            opacity: _isHovered ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: _isHovered
                ? Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'screen-reader',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.fontSize * 0.9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          FloatingActionButton(
            tooltip: isPlaying ? 'Stop Reading' : 'Read Screen',
            onPressed: isPlaying
                ? () async {
                    await flutterTts.stop();
                    setState(() => isPlaying = false);
                  }
                : _speak,
            child: Icon(isPlaying ? Icons.stop : Icons.volume_up, size: widget.fontSize * 1.2),
          ),
        ],
      ),
    );
  }
}
