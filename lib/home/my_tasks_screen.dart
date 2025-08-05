import 'package:flutter/material.dart';

import '../accessibility/font_size_provider.dart';

class MyTasksScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const MyTasksScreen({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Tasks', style: TextStyle(fontSize: fontSizeNotifier.value)),),
      body: Center(
        child: Text('Here are your assigned tasks.', style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
    );
  }
}
