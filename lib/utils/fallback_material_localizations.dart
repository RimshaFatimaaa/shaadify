import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A custom MaterialLocalizations delegate that falls back to English
/// for locales not supported by GlobalMaterialLocalizations
class FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support all locales - we'll fallback to English if not supported by Flutter
    return true;
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Try to load the standard MaterialLocalizations for this locale
    final standardDelegate = GlobalMaterialLocalizations.delegate;
    
    if (standardDelegate.isSupported(locale)) {
      return await standardDelegate.load(locale);
    }
    
    // Fallback to English for unsupported locales (like sd, bal, ps, skr)
    return await standardDelegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

/// A custom WidgetsLocalizations delegate that falls back to English
/// for locales not supported by GlobalWidgetsLocalizations
class FallbackWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const FallbackWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    final standardDelegate = GlobalWidgetsLocalizations.delegate;
    
    if (standardDelegate.isSupported(locale)) {
      return await standardDelegate.load(locale);
    }
    
    // Fallback to English for unsupported locales
    return await standardDelegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackWidgetsLocalizationsDelegate old) => false;
}
