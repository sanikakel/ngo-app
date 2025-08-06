import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../utils/error_handler.dart';

import '../accessibility/font_size_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/draggable_tts_fab.dart';


class SignUpScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;

  const SignUpScreen({required this.fontSizeNotifier, super.key});
  
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _getRoleKey(String display) {
    switch (display) {
      case 'Underprivileged Woman/Girl':
        return 'underprivileged';
      case 'Senior Citizen':
        return 'senior';
      case 'Specially-abled':
        return 'special';
      case 'Volunteer':
        return 'volunteer';
      default:
        return display.toLowerCase();
    }
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Volunteer';
  final List<String> _roles = [
    'Volunteer',
    'Senior Citizen',
    'Specially-abled',
    'Underprivileged Woman/Girl',
  ];
  bool _isLoading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _error = 'Name is required.';
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Save user details to Firestore, including name
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _getRoleKey(_selectedRole),
        'category': _selectedRole == 'Volunteer' ? '' : _getRoleKey(_selectedRole),
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginTimestamp': FieldValue.serverTimestamp(),
        'lastActivityTimestamp': FieldValue.serverTimestamp(),
      });
      // Optionally update FirebaseAuth displayName
      await userCredential.user!.updateDisplayName(_nameController.text.trim());
      Navigator.pop(context); // Return to SignInScreen (will redirect via AuthWrapper)
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = ErrorHandler.getUserFriendlyMessage(e);
      });
    } catch (e) {
      setState(() {
        _error = ErrorHandler.getUserFriendlyMessage(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(fontSize: widget.fontSizeNotifier.value + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0057B8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 80, // Increased height
        titleSpacing: 20, // Increased spacing
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/Yes I Can Mini Logo.png', width: 48, height: 48),
                      SizedBox(width: 8),
                      Text('Yes I Can', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0057B8))),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 8),
                  Text('Create your account', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 24),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(_error!, style: TextStyle(color: Colors.red, fontSize: 16)),
                    ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  Text('Which type of beneficiary are you?', style: TextStyle(fontSize: 16, color: Colors.black87)),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Select an option',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    ),
                    items: _roles.map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role, style: TextStyle(fontSize: 16)),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Color(0xFF2DBEF4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _signUp,
                            child: Text("Sign up", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?', style: TextStyle(fontSize: 15)),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text('Sign In', style: TextStyle(fontSize: 15, color: Color(0xFF2DBEF4), fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ),
  floatingActionButton: DraggableTTSFab(
    text: 'Sign up for an account. Enter your details and select your role.',
    fontSize: widget.fontSizeNotifier.value,
    volume: 1.0,
  ),
);
  }
}
