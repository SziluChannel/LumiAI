import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

/// Controller for app language/locale settings
@riverpod
class LanguageController extends _$LanguageController {
  static const _languageKey = 'app_language';

  @override
  Locale build() {
    // Load saved language preference on startup
    _loadSavedLanguage();
    // Default to Hungarian
    return const Locale('hu');
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      state = Locale(savedLanguage);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }

  void toggleLanguage() {
    if (state.languageCode == 'hu') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('hu'));
    }
  }
}
