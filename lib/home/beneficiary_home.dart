import 'package:flutter/material.dart';

import '../widgets/dashboard_nav_bar.dart';
import '../widgets/dashboard_card.dart';
import '../chat/help_chat_screen.dart';
import '../resources/underprivileged_info.dart';
import '../resources/specially_abled_info.dart';
import '../resources/senior_citizen_info.dart';
import '../accessibility/font_size_provider.dart';
import '../utils/error_handler.dart';

import 'my_courses_screen.dart';
import '../settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_wrapper.dart';
import '../profile/profile_screen.dart';
import '../widgets/pickup_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/beneficiary_resources_screen.dart';
import '../widgets/draggable_tts_fab.dart';

class BeneficiaryHome extends StatefulWidget {
  final String category; // 'underprivileged', 'special', 'senior'
  final FontSizeNotifier fontSizeNotifier;
  const BeneficiaryHome({required this.category, required this.fontSizeNotifier, super.key});

  @override
  State<BeneficiaryHome> createState() => _BeneficiaryHomeState();
}

class _BeneficiaryHomeState extends State<BeneficiaryHome> {
  String? userName;
  bool loadingName = true;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    String? fetchedName;
    if (user != null) {
      try {
        // Add timeout to prevent hanging
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .timeout(Duration(seconds: 5)); // 5 second timeout
        final data = userDoc.data();
        fetchedName = data?['name'];
      } catch (e) {
        print('Error fetching user name: $e');
        // Don't show error to user, just use default greeting
      }
    }
    setState(() {
      userName = fetchedName;
      loadingName = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dashboard config based on category
    String greeting;
    List<_DashboardCardData> cards;
    final category = widget.category;
    final fontSizeNotifier = widget.fontSizeNotifier;

    // Personalized greeting logic
    if (loadingName) {
      greeting = 'Welcome back!';
    } else if (userName != null && userName!.trim().isNotEmpty) {
      greeting = 'Welcome back ${userName!.split(' ').first}!';
    } else {
      greeting = 'Welcome back!';
    }

    switch (category) {
      case 'underprivileged':
        cards = [
          _DashboardCardData(
            color: Color(0xFF2DBEF4),
            icon: Icons.bar_chart,
            title: 'Resources',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BeneficiaryResourcesScreen(category: category, fontSize: fontSizeNotifier.value))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF9800),
            icon: Icons.favorite,
            title: 'Health and Wellness',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UnderprivilegedInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF5252),
            icon: Icons.chat_bubble_outline,
            title: 'Chat Helpline',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
        ];
        break;
      case 'special':
        cards = [
          _DashboardCardData(
            color: Color(0xFF2DBEF4),
            icon: Icons.bar_chart,
            title: 'Resources',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BeneficiaryResourcesScreen(category: category, fontSize: fontSizeNotifier.value))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF9800),
            icon: Icons.build,
            title: 'Helpful Links',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpeciallyAbledInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF5252),
            icon: Icons.chat_bubble_outline,
            title: 'Chat Helpline',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
        ];
        break;
      case 'senior':
        cards = [
          _DashboardCardData(
            color: Color(0xFF2DBEF4),
            icon: Icons.bar_chart,
            title: 'Resources',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BeneficiaryResourcesScreen(category: category, fontSize: fontSizeNotifier.value))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF9800),
            icon: Icons.extension,
            title: "Memory-Boosting Games",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeniorCitizenInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF5252),
            icon: Icons.chat_bubble_outline,
            title: "Chat Helpline",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
        ];
        break;
      default:
        cards = [];
    }

    // Collect all main visible text for TTS
    final ttsText = [
      greeting,
      "What would you like to learn today?",
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
                Text("Yes I Can!", style: TextStyle(fontSize: fontSizeNotifier.value + 4, fontWeight: FontWeight.bold)),
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
            toolbarHeight: 80, // Increased height
            titleSpacing: 20, // Increased spacing
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    greeting,
                    style: TextStyle(
                      fontSize: fontSizeNotifier.value + 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "What would you like to learn today?",
                    style: TextStyle(
                      fontSize: fontSizeNotifier.value + 2,
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
                      fontSize: fontSizeNotifier.value + 2,
                      textColor: (cards[i].color.value == 0xFFFFF59E) ? Colors.black : null,
                    ),
                    if (i != cards.length - 1) const SizedBox(height: 16),
                  ],
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: DashboardNavBar(
            fontSize: fontSizeNotifier.value,
            currentIndex: 0,
            fontSizeNotifier: fontSizeNotifier,
            role: 'beneficiary',
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

  String _getHomeScreenText(String greeting, List<_DashboardCardData> cards) {
    String text = greeting + '. What would you like to learn today?';
    for (final card in cards) {
      text += '. ' + card.title;
    }
    return text;
  }
}

class _DashboardCardData {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  _DashboardCardData({required this.color, required this.icon, required this.title, required this.onTap});
}

