import 'package:flutter/material.dart';

class ScreenReaderVolumeNotifier extends ValueNotifier<double> {
  ScreenReaderVolumeNotifier([double value = 1.0]) : super(value);
}

final screenReaderVolumeNotifier = ScreenReaderVolumeNotifier();
