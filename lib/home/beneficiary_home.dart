import 'package:flutter/material.dart';
import '../chat/help_chat_screen.dart';
import '../resources/underprivileged_info.dart';
import '../resources/specially_abled_info.dart';
import '../resources/senior_citizen_info.dart';
import '../accessibility/font_size_provider.dart';
import '../settings/accessibility_settings.dart';

class BeneficiaryHome extends StatelessWidget {
  
  final String category; // 'underprivileged', 'special', 'senior'
  final FontSizeNotifier fontSizeNotifier;
  
  const BeneficiaryHome({required this.category, required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    Widget getResourceScreen() {
      switch (category) {
        case 'underprivileged':
          return UnderprivilegedInfoScreen(fontSizeNotifier: fontSizeNotifier,);
        case 'special':
          return SpeciallyAbledInfoScreen(fontSizeNotifier: fontSizeNotifier,);
        case 'senior':
          return SeniorCitizenInfoScreen(fontSizeNotifier: fontSizeNotifier,);
        default:
          return Center(child: Text('Unknown category', style: TextStyle(fontSize: fontSizeNotifier.value)));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Beneficiary Dashboard", style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (category == 'underprivileged') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UnderprivilegedInfoScreen(fontSizeNotifier: fontSizeNotifier),
                    ),
                  );
                } else if (category == 'speciallyAbled') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpeciallyAbledInfoScreen(fontSizeNotifier: fontSizeNotifier),
                    ),
                  );
                } else if (category == 'seniorCitizen') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeniorCitizenInfoScreen(fontSizeNotifier: fontSizeNotifier),
                    ),
                  );
                }
              },
              child: Text("View Resources", style: TextStyle(fontSize: fontSizeNotifier.value)),
            ),
          ),

          ElevatedButton.icon(
            icon: Icon(Icons.chat_bubble_outline),
            label: Text("Ask for Help", style: TextStyle(fontSize: fontSizeNotifier.value)),
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
          Expanded(child: getResourceScreen()),
        ],
      ),
    );
  }
}
