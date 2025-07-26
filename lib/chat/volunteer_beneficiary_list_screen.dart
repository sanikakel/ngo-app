import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../accessibility/font_size_provider.dart';
import 'help_chat_screen.dart';

class VolunteerBeneficiaryListScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const VolunteerBeneficiaryListScreen({Key? key, required this.fontSizeNotifier}) : super(key: key);

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    return name.trim().split(" ").map((e) => e[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Helpline', style: TextStyle(fontSize: fontSizeNotifier.value)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.blue[900]),
      ),
      backgroundColor: Color(0xFFF6F8FB),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', whereIn: ['underprivileged', 'special', 'senior']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text('No beneficiaries found.', style: TextStyle(fontSize: fontSizeNotifier.value)));
          }
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final beneficiaryId = docs[index].id;
              final name = data['name'] ?? 'Beneficiary';
              final category = data['role'] ?? '';
              final profilePic = data['profilePicUrl'] as String?;
              String categoryLabel;
              switch (category) {
                case 'underprivileged':
                  categoryLabel = 'Underprivileged Girl/Woman';
                  break;
                case 'special':
                  categoryLabel = 'Specially-Abled';
                  break;
                case 'senior':
                  categoryLabel = 'Senior Citizen';
                  break;
                default:
                  categoryLabel = '';
              }
              return ListTile(
                leading: profilePic != null && profilePic.isNotEmpty
                    ? CircleAvatar(backgroundImage: NetworkImage(profilePic), radius: 24)
                    : CircleAvatar(child: Text(_getInitials(name)), radius: 24, backgroundColor: Colors.blue[200]),
                title: Text(name, style: TextStyle(fontSize: fontSizeNotifier.value + 1, fontWeight: FontWeight.w600)),
                subtitle: Text(categoryLabel, style: TextStyle(fontSize: fontSizeNotifier.value * 0.9, color: Colors.grey[600])),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HelpChatScreen(
                        fontSizeNotifier: fontSizeNotifier,
                        beneficiaryId: beneficiaryId,
                        beneficiaryName: name,
                        beneficiaryCategory: categoryLabel,
                        beneficiaryProfilePic: profilePic,
                        isVolunteerView: true,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
