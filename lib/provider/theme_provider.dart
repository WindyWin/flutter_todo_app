import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode mode = ThemeMode.light;

  void changeThemeMode(ThemeMode themeMode) {
    mode = themeMode;
    debugPrint(mode.toString());
    notifyListeners();
  }
}
