import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../accessibility/font_size_provider.dart';

import 'volunteer_home.dart';
import 'beneficiary_home.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  static const List<Map<String, String>> categories = [
    {'label': 'Underprivileged Girl/Woman', 'value': 'underprivileged'},
    {'label': 'Specially-Abled', 'value': 'special'},
    {'label': 'Senior Citizen', 'value': 'senior'},
    {'label': 'Volunteer', 'value': 'volunteer'},
  ];

  void _selectCategory(BuildContext context, String category) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'role': category,
        'email': FirebaseAuth.instance.currentUser?.email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Redirect to appropriate screen
      if (category == 'volunteer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const VolunteerHome(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BeneficiaryHome(
              category: category,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeNotifier>(
      builder: (context, fontSizeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Select Your Category", style: TextStyle(fontSize: fontSizeNotifier.fontSize)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: categories.map((cat) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(cat['label']!, style: TextStyle(fontSize: fontSizeNotifier.fontSize)),
                    onTap: () => _selectCategory(context, cat['value']!),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
