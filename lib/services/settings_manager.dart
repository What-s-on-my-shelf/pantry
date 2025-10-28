import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {
  late SharedPreferences _prefs;

  int _expirationWarningDays = 5; // Default value
  int get expirationWarningDays => _expirationWarningDays;

  SettingsManager();

  // Load all settings from the device
  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _expirationWarningDays = _prefs.getInt('expirationWarningDays') ?? 5;
    notifyListeners();
  }

  // Method to update and save the setting
  Future<void> setExpirationWarningDays(int days) async {
    _expirationWarningDays = days;
    await _prefs.setInt('expirationWarningDays', days);
    notifyListeners();
  }
}