// BACKUP OF beneficiary_home.dart BEFORE PERSONALIZATION
// This file was created automatically before refactoring for personalized greetings.

// DO NOT EDIT. Safe to delete after confirming new greeting works.

// --- START OF ORIGINAL FILE ---

import 'package:flutter/material.dart';

import '../widgets/dashboard_nav_bar.dart';
import '../widgets/dashboard_card.dart';
import '../chat/help_chat_screen.dart';
import '../resources/underprivileged_info.dart';
import '../resources/specially_abled_info.dart';
import '../resources/senior_citizen_info.dart';
import '../accessibility/font_size_provider.dart';

import 'my_courses_screen.dart';
import '../settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_wrapper.dart';
import '../profile/profile_screen.dart';
import '../widgets/pickup_card.dart';
import '../resources/beneficiary_resources_screen.dart';

class BeneficiaryHome extends StatelessWidget {
  final String category; // 'underprivileged', 'special', 'senior'
  final FontSizeNotifier fontSizeNotifier;
  const BeneficiaryHome({required this.category, required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    String greeting;
    List<_DashboardCardData> cards;
    switch (category) {
      case 'underprivileged':
        greeting = 'Welcome back!';
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
        greeting = 'Welcome!';
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
        greeting = 'Welcome!';
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
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeniorCitizenInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF5252),
            icon: Icons.chat_bubble_outline,
            title: 'Chat Helpline',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
        ];
        break;
      default:
        greeting = 'Welcome!';
        cards = [];
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
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
                'What would you like to learn today?',
                style: TextStyle(
                  fontSize: fontSizeNotifier.value + 2,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 18),
              ...cards.map((card) => DashboardCard(
                color: card.color,
                icon: card.icon,
                title: card.title,
                onTap: card.onTap,
                fontSize: fontSizeNotifier.value + 2,
              )),
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
        category: category,
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
// --- END OF ORIGINAL FILE ---
