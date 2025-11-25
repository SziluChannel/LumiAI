import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

// Az enum a témák lehetséges állapotait definiálja
enum AppThemeMode { light, dark, system }

const _kThemeModeKey = 'app_theme_mode';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  
  late final SharedPreferences _prefs;
  
  @override
  // Aszinkron betöltés shared_preferences-ből
  Future<AppThemeMode> build() async {
    _prefs = await SharedPreferences.getInstance();
    
    final savedModeString = _prefs.getString(_kThemeModeKey);
    
    if (savedModeString == null) {
      return AppThemeMode.system; // Alapértelmezett: Rendszer
    }

    // String konvertálása AppThemeMode enum-má
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == savedModeString,
      orElse: () => AppThemeMode.system,
    );
  }

  // Publikus metódus a téma beállítására és mentésére
  void setMode(AppThemeMode mode) async {
    // Frissítjük a provider állapotát
    state = AsyncValue.data(mode); 
    // Mentjük a shared_preferences-be (a .name használatával)
    await _prefs.setString(_kThemeModeKey, mode.name);
  }
}

// Segéd provider a ThemeMode-hoz, amit a MaterialApp használhat.
// Csak akkor érhető el, ha a ThemeController betöltődött (hasValue).
@riverpod
ThemeMode materialThemeMode(Ref ref) {
  final appThemeMode = ref.watch(themeControllerProvider);
  
  return appThemeMode.when(
    data: (mode) {
      return switch (mode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      };
    },
    // Betöltés alatt vagy hiba esetén maradjunk az alapértelmezett rendszertémánál
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
}
