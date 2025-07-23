import 'package:flutter/material.dart';
import '../accessibility/font_size_provider.dart';

class AccessibilitySettings extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  const AccessibilitySettings({super.key, required this.fontSizeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accessibility Settings", style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Font Size",
              style: TextStyle(
                fontSize: fontSizeNotifier.value + 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: fontSizeNotifier.decrease,
                ),
                Text(
                  "${fontSizeNotifier.value.toStringAsFixed(0)} pt",
                  style: TextStyle(fontSize: fontSizeNotifier.value),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: fontSizeNotifier.increase,
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "This setting will update the font size across the app.",
              style: TextStyle(fontSize: fontSizeNotifier.value - 2),
            ),
          ],
        ),
      ),
    );
  }
}
