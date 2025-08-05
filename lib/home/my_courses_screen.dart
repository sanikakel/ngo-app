import 'package:flutter/material.dart';

import '../accessibility/font_size_provider.dart';

class MyCoursesScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const MyCoursesScreen({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0057B8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('My Courses', style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
      body: Center(
        child: Text('My Courses', style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
    );
  }
}
