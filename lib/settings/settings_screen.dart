import 'package:flutter/material.dart';
import '../accessibility/font_size_provider.dart';

class SettingsScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const SettingsScreen({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: TextStyle(fontSize: fontSizeNotifier.value))),
      body: Center(
        child: Text('Settings and accessibility options will appear here.', style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
    );
  }
}
