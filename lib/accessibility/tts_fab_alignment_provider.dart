import 'package:flutter/material.dart';

class TTSFabAlignmentProvider extends ChangeNotifier {
  // Default: positioned as requested by the user
  Alignment _alignment = Alignment(0.8, -0.7);

  Alignment get alignment => _alignment;

  set alignment(Alignment newAlignment) {
    _alignment = newAlignment;
    notifyListeners();
  }
}
