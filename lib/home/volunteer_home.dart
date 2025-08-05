import 'package:flutter/material.dart';

import '../widgets/dashboard_nav_bar.dart';
import '../chat/help_chat_screen.dart';
import '../accessibility/font_size_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/volunteer_beneficiary_list_screen.dart';
import '../widgets/dashboard_card.dart';
import 'my_tasks_screen.dart';
import '../settings/settings_screen.dart';
import '../widgets/placeholder_screen.dart';
import '../resources/upload_resource_screen.dart';
import '../profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_wrapper.dart';
import '../widgets/draggable_tts_fab.dart';
import 'user_activity_tracker_screen.dart';


class VolunteerHome extends StatelessWidget {
  
  final FontSizeNotifier fontSizeNotifier;
  const VolunteerHome({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    // Volunteer dashboard config
    final double fSize = fontSizeNotifier.value;
    final List<_DashboardCardData> cards = [
      _DashboardCardData(
        color: Colors.blue.shade400,
        icon: Icons.cloud_upload,
        title: 'Upload Resources',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UploadResourceScreen(fontSize: fSize + 2),
          ),
        ),
      ),
      _DashboardCardData(
        color: Colors.amber.shade600,
        icon: Icons.analytics,
        title: 'User Activity Tracker',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserActivityTrackerScreen(fontSizeNotifier: fontSizeNotifier),
          ),
        ),
      ),
      _DashboardCardData(
        color: Colors.redAccent.shade200,
        icon: Icons.chat_bubble_outline,
        title: 'Chat Helpline',
        onTap: () async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final role = doc.data()?['role'];
    if (role == 'volunteer') {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => VolunteerBeneficiaryListScreen(fontSizeNotifier: fontSizeNotifier),
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier),
      ));
    }
  }
},
      ),
    ];

    // Collect all main visible text for TTS
    final ttsText = [
      'Volunteer Dashboard',
      'Welcome to your volunteer dashboard',
      ...cards.map((c) => c.title)
    ].join('. ');

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'assets/Yes I Can Mini Logo.png',
                  width: 36,
                  height: 36,
                ),
                const SizedBox(width: 10),
                Text("Yes I Can!", style: TextStyle(fontSize: fSize + 4, fontWeight: FontWeight.bold)),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.grey.shade800),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(fontSizeNotifier: fontSizeNotifier),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.redAccent),
                  tooltip: 'Sign Out',
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => AuthWrapper(fontSizeNotifier: fontSizeNotifier)),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Color(0xFFF6F8FB),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Welcome back volunteer!',
                    style: TextStyle(
                      fontSize: fSize + 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "What would you like to do today?",
                    style: TextStyle(
                      fontSize: fSize + 2,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 18),
                  for (int i = 0; i < cards.length; i++) ...[
                    DashboardCard(
                      color: cards[i].color,
                      icon: cards[i].icon,
                      title: cards[i].title,
                      onTap: cards[i].onTap,
                      fontSize: fSize + 2,
                    ),
                    if (i != cards.length - 1) const SizedBox(height: 16),
                  ],
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: DashboardNavBar(
            fontSize: fSize,
            currentIndex: 0,
            fontSizeNotifier: fontSizeNotifier,
            role: 'volunteer',
          ),
        ),
        DraggableTTSFab(
          text: ttsText,
          fontSize: fontSizeNotifier.value,
          volume: 1.0,
        ),
      ],
    );
  }
}

class _DashboardCardData {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  _DashboardCardData({required this.color, required this.icon, required this.title, required this.onTap});
}
