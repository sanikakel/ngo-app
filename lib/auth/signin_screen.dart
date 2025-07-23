import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import '../accessibility/font_size_provider.dart';

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
      appBar: AppBar(title: Text("Sign In", style: TextStyle(fontSize: widget.fontSizeNotifier.value),)),
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
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signIn,
                    child: Text("Sign In", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SignUpScreen(fontSizeNotifier: widget.fontSizeNotifier)));
              },
              child: Text("Don't have an account? Sign up here.", style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
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

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacementNamed(context, '/home');
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
      appBar: AppBar(title: Text("Sign In")),
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
                validator: (val) => val!.isEmpty ? "Enter your password" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signIn,
                child: Text("Sign In"),
              ),
              SizedBox(height: 10),
              Text(error, style: TextStyle(color: Colors.red)),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text("Don't have an account? Sign Up"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/