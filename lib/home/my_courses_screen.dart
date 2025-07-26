import 'package:flutter/material.dart';
import '../accessibility/font_size_provider.dart';

class MyCoursesScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const MyCoursesScreen({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Courses', style: TextStyle(fontSize: fontSizeNotifier.value))),
      body: Center(
        child: Text('Your enrolled courses will appear here.', style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
    );
  }
}
