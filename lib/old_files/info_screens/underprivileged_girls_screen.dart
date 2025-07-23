
/*
import 'package:flutter/material.dart';
import 'package:ngo_app/widgets/info_card.dart';

class UnderprivilegedGirlsScreen extends StatelessWidget {
  const UnderprivilegedGirlsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Underprivileged Girls/Women'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Welcome! 👋\nHere are some helpful resources for you:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),

          // Financial Literacy
          InfoCard(
            title: '💰 Financial Literacy',
            description: 'Learn how to manage your money, save, and grow.',
            url: 'https://www.youtube.com/watch?v=O6VbJQhI2p8', // Example link
          ),

          // Childcare + Geriatric Care
          InfoCard(
            title: '👶👵 Childcare & Geriatric Care',
            description: 'Free video courses and tips on caregiving skills.',
            url: 'https://www.youtube.com/watch?v=2aG3bQv4uL8', // Example link
          ),

          // Emergency Helplines
          InfoCard(
            title: '📞 Emergency Support',
            description: 'List of helpline numbers for women’s safety, health, and rights.',
            url: 'https://www.indiaspend.com/indiaspend-interactive/women-helplines/', // Example link
          ),
        ],
      ),
    );
  }
}

class GirlsInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support for Girls & Women'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              '🌸 Empower Yourself: Helpful Resources',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildSection(
              '💰 Financial Literacy',
              [
                '• Learn how to open and use a bank account',
                '• Save a small amount from your earnings each month',
                '• Use mobile banking safely (like Google Pay, Paytm)',
              ],
            ),
            buildSection(
              '📞 Emergency Helplines',
              [
                '• Women\'s Helpline (India): 1091',
                '• Child Helpline: 1098',
                '• National Emergency: 112',
              ],
            ),
            buildSection(
              '🧭 Career Guidance',
              [
                '• Geriatric care courses can help you get hospital jobs',
                '• Learning child-care opens up opportunities in preschools',
                '• Practice cooking and hygiene for home-based work',
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Dashboard'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(item, style: TextStyle(fontSize: 16)),
            )),
        SizedBox(height: 20),
      ],
    );
  }
}
*/