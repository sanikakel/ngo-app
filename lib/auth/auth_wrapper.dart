import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';

import '../accessibility/font_size_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/volunteer_home.dart';
import '../home/beneficiary_home.dart';
import '../resources/beneficiary_resources_screen.dart' show BeneficiaryResourcesScreen;
import '../utils/error_handler.dart';

class AuthWrapper extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const AuthWrapper({required this.fontSizeNotifier, super.key});
  
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  // Track current route for context-aware TTS
  String _currentRouteName = '';
  // Cache for user role to avoid repeated Firestore calls
  Map<String, String> _userRoleCache = {};
  
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
      // Check cache first
      if (_userRoleCache.containsKey(user.uid)) {
        final role = _userRoleCache[user.uid]!;
        _trackUserActivityInBackground(user.uid);
        return _buildHomeScreen(role);
      }

      // Add timeout to prevent hanging
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .timeout(Duration(seconds: 10)); // 10 second timeout
      
      final role = userDoc.data()?['role'] ?? 'beneficiary';
      
      // Cache the role
      _userRoleCache[user.uid] = role;
      
      // Track user activity in background (don't wait for it)
      _trackUserActivityInBackground(user.uid);
      
      return _buildHomeScreen(role);
    } catch (e) {
      print('Error getting home screen: $e');
      // Return default screen on error with user-friendly message
      return _buildHomeScreen('beneficiary');
    }
  }

  Widget _buildHomeScreen(String role) {
    if (role == 'volunteer') {
      return VolunteerHome(fontSizeNotifier: widget.fontSizeNotifier);
    } else {
      // Default to beneficiary home, pass the role/category for customization
      return BeneficiaryHome(category: role, fontSizeNotifier: widget.fontSizeNotifier);
    }
  }

  void _trackUserActivityInBackground(String userId) {
    // Run in background without waiting
    Future.delayed(Duration.zero, () async {
      try {
        final now = Timestamp.now();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'lastLoginTimestamp': now,
          'lastActivityTimestamp': now,
        }).timeout(Duration(seconds: 5)); // 5 second timeout
      } catch (e) {
        print('Error tracking user activity: $e');
        // Don't show error to user, this is background operation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Connecting to server...', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              // Fetch user role from Firestore and route accordingly
              return FutureBuilder<Widget>(
                future: _getHomeScreen(snapshot.data!),
                builder: (context, homeSnapshot) {
                  if (homeSnapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading your profile...', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  } else if (homeSnapshot.hasData) {
                    return homeSnapshot.data!;
                  } else {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red),
                            SizedBox(height: 16),
                            Text('Error loading user data', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {}); // Retry
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
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