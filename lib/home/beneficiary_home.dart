import 'package:flutter/material.dart';
import '../chat/help_chat_screen.dart';
import '../resources/underprivileged_info.dart';
import '../resources/specially_abled_info.dart';
import '../resources/senior_citizen_info.dart';
import '../accessibility/font_size_provider.dart';
import '../widgets/dashboard_card.dart';
import 'my_courses_screen.dart';
import '../settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_wrapper.dart';
import '../profile/profile_screen.dart';
import '../widgets/pickup_card.dart';

class BeneficiaryHome extends StatelessWidget {
  
  final String category; // 'underprivileged', 'special', 'senior'
  final FontSizeNotifier fontSizeNotifier;
  
  const BeneficiaryHome({required this.category, required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    // Dashboard config based on category
    String greeting;
    List<_DashboardCardData> cards;

    switch (category) {
      case 'underprivileged':
        greeting = "Welcome Back!";
        cards = [
          _DashboardCardData(
            color: Color(0xFF2DBEF4),
            icon: Icons.bar_chart,
            title: "Skill Development Modules",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UnderprivilegedInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF9800),
            icon: Icons.favorite,
            title: "Health and Safety Information Hub",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UnderprivilegedInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF5252),
            icon: Icons.chat_bubble_outline,
            title: "Chat Helpline",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
        ];
        break;
      case 'special':
        greeting = "Welcome!";
        cards = [
          _DashboardCardData(
            color: Color(0xFF2DBEF4),
            icon: Icons.bar_chart,
            title: "Skill Development Modules",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpeciallyAbledInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF9800),
            icon: Icons.build,
            title: "Vocational Training Modules",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpeciallyAbledInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF5252),
            icon: Icons.chat_bubble_outline,
            title: "Chat Helpline",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
        ];
        break;
      case 'senior':
        greeting = "Welcome Back!";
        cards = [
          _DashboardCardData(
            color: Color(0xFF2DBEF4),
            icon: Icons.extension,
            title: "Memory-Boosting Games",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeniorCitizenInfoScreen(fontSizeNotifier: fontSizeNotifier))),
          ),
          _DashboardCardData(
            color: Color(0xFFFF9800),
            icon: Icons.photo,
            title: "Talent Wall",
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
        greeting = "Welcome!";
        cards = [];
    }

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
      ),
      body: Padding(
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
            // Pick up where you left off section (improved)
            PickupCard(
              fontSize: fontSizeNotifier.value,
              onResume: () {},
            ),
            Column(
              children: [
                for (int i = 0; i < cards.length; i++) ...[
                  DashboardCard(
                    color: cards[i].color,
                    icon: cards[i].icon,
                    title: cards[i].title,
                    onTap: cards[i].onTap,
                    fontSize: fontSizeNotifier.value + 2,
                    textColor: (cards[i].color.value == 0xFFFFF59E) ? Colors.black : null,
                  ),
                  if (i != cards.length - 1) const SizedBox(height: 10),
                ],
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _DashboardNavBar(
        fontSize: fontSizeNotifier.value,
        fontSizeNotifier: fontSizeNotifier,
        category: category,
        currentIndex: 0,
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

class _DashboardNavBar extends StatelessWidget {
  final double fontSize;
  final int currentIndex;
  final FontSizeNotifier fontSizeNotifier;
  final String category;
  const _DashboardNavBar({required this.fontSize, this.currentIndex = 0, required this.fontSizeNotifier, required this.category});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: fontSize,
      unselectedFontSize: fontSize,
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFF2DBEF4),
      unselectedItemColor: Color(0xFF444B54),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Resources'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat Helpline'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (i) {
        if (i == currentIndex) return;
        switch (i) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BeneficiaryHome(category: category, fontSizeNotifier: fontSizeNotifier),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyCoursesScreen(fontSizeNotifier: fontSizeNotifier),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier),
              ),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(fontSizeNotifier: fontSizeNotifier),
              ),
            );
            break;
        }
      },
    );
  }
}

