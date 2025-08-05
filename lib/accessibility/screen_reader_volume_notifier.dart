import 'package:flutter/material.dart';

class ScreenReaderVolumeNotifier extends ValueNotifier<double> {
  ScreenReaderVolumeNotifier([double value = 1.0]) : super(value);
  
  // Ensure volume is between 0.0 and 1.0
  @override
  set value(double newValue) {
    if (newValue < 0.0) {
      super.value = 0.0;
    } else if (newValue > 1.0) {
      super.value = 1.0;
    } else {
      super.value = newValue;
    }
  }

  // Increase volume by 0.1, capped at 1.0
  void increaseVolume() {
    value = value + 0.1;
  }

  // Decrease volume by 0.1, floored at 0.0
  void decreaseVolume() {
    value = value - 0.1;
  }

  // Toggle mute/unmute
  void toggleMute() {
    if (value > 0.0) {
      // Store current volume before muting
      final previousVolume = value;
      value = 0.0;
      // Store the previous volume for unmuting later
      _previousVolume = previousVolume;
    } else {
      // Restore previous volume or default to 1.0
      value = _previousVolume ?? 1.0;
    }
  }

  // Store previous volume for mute/unmute toggle
  double? _previousVolume;
}

final screenReaderVolumeNotifier = ScreenReaderVolumeNotifier();
