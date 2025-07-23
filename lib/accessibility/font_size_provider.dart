import 'package:flutter/material.dart';

class FontSizeNotifier extends ValueNotifier<double> {
  FontSizeNotifier([double initialFontSize = 16.0]) : super(initialFontSize);

  void increase() {
    if (value < 30.0) {
      value += 2;
    }
  }

  void decrease() {
    if (value > 10.0) {
      value -= 2;
    }
  }

  void setFontSize(double size) {
    if (size >= 10.0 && size <= 30.0) {
      value = size;
    }
  }

  double get fontSize => value;
}

