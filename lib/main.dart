import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/auth_wrapper.dart';
import 'accessibility/font_size_provider.dart';
import 'package:provider/provider.dart';
import 'accessibility/tts_fab_alignment_provider.dart';
import 'accessibility/language_provider.dart';
import 'accessibility/screen_reader_volume_notifier.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fontSizeNotifier = FontSizeNotifier(16.0);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FontSizeNotifier>.value(value: fontSizeNotifier),
        ChangeNotifierProvider<TTSFabAlignmentProvider>(create: (_) => TTSFabAlignmentProvider()),
        ChangeNotifierProvider<LanguageNotifier>(create: (_) => LanguageNotifier('en')),
        ChangeNotifierProvider<ScreenReaderVolumeNotifier>.value(value: screenReaderVolumeNotifier),
      ],
      child: ValueListenableBuilder<double>(
        valueListenable: fontSizeNotifier,
        builder: (context, fontSize, _) {
          return MyApp(fontSizeNotifier: fontSizeNotifier);
        },
      ),
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
      ),
      home: AuthWrapper(fontSizeNotifier: fontSizeNotifier),
    );
  }
}
