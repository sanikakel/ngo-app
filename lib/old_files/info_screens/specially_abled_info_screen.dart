
/*
import 'package:flutter/material.dart';
import 'package:ngo_app/widgets/info_card.dart';


class SpeciallyAbledScreen extends StatelessWidget {
  const SpeciallyAbledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Specially-Abled Support'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Welcome! 🧠\nHere are some helpful resources just for you:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),

          // Soft Skills
          InfoCard(
            title: '🗣️ Soft Skills Training',
            description: 'Improve your communication, confidence, and teamwork.',
            url: 'https://www.youtube.com/watch?v=oqddFzH5-lM', // Replace later
          ),

          // Cooking Skills (Blind-friendly)
          InfoCard(
            title: '🍳 Blind-Friendly Cooking',
            description: 'Learn safe and easy cooking techniques.',
            url: 'https://www.youtube.com/watch?v=ZJKPL8oLrzI', // Replace later
          ),

          // AI Basics
          InfoCard(
            title: '🤖 Learn About AI',
            description: 'What is AI? How does it work? Start here!',
            url: 'https://www.youtube.com/watch?v=2ePf9rue1Ao', // Replace later
          ),

          // Reading & Writing
          InfoCard(
            title: '📖 Reading & Writing Basics',
            description: 'Simple resources to help improve literacy.',
            url: 'https://www.youtube.com/watch?v=JU7f6TeX7VI', // Replace later
          ),
        ],
      ),
    );
  }
}

class SpeciallyAbledInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support for Specially-Abled Students'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              '🧩 Empowerment Through Learning',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildSection(
              '👂 Soft Skills to Practice',
              [
                '• Practice introducing yourself confidently.',
                '• Role-play polite conversations in daily life.',
                '• Practice asking questions, saying thank you, etc.',
              ],
            ),
            buildSection(
              '💻 Digital Skills for the Future',
              [
                '• Learn how to use a keyboard and mouse.',
                '• Watch videos on basics of computers and mobile phones.',
                '• Understand what Artificial Intelligence (AI) is with simple examples.',
              ],
            ),
            buildSection(
              '👨‍👩‍👧 For Parents',
              [
                '• Encourage regular routines and small daily tasks.',
                '• Practice reading signs, labels, and pictures with your child.',
                '• Use simple apps to teach numbers, letters, or colors.',
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