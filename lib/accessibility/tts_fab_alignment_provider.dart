import 'package:flutter/material.dart';

class TTSFabAlignmentProvider extends ChangeNotifier {
  // Default: right side, ~20% from top
  Alignment _alignment = Alignment(0.95, -0.7);

  Alignment get alignment => _alignment;

  set alignment(Alignment newAlignment) {
    _alignment = newAlignment;
    notifyListeners();
  }
}
