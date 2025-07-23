
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ViewQuestionsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Questions')),
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

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('You haven\'t asked any questions yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final question = data['question'] ?? '';
              final answer = data.containsKey('answer') ? data['answer'] : null;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(question),
                  subtitle: answer != null
                      ? Text('✅ Answer: $answer')
                      : Text('❌ Not answered yet'),
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