import 'package:flutter/material.dart';
import 'package:vedanta_frontend/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData.brightness == Brightness.light) {
      setTheme(AppTheme.darkTheme);
    } else {
      setTheme(AppTheme.lightTheme);
    }
  }
}
