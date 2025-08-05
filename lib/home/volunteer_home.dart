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
        icon: Icons.info_outline,
        title: 'Volunteer Resources',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceholderScreen(
              title: 'Volunteer Resources',
              message: 'Feature coming soon',
              icon: Icons.info_outline,
            ),
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

    return Scaffold(
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
                    builder: (_) => ProfileScreen(
                      fontSizeNotifier: fontSizeNotifier,
                    ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Welcome, Volunteer!",
              style: TextStyle(
                fontSize: fSize + 8,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Ready to make a difference today?",
              style: TextStyle(
                fontSize: fSize + 2,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 18),
            ...cards.map((card) => DashboardCard(
              color: card.color,
              icon: card.icon,
              title: card.title,
              onTap: card.onTap,
              fontSize: fSize + 2,
            )),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: DashboardNavBar(
        fontSize: fontSizeNotifier.value,
        currentIndex: 0,
        fontSizeNotifier: fontSizeNotifier,
        role: 'volunteer',
      ),
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
