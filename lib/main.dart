import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/auth_wrapper.dart';
import 'accessibility/font_size_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Make sure firebase_options.dart is configured if needed
  final fontSizeNotifier = FontSizeNotifier(16.0);
  runApp(
    ValueListenableBuilder<double>(
      valueListenable: fontSizeNotifier,
      builder: (context, fontSize, _) {
        return MyApp(fontSizeNotifier: fontSizeNotifier);
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;
  const MyApp({super.key, required this.fontSizeNotifier});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //debugShowCheckedModeBanner: false,
      home: AuthWrapper(fontSizeNotifier: fontSizeNotifier),
    );
  }
}
