
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer_question_screen.dart';


class VolunteerDashboardScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer - View Questions'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('questions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading questions'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!.docs;

          if (questions.isEmpty) {
            return Center(child: Text('No questions submitted yet'));
          }

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final doc = questions[index];
              final data = doc.data() as Map<String, dynamic>;
              final questionText = data['question'] ?? '';
              final isAnswered = data.containsKey('answered') ? data['answered'] : false;
              final answer = data.containsKey('answer') ? data['answer'] : '';


              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(questionText),
                  subtitle: isAnswered
                      ? Text('✅ Answered: $answer')
                      : Text('❌ Not answered yet'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AnswerQuestionScreen(docId: doc.id, question: questionText, existingAnswer: answer),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/