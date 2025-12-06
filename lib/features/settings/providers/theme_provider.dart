import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumiai/core/constants/app_themes.dart'; // Import custom themes

part 'theme_provider.g.dart';

// Az enum a témák lehetséges állapotait definiálja
enum AppThemeMode { light, dark, system }

// ÚJ ENUM: A kiegészítő, hozzáférhetőségi témák típusai
enum CustomThemeType {
  none, // Használd a standard light/dark témát
  highContrast,
  colorblindFriendly,
  amoled,
}

// Az AppThemeMode mellett tároljuk a kiválasztott custom téma típusát is.
// Ezt az állapotot a ThemeController fogja kezelni.
class ThemeState {
  final AppThemeMode appThemeMode;
  final CustomThemeType customThemeType;

  const ThemeState({
    this.appThemeMode = AppThemeMode.system,
    this.customThemeType = CustomThemeType.none,
  });

  ThemeState copyWith({
    AppThemeMode? appThemeMode,
    CustomThemeType? customThemeType,
  }) {
    return ThemeState(
      appThemeMode: appThemeMode ?? this.appThemeMode,
      customThemeType: customThemeType ?? this.customThemeType,
    );
  }
}

const _kAppThemeModeKey = 'app_theme_mode';
const _kCustomThemeTypeKey = 'custom_theme_type';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  late final SharedPreferences _prefs;

  @override
  // Aszinkron betöltés shared_preferences-ből
  Future<ThemeState> build() async {
    _prefs = await SharedPreferences.getInstance();

    final savedAppModeString = _prefs.getString(_kAppThemeModeKey);
    final savedCustomThemeString = _prefs.getString(_kCustomThemeTypeKey);

    final initialAppThemeMode = savedAppModeString == null
        ? AppThemeMode.system
        : AppThemeMode.values.firstWhere(
            (mode) => mode.name == savedAppModeString,
            orElse: () => AppThemeMode.system,
          );

    final initialCustomThemeType = savedCustomThemeString == null
        ? CustomThemeType.none
        : CustomThemeType.values.firstWhere(
            (type) => type.name == savedCustomThemeString,
            orElse: () => CustomThemeType.none,
          );

    return ThemeState(
      appThemeMode: initialAppThemeMode,
      customThemeType: initialCustomThemeType,
    );
  }

  // Publikus metódus a standard téma beállítására és mentésére
  void setAppThemeMode(AppThemeMode mode) async {
    state = AsyncValue.data(state.value!.copyWith(appThemeMode: mode));
    await _prefs.setString(_kAppThemeModeKey, mode.name);
  }

  // Publikus metódus a custom téma beállítására és mentésére
  void setCustomThemeType(CustomThemeType type) async {
    state = AsyncValue.data(state.value!.copyWith(customThemeType: type));
    await _prefs.setString(_kCustomThemeTypeKey, type.name);
  }
}

// Segéd provider a ThemeMode-hoz (standard light/dark/system).
// Csak akkor érhető el, ha a ThemeController betöltődött (hasValue).
// Új név a kód ütközések elkerülésére, mivel az eredeti `materialThemeMode`
// most már a teljes ThemeData-t fogja szolgáltatni.
@riverpod
AppThemeMode currentAppThemeMode(Ref ref) {
  return ref
      .watch(themeControllerProvider)
      .when(
        data: (themeState) => themeState.appThemeMode,
        loading: () => AppThemeMode.system,
        error: (_, __) => AppThemeMode.system,
      );
}

// ÚJ PROVIDER: Ez fogja szolgáltatni a teljes ThemeData objektumot a MaterialApp számára.
// Figyelembe veszi mind az AppThemeMode-ot, mind a CustomThemeType-ot.
@riverpod
ThemeData selectedAppTheme(Ref ref) {
  final themeState = ref.watch(themeControllerProvider);

  return themeState.when(
    data: (state) {
      if (state.customThemeType != CustomThemeType.none) {
        // Ha custom téma van kiválasztva, azt használjuk
        return switch (state.customThemeType) {
          CustomThemeType.highContrast => AppThemes.highContrastTheme,
          CustomThemeType.colorblindFriendly => AppThemes.colorblindTheme,
          CustomThemeType.amoled => AppThemes.amoledTheme,
          _ => ThemeData.light(useMaterial3: true), // Fallback
        };
      } else {
        // Ha nincs custom téma, akkor a standard light/dark/system logikát követjük
        return switch (state.appThemeMode) {
          AppThemeMode.light => AppThemes.defaultLightTheme,
          AppThemeMode.dark => AppThemes.defaultDarkTheme,
          AppThemeMode.system =>
            PlatformDispatcher.instance.platformBrightness == Brightness.dark
                ? AppThemes.defaultDarkTheme
                : AppThemes.defaultLightTheme,
        };
      }
    },
    loading: () =>
        AppThemes.defaultLightTheme, // Alapértelmezett betöltés alatt
    error: (_, __) =>
        AppThemes.defaultLightTheme, // Alapértelmezett hiba esetén
  );
}
