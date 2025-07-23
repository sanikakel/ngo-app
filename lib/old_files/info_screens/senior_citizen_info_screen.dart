
/*
import 'package:flutter/material.dart';
import 'package:ngo_app/widgets/info_card.dart';


class SeniorCitizenScreen extends StatelessWidget {
  const SeniorCitizenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senior Citizens'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Welcome! 👴👵\nHere are some useful tools and tips to help you daily:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),

          // Memory Boosting Activities
          InfoCard(
            title: '🧠 Memory-Boosting Activities',
            description: 'Fun puzzles and games to keep your mind sharp!',
            url: 'https://www.youtube.com/watch?v=Rn7W5K5oKZw', // Replace later
          ),

          // Health & Wellness
          InfoCard(
            title: '💪 Health & Wellness Tips',
            description: 'Stay active and healthy with easy tips.',
            url: 'https://www.youtube.com/watch?v=3IHk-OKjM7g', // Replace later
          ),

          // Safety & Helplines
          InfoCard(
            title: '🚨 Safety & Emergency Helplines',
            description: 'Important numbers and safety resources for seniors.',
            url: 'https://www.helplineelderly.in/', // Replace later
          ),

          // Positive Thoughts
          InfoCard(
            title: '🌞 Daily Positive Thoughts',
            description: 'A dose of inspiration to brighten your day!',
            url: 'https://www.youtube.com/watch?v=QZbuj3RJcjI', // Replace later
          ),
        ],
      ),
    );
  }
}

class SeniorCitizenInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Aids for Seniors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              '🧠 Welcome! Here are some simple activities to keep your mind active:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildActivityCard('🧩 Puzzle Games', 'Try crossword puzzles, Sudoku, or jigsaw puzzles daily.'),
            buildActivityCard('📖 Read Every Day', 'Reading improves memory and concentration. Choose books, newspapers, or even audiobooks.'),
            buildActivityCard('🎵 Listen to Music', 'Play music from your youth or explore new genres to stimulate your brain.'),
            buildActivityCard('🗣️ Talk & Share', 'Call a friend or family member. Talking regularly strengthens memory.'),
            buildActivityCard('🧘 Breathing Exercises', 'Try deep breathing and meditation to relax and focus your mind.'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to Beneficiary Dashboard
              },
              child: Text('Back to Dashboard'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildActivityCard(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
*/