import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English
  static const String _languageKey = 'selected_language';

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        _locale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  // Supported languages in Pakistan
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'ur', 'name': 'Urdu', 'nativeName': 'اردو'},
    {'code': 'ps', 'name': 'Pashto', 'nativeName': 'پښتو'},
    {'code': 'sd', 'name': 'Sindhi', 'nativeName': 'سنڌي'},
    {'code': 'bal', 'name': 'Balochi', 'nativeName': 'بلوچی'},
    {'code': 'skr', 'name': 'Saraiki', 'nativeName': 'سرائیکی'},
  ];

  String getLanguageName(String code) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    );
    return language['name'] ?? 'English';
  }

  String getLanguageNativeName(String code) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    );
    return language['nativeName'] ?? 'English';
  }
}
