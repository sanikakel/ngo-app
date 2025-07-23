import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../accessibility/font_size_provider.dart';

class HelpChatScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;

  const HelpChatScreen({required this.fontSizeNotifier, super.key});
  
  @override
  _HelpChatScreenState createState() => _HelpChatScreenState();
}

class _HelpChatScreenState extends State<HelpChatScreen> {
  final _questionController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    setState(() {
      userRole = doc.data()?['role'];
    });
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('questions').add({
      'text': _questionController.text.trim(),
      'askedBy': user.uid,
      'answer': null,
      'answeredBy': null,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _questionController.clear();
  }

  Future<void> _submitAnswer(String questionId) async {
    String? answer = await showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text("Answer Question", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter your answer"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text("Cancel", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: Text("Submit", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
            ),
          ],
        );
      },
    );

    if (answer != null && answer.isNotEmpty) {
      await FirebaseFirestore.instance.collection('questions').doc(questionId).update({
        'answer': answer,
        'answeredBy': user.uid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userRole == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Help Chat", style: TextStyle(fontSize: widget.fontSizeNotifier.value)), 
        leading: BackButton(),
      ),
      body: Column(
        children: [
          if (userRole != 'volunteer')
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionController,
                      style: TextStyle(fontSize: widget.fontSizeNotifier.value),
                      decoration: InputDecoration(
                        labelText: "Ask a question",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: widget.fontSizeNotifier.value),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitQuestion,
                    child: Text("Post", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                  )
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('questions')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                return ListView(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final questionId = doc.id;
                    final isAnswered = data['answer'] != null;
                    final isMyQuestion = data['askedBy'] == user.uid;

                    // Hide other people's questions if not volunteer
                    if (userRole != 'volunteer' && !isMyQuestion) {
                      return SizedBox();
                    }

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(data['text'] ?? "", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                        subtitle: isAnswered
                            ? Text("Answered: ${data['answer']}", style: TextStyle(fontSize: widget.fontSizeNotifier.value))
                            : userRole == 'volunteer'
                                ? Text("Unanswered", style: TextStyle(fontSize: widget.fontSizeNotifier.value))
                                : Text("Waiting for response...", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                        trailing: userRole == 'volunteer' && !isAnswered
                            ? IconButton(
                                icon: Icon(Icons.reply),
                                onPressed: () => _submitAnswer(questionId),
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
