import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../accessibility/font_size_provider.dart';
import '../widgets/chat_bubble.dart';
import '../profile/profile_screen.dart';

class HelpChatScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  final String? beneficiaryId;
  final String? beneficiaryName;
  final String? beneficiaryCategory;
  final String? beneficiaryProfilePic;
  final bool isVolunteerView;

  const HelpChatScreen({
    required this.fontSizeNotifier,
    this.beneficiaryId,
    this.beneficiaryName,
    this.beneficiaryCategory,
    this.beneficiaryProfilePic,
    this.isVolunteerView = false,
    Key? key,
  }) : super(key: key);
  
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
    if (_questionController.text.trim().isEmpty) {
      print('DEBUG: Message is empty, not sending');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('questions').add({
        'text': _questionController.text.trim(),
        'senderId': user.uid,
        'senderRole': userRole ?? '',
        'chatId': widget.beneficiaryId ?? user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _questionController.clear();
      print('DEBUG: Message sent!');
    } catch (e) {
      print('ERROR sending message: $e');
      // Optionally, show a SnackBar or dialog
    }
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

    // Volunteer view: show chat for selected beneficiary
    if (widget.isVolunteerView) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              widget.beneficiaryProfilePic != null && widget.beneficiaryProfilePic!.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(widget.beneficiaryProfilePic!), radius: 18)
                  : CircleAvatar(child: Text(_getInitials(widget.beneficiaryName ?? '')), radius: 18, backgroundColor: Colors.blue[200]),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.beneficiaryName ?? '', style: TextStyle(fontSize: widget.fontSizeNotifier.value, color: Colors.blue[900], fontWeight: FontWeight.bold)),
                  if ((widget.beneficiaryCategory ?? '').isNotEmpty)
                    Text(widget.beneficiaryCategory!, style: TextStyle(fontSize: widget.fontSizeNotifier.value * 0.85, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          leading: BackButton(color: Colors.blue[900]),

        ),
        backgroundColor: Color(0xFFF6F8FB),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: _buildChatBody(context, beneficiaryId: widget.beneficiaryId, isVolunteer: true),
        ),
      );
    }

    // Beneficiary view: show their own chat
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Help Chat", style: TextStyle(fontSize: widget.fontSizeNotifier.value, color: Colors.blue[900], fontWeight: FontWeight.bold)),
        leading: BackButton(color: Colors.blue[900]),

      ),
      backgroundColor: Color(0xFFF6F8FB),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _buildChatBody(context, beneficiaryId: user.uid, isVolunteer: false),
      ),
    );
  }

  Widget _buildChatBody(BuildContext context, {required String? beneficiaryId, required bool isVolunteer}) {
    debugPrint('Volunteer Chat Debug: beneficiaryId = \\${beneficiaryId}');
    if (isVolunteer && (beneficiaryId == null || beneficiaryId.isEmpty)) {
      return Center(child: Text("No beneficiary selected. (Debug: beneficiaryId is null or empty)"));
    }
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('questions')
                    .where('chatId', isEqualTo: widget.beneficiaryId ?? user.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  debugPrint('Volunteer Chat Debug: snapshot = \\${snapshot.toString()}');
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading chat: \\${snapshot.error}', style: TextStyle(color: Colors.red)));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No chat data found.'));
                  }
                  final docs = snapshot.data!.docs
                      .where((doc) => doc['timestamp'] != null)
                      .toList();
                  debugPrint('Volunteer Chat Debug: docs.length = \\${docs.length}');
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No messages yet. Start the conversation!",
                        style: TextStyle(fontSize: widget.fontSizeNotifier.value * 0.95, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView(
                    reverse: true,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    children: docs.map<Widget>((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final isSender = data['senderId'] == user.uid;
                      final senderRole = data['senderRole'] ?? '';
                      final msgTime = (data['timestamp'] as Timestamp?)?.toDate();
                      List<Widget> bubbles = [];

                      bubbles.add(ChatBubble(
                        text: data['text'] ?? "",
                        isSender: isSender,
                        senderName: isSender ? "You" : (senderRole == 'volunteer' ? "Volunteer" : "Beneficiary"),
                        timestamp: msgTime,
                        fontSize: widget.fontSizeNotifier.value,
                        senderColor: isSender ? Colors.blue.shade100 : Colors.grey.shade200,
                        receiverColor: Colors.grey.shade200,
                      ));

                      if (data['answer'] != null) {
                        final answerTime = (data['answeredAt'] as Timestamp?)?.toDate();
                        bubbles.add(ChatBubble(
                          text: data['answer'] ?? "",
                          isSender: data['answeredBy'] == user.uid,
                          timestamp: answerTime,
                          fontSize: widget.fontSizeNotifier.value,
                          senderColor: Colors.blue.shade300,
                          receiverColor: Colors.grey.shade200,
                        ));
                      }

                      return Column(children: bubbles);
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          // Input bar always at the bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    style: TextStyle(fontSize: widget.fontSizeNotifier.value),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: widget.fontSizeNotifier.value * 0.95, color: Colors.grey[500]),
                      contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
  print('DEBUG: Post button pressed');
  _submitQuestion();
},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.blue[700],
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    elevation: 0,
                  ),
                  child: Text("Post", style: TextStyle(fontSize: widget.fontSizeNotifier.value, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for initials
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "";
    return name.trim().split(" ").map((e) => e[0]).take(2).join().toUpperCase();
  }
}