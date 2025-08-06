import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/draggable_tts_fab.dart';
import '../accessibility/font_size_provider.dart';
import '../profile/profile_screen.dart';
import 'notifications_screen.dart';
import 'accessibility_settings.dart';
import '../profile/user_role_provider.dart';
import '../home/volunteer_home.dart';
import '../home/beneficiary_home.dart';

class SettingsScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const SettingsScreen({required this.fontSizeNotifier, super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double ttsVolume = 1.0;
  late FlutterTts flutterTts;
  String screenText = '';

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    WidgetsBinding.instance.addPostFrameCallback((_) => _collectScreenText());
  }

  void _collectScreenText() {
    setState(() {
      screenText =
          'Settings. Profile. View and edit your profile. Notifications. Notification preferences. Accessibility. Accessibility options.';
    });
  }

  Future<void> _speak() async {
    await flutterTts.stop();
    await flutterTts.speak(screenText);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.fontSizeNotifier.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Settings', style: TextStyle(fontSize: fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0057B8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 80, // Increased height
        titleSpacing: 20, // Increased spacing
      ),
      floatingActionButton: DraggableTTSFab(
        text: 'Settings screen. Profile, Notifications, Accessibility.',
        fontSize: fontSize,
        volume: 1.0,
      ),
      body: Container(
        color: Color(0xFFF6F8FB),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8),
              _SettingsCard(
                icon: Icons.person,
                iconColor: Color(0xFF0057B8),
                title: 'Profile',
                subtitle: 'View and edit your profile',
                fontSize: fontSize,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ProfileScreen(fontSizeNotifier: widget.fontSizeNotifier),
                  ));
                },
              ),
              SizedBox(height: 18),
              _SettingsCard(
                icon: Icons.notifications_active,
                iconColor: Color(0xFF0057B8),
                title: 'Notifications',
                subtitle: 'Notification preferences',
                fontSize: fontSize,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => NotificationsScreen(),
                  ));
                },
              ),
              SizedBox(height: 18),
              _SettingsCard(
                icon: Icons.accessibility,
                iconColor: Color(0xFF0057B8),
                title: 'Accessibility',
                subtitle: 'Accessibility options',
                fontSize: fontSize,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => AccessibilitySettings(fontSizeNotifier: widget.fontSizeNotifier),
                  ));
                },
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final double fontSize;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.fontSize,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold, color: Color(0xFF222B45))),
                    SizedBox(height: 5),
                    Text(subtitle, style: TextStyle(fontSize: fontSize - 1, color: Colors.grey[700])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
