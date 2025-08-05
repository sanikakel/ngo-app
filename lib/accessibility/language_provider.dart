import 'package:flutter/material.dart';

class LanguageNotifier extends ValueNotifier<String> {
  LanguageNotifier(String value) : super(value);

  void setLanguage(String lang) {
    value = lang;
    notifyListeners();
  }
}

const supportedLanguages = [
  {'code': 'en', 'label': 'English'},
  {'code': 'hi', 'label': 'Hindi'},
  {'code': 'mr', 'label': 'Marathi'},
];
