import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import '../home/category_selection_screen.dart';
import '../accessibility/font_size_provider.dart';

class AuthWrapper extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const AuthWrapper({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return CategorySelectionScreen(fontSizeNotifier: fontSizeNotifier); // After login/signup, go to category selection
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