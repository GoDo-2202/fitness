import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale_code');
    if (code != null) {
      if (code == 'system') {
        _locale = null;
      } else {
        _locale = Locale(code);
      }
      notifyListeners();
    }
  }

  // Change locale
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.setString('locale_code', 'system');
    } else {
      await prefs.setString('locale_code', locale.languageCode);
    }
    notifyListeners();
  }

  // Reset về system locale
  Future<void> clearLocale() async {
    _locale = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_code', 'system');
    notifyListeners();
  }
}
