import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final String? fontFamily; // Null means system default

  const ThemeState({
    this.appThemeMode = AppThemeMode.system,
    this.customThemeType = CustomThemeType.none,
    this.fontFamily,
  });

  ThemeState copyWith({
    AppThemeMode? appThemeMode,
    CustomThemeType? customThemeType,
    String? fontFamily,
  }) {
    return ThemeState(
      appThemeMode: appThemeMode ?? this.appThemeMode,
      customThemeType: customThemeType ?? this.customThemeType,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}

const _kAppThemeModeKey = 'app_theme_mode';
const _kCustomThemeTypeKey = 'custom_theme_type';
const _kFontFamilyKey = 'font_family';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  late final SharedPreferences _prefs;

  @override
  // Aszinkron betöltés shared_preferences-ből
  Future<ThemeState> build() async {
    _prefs = await SharedPreferences.getInstance();

    final savedAppModeString = _prefs.getString(_kAppThemeModeKey);
    final savedCustomThemeString = _prefs.getString(_kCustomThemeTypeKey);
    final savedFontFamily = _prefs.getString(_kFontFamilyKey);

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
      fontFamily: savedFontFamily,
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

  // Set font family
  void setFontFamily(String? fontFamily) async {
    // If null is passed, we revert to system default
    state = AsyncValue.data(state.value!.copyWith(fontFamily: fontFamily));
    if (fontFamily == null) {
      await _prefs.remove(_kFontFamilyKey);
    } else {
      await _prefs.setString(_kFontFamilyKey, fontFamily);
    }
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
      ThemeData baseTheme;

      if (state.customThemeType == CustomThemeType.highContrast) {
        baseTheme = AppThemes.highContrastTheme;
      } else if (state.customThemeType == CustomThemeType.colorblindFriendly) {
        baseTheme = AppThemes.colorblindTheme;
      } else if (state.customThemeType == CustomThemeType.amoled) {
        baseTheme = AppThemes.amoledTheme;
      } else {
        // Standard theme logic
        if (state.appThemeMode == AppThemeMode.light) {
          baseTheme = AppThemes.defaultLightTheme;
        } else if (state.appThemeMode == AppThemeMode.dark) {
          baseTheme = AppThemes.defaultDarkTheme;
        } else {
          // System
          final brightness = PlatformDispatcher.instance.platformBrightness;
          baseTheme = brightness == Brightness.dark
              ? AppThemes.defaultDarkTheme
              : AppThemes.defaultLightTheme;
        }
      }

      // Apply font family if selected
      if (state.fontFamily != null) {
        try {
          // 1. Get the TextTheme with the selected font applied
          final fontTextTheme = GoogleFonts.getTextTheme(
            state.fontFamily!,
            baseTheme.textTheme,
          );

          // 2. Get a TextStyle for the font family to apply to specific overrides (like AppBar)
          final fontTextStyle = GoogleFonts.getFont(state.fontFamily!);
          final fontFamily = fontTextStyle.fontFamily;

          // 3. Return the new Theme with updated TextTheme and AppBarTheme
          return baseTheme.copyWith(
            textTheme: fontTextTheme,
            appBarTheme: baseTheme.appBarTheme.copyWith(
              titleTextStyle: baseTheme.appBarTheme.titleTextStyle?.copyWith(
                fontFamily: fontFamily,
              ),
            ),
          );
        } catch (e) {
          // Fallback if font not found
          return baseTheme;
        }
      }
      return baseTheme;
    },
    loading: () => AppThemes.defaultLightTheme,
    error: (_, __) => AppThemes.defaultLightTheme,
  );
}
