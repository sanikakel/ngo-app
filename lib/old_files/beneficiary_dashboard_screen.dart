
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ngo_app/info_screens/underprivileged_girls_screen.dart';
import 'view_questions_screen.dart';
import 'info_screens/specially_abled_info_screen.dart';
import 'info_screens/senior_citizen_info_screen.dart';

class BeneficiaryDashboardScreen extends StatefulWidget {
  final String category;

  BeneficiaryDashboardScreen({required this.category});

  @override
  _BeneficiaryDashboardScreenState createState() => _BeneficiaryDashboardScreenState();
}

class _BeneficiaryDashboardScreenState extends State<BeneficiaryDashboardScreen> {
  final TextEditingController _questionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSending = false;

  void _sendQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a question')));
      return;
    }
    setState(() => _isSending = true);

    try {
      await _firestore.collection('questions').add({
        'question': question,
        'timestamp': FieldValue.serverTimestamp(),
        'answered': false,
      });
      _questionController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Question sent successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error sending question')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficiary Dashboard - ${widget.category}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Type your question here',
                border: OutlineInputBorder(),
              ),
              enabled: !_isSending,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSending ? null : _sendQuestion,
              child: _isSending
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Send Question'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.question_answer),
              label: Text('View My Questions'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewQuestionsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white, // 👈 sets text/icon color
              ),
            ),
            if (widget.category == 'Senior Citizen') ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SeniorCitizenInfoScreen()),
                  );
                },
                child: Text('🧠 View Memory-Boosting Tips'),
              ),
            ],
            if (widget.category == 'Underprivileged Girl') ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderprivilegedGirlsScreen()),
                  );
                },
                child: Text('🌸 View Resources for Girls'),
              ),
            ],
            if (widget.category == 'Specially-Abled') ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeciallyAbledInfoScreen()),
                  );
                },
                child: Text('🧩 View Resources for Specially-Abled'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
*/