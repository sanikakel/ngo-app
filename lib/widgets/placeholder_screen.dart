import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;

  const PlaceholderScreen({super.key, required this.title, this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    final iconWidget = icon != null
        ? Icon(icon, size: 64, color: Colors.grey.shade400)
        : Icon(Icons.construction, size: 64, color: Colors.grey.shade400);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 24),
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
            ]
          ],
        ),
      ),
    );
  }
}
