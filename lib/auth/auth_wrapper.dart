import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';

import '../accessibility/font_size_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/volunteer_home.dart';
import '../home/beneficiary_home.dart';
import '../accessibility/screen_reader_volume_notifier.dart';
import '../resources/beneficiary_resources_screen.dart' show BeneficiaryResourcesScreen;

import 'package:ngo_app/widgets/draggable_tts_fab.dart';
import 'package:provider/provider.dart';



class AuthWrapper extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const AuthWrapper({required this.fontSizeNotifier, super.key});
  
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  // Track current route for context-aware TTS
  String _currentRouteName = '';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // This helps ensure the FAB is properly positioned when app resumes
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  Future<Widget> _getHomeScreen(User user) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final role = userDoc.data()?['role'] ?? 'beneficiary';
      
      // Track user activity
      await _trackUserActivity(user.uid);
      
      if (role == 'volunteer') {
        return VolunteerHome(fontSizeNotifier: widget.fontSizeNotifier);
      } else {
        // Default to beneficiary home, pass the role/category for customization
        return BeneficiaryHome(category: role, fontSizeNotifier: widget.fontSizeNotifier);
      }
    } catch (e) {
      print('Error getting home screen: $e');
      return BeneficiaryHome(category: 'underprivileged', fontSizeNotifier: widget.fontSizeNotifier);
    }
  }

  Future<void> _trackUserActivity(String userId) async {
    try {
      final now = Timestamp.now();
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'lastLoginTimestamp': now,
        'lastActivityTimestamp': now,
      });
    } catch (e) {
      print('Error tracking user activity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<User?>(
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
              return SignInScreen(fontSizeNotifier: widget.fontSizeNotifier); // Default to login screen
            }
          },
        ),
        // Global DraggableTTSFab removed - each screen will have its own local instance
      ],
    );
  }
  
  // Helper method to get context-aware text for the screen reader
  String _getContextAwareText(BuildContext context) {
    // Try to determine what screen we're on
    final route = ModalRoute.of(context)?.settings.name ?? '';
    final currentWidget = ModalRoute.of(context)?.settings.arguments;
    
    // Check if we're on a specific screen and return appropriate text
    if (route.contains('signin')) {
      return 'Sign in screen. Enter your credentials to log in.';
    } else if (route.contains('signup')) {
      return 'Sign up screen. Create a new account.';
    } else if (route.contains('profile')) {
      return 'Profile screen. View and edit your profile information.';
    } else if (route.contains('chat')) {
      return 'Chat screen. Communicate with volunteers or beneficiaries.';
    } else if (route.contains('resources') || route == 'resources_screen' || currentWidget is BeneficiaryResourcesScreen) {
      return 'Resources screen. Access helpful information and materials.';
    }
    
    // Check current context for specific widgets
    bool foundBeneficiaryResources = false;
    bool foundBeneficiaryHome = false;
    bool foundVolunteerHome = false;
    
    context.visitAncestorElements((element) {
      if (element.widget.runtimeType.toString() == 'BeneficiaryResourcesScreen') {
        foundBeneficiaryResources = true;
        return false;
      } else if (element.widget is BeneficiaryHome) {
        foundBeneficiaryHome = true;
        return false;
      } else if (element.widget is VolunteerHome) {
        foundVolunteerHome = true;
        return false;
      }
      return true;
    });
    
    if (foundBeneficiaryResources) {
      return 'Resources screen. Access helpful information and materials.';
    } else if (foundBeneficiaryHome) {
      return 'Beneficiary home screen. Access resources and support.';
    } else if (foundVolunteerHome) {
      return 'Volunteer home screen. Help beneficiaries and manage resources.';
    }
    
    // Default text if we can't determine the context
    return 'Screen reader activated. Tap to read screen content.';
  }
  
  // Helper method to get appropriate alignment based on route
  Alignment _getAlignmentForRoute(String route) {
    // Different positions for different screens
    if (route.contains('chat')) {
      return Alignment(0.95, -0.8); // Top right for chat screens
    } else if (route.contains('profile')) {
      return Alignment(0.95, 0.8); // Bottom right for profile
    } else if (route.contains('resources')) {
      return Alignment(0.8, -0.7); // Adjusted position for better visibility on resources screen
    }
    
    // Default position (right side, aligned with welcome message)
    return Alignment(0.95, -0.85);
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