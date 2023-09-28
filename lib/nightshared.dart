import 'dart:async';

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    updateThemeBasedOnTime();
    startTimerToUpdateTheme();
  }
  bool light1 = false;
  Timer? timer;
  void startTimerToUpdateTheme() {
    const duration = Duration(seconds: 2);
    timer = Timer.periodic(duration, (Timer timer) {
      updateThemeBasedOnTime();
      notifyListeners();
    });
  }

  void updateThemeBasedOnTime() {
    final currentTime = DateTime.now();

    if ((currentTime.hour >= 15 && currentTime.minute >= 4)) {
      theme(true);
    }
    if ((currentTime.hour >= 15 && currentTime.minute >= 5)) {
      theme(false);
    }

    notifyListeners();
  }

  void theme(bool value) {
    light1 = value;
    notifyListeners();
  }
}
