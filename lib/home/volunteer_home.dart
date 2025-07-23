import 'package:flutter/material.dart';
import '../chat/help_chat_screen.dart';
import '../accessibility/font_size_provider.dart';
import '../settings/accessibility_settings.dart';


class VolunteerHome extends StatelessWidget {
  
  final FontSizeNotifier fontSizeNotifier;
  const VolunteerHome({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volunteer Dashboard", style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.chat),
              label: Text("Help Chat", style: TextStyle(fontSize: fontSizeNotifier.value)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccessibilitySettings(fontSizeNotifier: fontSizeNotifier),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text("More volunteer tools coming soon!", style: TextStyle(fontSize: fontSizeNotifier.value)),
          ],
        ),
      ),
    );
  }
}
