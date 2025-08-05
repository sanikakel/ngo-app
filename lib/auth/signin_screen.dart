import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'signup_screen.dart';
import '../accessibility/font_size_provider.dart';
import '../widgets/draggable_tts_fab.dart';

class SignInScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;

  const SignInScreen({required this.fontSizeNotifier, super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;


  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = 'Incorrect email or password. Please try again.';
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
  leading: Navigator.of(context).canPop()
      ? IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0057B8)),
          onPressed: () => Navigator.of(context).pop(),
        )
      : null,
  backgroundColor: Colors.white,
  elevation: 0,
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
                  Text('Sign In', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 8),
                  Text('Please sign in to continue', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 24),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(_error!, style: TextStyle(color: Colors.red, fontSize: 16)),
                    ),
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
                  SizedBox(height: 24),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0057B8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: 18),
                            ),
                            child: Text('Sign In', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                  SizedBox(height: 18),
                  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text("Don't have an account?", style: TextStyle(fontSize: 16)),
                       TextButton(
                         onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen(fontSizeNotifier: widget.fontSizeNotifier)));
                         },
                         child: Text('Sign Up', style: TextStyle(fontSize: 16, color: Color(0xFF0057B8))),
                       ),
                     ],
                   ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
