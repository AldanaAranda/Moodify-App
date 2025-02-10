import 'package:flutter/material.dart';
import 'package:flutter_application_base/helpers/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkmode = Preferences.darkmode;
  
  bool get isDarkmode => _isDarkmode; // modo oscuro por defecto

  void toggleTheme() {
    _isDarkmode = !_isDarkmode;
    Preferences.darkmode = _isDarkmode;
    notifyListeners();
  }
}