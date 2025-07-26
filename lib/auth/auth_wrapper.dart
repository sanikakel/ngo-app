import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';

import '../accessibility/font_size_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/volunteer_home.dart';
import '../home/beneficiary_home.dart';

class AuthWrapper extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const AuthWrapper({required this.fontSizeNotifier, super.key});

  Future<Widget> _getHomeScreen(User user) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final role = doc.data()?['role'] ?? '';
    if (role == 'volunteer') {
      return VolunteerHome(fontSizeNotifier: fontSizeNotifier);
    } else {
      // Default to beneficiary home, pass the role/category for customization
      return BeneficiaryHome(category: role, fontSizeNotifier: fontSizeNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          // Fetch user role from Firestore and route accordingly
          return FutureBuilder<Widget>(
            future: _getHomeScreen(snapshot.data!),
            builder: (context, homeSnapshot) {
              if (homeSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              } else if (homeSnapshot.hasData) {
                return homeSnapshot.data!;
              } else {
                return Scaffold(body: Center(child: Text('Error loading user data')));
              }
            },
          );
        } else {
          return SignInScreen(fontSizeNotifier: fontSizeNotifier); // Default to login screen
        }
      },
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screens/signin_screen.dart';
import 'home_router.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Waiting for connection to Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return HomeRouter(user: snapshot.data!);
        }

        // If user is NOT logged in
        return SignInScreen();
      },
    );
  }
}
*/