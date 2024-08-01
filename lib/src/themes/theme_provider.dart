import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appThemeStateNotifier = ChangeNotifierProvider((ref) => AppThemeState());

class AppThemeState extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  AppThemeState() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  void _saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  void setLightTheme() {
    _isDarkMode = false;
    _saveTheme(false);
    notifyListeners();
  }

  void setDarkTheme() {
    _isDarkMode = true;
    _saveTheme(true);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme(_isDarkMode);
    notifyListeners();
  }
}
