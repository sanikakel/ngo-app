/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerQuestionScreen extends StatefulWidget {
  final String docId;
  final String question;
  final String existingAnswer;

  AnswerQuestionScreen({
    required this.docId,
    required this.question,
    required this.existingAnswer,
  });

  @override
  _AnswerQuestionScreenState createState() => _AnswerQuestionScreenState();
}

class _AnswerQuestionScreenState extends State<AnswerQuestionScreen> {
  final _answerController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _answerController.text = widget.existingAnswer;
  }

  void _submitAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter an answer before submitting')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(widget.docId)
          .update({
        'answer': answer,
        'answered': true,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Answer submitted successfully!')));
      Navigator.pop(context); // go back to list
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving answer')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Answer Question')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.question),
            SizedBox(height: 24),
            TextField(
              controller: _answerController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Type your answer here',
                border: OutlineInputBorder(),
              ),
              enabled: !_isSaving,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _submitAnswer,
              child: _isSaving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit Answer'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/