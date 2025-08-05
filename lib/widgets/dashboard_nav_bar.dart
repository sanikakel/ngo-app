import 'package:flutter/material.dart';
import '../home/beneficiary_home.dart';
import '../home/volunteer_home.dart';
import '../home/my_courses_screen.dart';
import '../resources/beneficiary_resources_screen.dart';
import '../home/my_tasks_screen.dart';
import '../settings/settings_screen.dart';
import '../chat/help_chat_screen.dart';
import '../chat/volunteer_beneficiary_list_screen.dart';
import '../accessibility/font_size_provider.dart';

/// role: 'beneficiary' or 'volunteer'
/// category: only needed for beneficiary home
class DashboardNavBar extends StatelessWidget {
  final double fontSize;
  final int currentIndex;
  final FontSizeNotifier fontSizeNotifier;
  final String? role;
  final String? category;
  const DashboardNavBar({
    required this.fontSize,
    required this.currentIndex,
    required this.fontSizeNotifier,
    this.role,
    this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isBeneficiary = role == 'beneficiary';
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: fontSize,
      unselectedFontSize: fontSize,
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFF2DBEF4),
      unselectedItemColor: Color(0xFF444B54),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(isBeneficiary ? Icons.menu_book : Icons.play_circle_filled),
          label: isBeneficiary ? 'Resources' : 'My Tasks',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Help Chat'),
        const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (i) {
        if (i == currentIndex) return;
        switch (i) {
          case 0:
            if (isBeneficiary) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BeneficiaryHome(category: category ?? 'underprivileged', fontSizeNotifier: fontSizeNotifier),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VolunteerHome(fontSizeNotifier: fontSizeNotifier),
                ),
              );
            }
            break;
          case 1:
            if (isBeneficiary) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BeneficiaryResourcesScreen(
                    category: category ?? 'underprivileged',
                    fontSize: fontSizeNotifier.value,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MyTasksScreen(fontSizeNotifier: fontSizeNotifier),
                ),
              );
            }
            break;
          case 2:
            if (isBeneficiary) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => HelpChatScreen(fontSizeNotifier: fontSizeNotifier),
                ),
                (route) => route.isFirst,
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VolunteerBeneficiaryListScreen(fontSizeNotifier: fontSizeNotifier),
                ),
              );
            }
            break;
          case 3:
            Navigator.pushReplacement(
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
