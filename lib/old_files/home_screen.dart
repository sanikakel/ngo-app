
/*
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Image.asset(
                    'assets/Yes I Can Mini Logo.png',
                    height: 120,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Welcome to the\nYes I Can Foundation App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00B0F0),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/beneficiary');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00B0F0),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'I am a Beneficiary',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/volunteer');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'I am a Volunteer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 60),
                  Text(
                    'Empowering Everyone. Every Day.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/