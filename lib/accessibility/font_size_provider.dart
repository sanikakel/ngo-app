import 'package:flutter/material.dart';

class FontSizeNotifier extends ChangeNotifier {
  double _fontSize = 16.0; // default font size

  double get fontSize => _fontSize;

  void increase() {
    if (_fontSize < 30.0) {
      _fontSize += 2;
      notifyListeners();
    }
  }

  void decrease() {
    if (_fontSize > 10.0) {
      _fontSize -= 2;
      notifyListeners();
    }
  }

  void setFontSize(double size) {
    if (size >= 10.0 && size <= 30.0) {
      _fontSize = size;
      notifyListeners();
    }
  }
}
