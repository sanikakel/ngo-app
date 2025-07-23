import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../accessibility/font_size_provider.dart';

class SignUpScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;

  const SignUpScreen({required this.fontSizeNotifier, super.key});
  
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pop(context); // Return to SignInScreen (will redirect via AuthWrapper)
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
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
      appBar: AppBar(title: Text("Sign Up", style: TextStyle(fontSize: widget.fontSizeNotifier.value))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red, fontSize: widget.fontSizeNotifier.value)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password (min. 6 chars)"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signUp,
                    child: Text("Sign Up", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                  ),
          ],
        ),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacementNamed(context, '/home'); // Redirect after sign-up
      } catch (e) {
        setState(() {
          error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (val) => email = val,
                validator: (val) => val!.isEmpty ? "Enter an email" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) => val!.length < 6 ? "Enter a 6+ char password" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                child: Text("Sign Up"),
              ),
              SizedBox(height: 10),
              Text(error, style: TextStyle(color: Colors.red)),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: Text("Already have an account? Sign In"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/