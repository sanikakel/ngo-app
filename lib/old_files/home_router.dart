
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'category_selection_screen.dart';
import 'volunteer_dashboard_screen.dart';



class HomeRouter extends StatelessWidget {
  final User user;

  const HomeRouter({super.key, required this.user});

  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.data()?['role'];
    } catch (e) {
      print('Error fetching role: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserRole(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Error loading user role')),
          );
        }

        final role = snapshot.data;

        if (role == 'Beneficiary') {
          return CategorySelectionScreen(
            onCategorySelected: (category) {
              // You can store or print the category here if needed
              print('Selected category: $category');
            },
          );
        } else if (role == 'Volunteer') {
          return VolunteerDashboardScreen();
        } else {
          return const Scaffold(
            body: Center(child: Text('Unknown user role')),
          );
        }
      },
    );
  }
}
*/