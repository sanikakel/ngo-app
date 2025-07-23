import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String text;
  final String askedBy;
  final String? answeredBy;
  final String? answer;
  final DateTime timestamp;

  Question({
    required this.id,
    required this.text,
    required this.askedBy,
    required this.timestamp,
    this.answeredBy,
    this.answer,
  });

  factory Question.fromMap(String id, Map<String, dynamic> data) {
    return Question(
      id: id,
      text: data['text'],
      askedBy: data['askedBy'],
      answer: data['answer'],
      answeredBy: data['answeredBy'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
