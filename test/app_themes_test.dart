import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/core/constants/app_themes.dart';

void main() {
  // ==========================================================================
  // AppThemes Tests
  // ==========================================================================

  group('AppThemes.defaultLightTheme', () {
    final theme = AppThemes.defaultLightTheme;

    test('has light brightness', () {
      expect(theme.brightness, Brightness.light);
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, true);
    });

    test('has app bar theme', () {
      expect(theme.appBarTheme, isNotNull);
    });

    test('app bar has white background', () {
      expect(theme.appBarTheme.backgroundColor, Colors.white);
    });

    test('app bar has black foreground', () {
      expect(theme.appBarTheme.foregroundColor, Colors.black);
    });

    test('app bar has no elevation', () {
      expect(theme.appBarTheme.elevation, 0);
    });

    test('has card theme', () {
      expect(theme.cardTheme, isNotNull);
    });

    test('has elevated button theme', () {
      expect(theme.elevatedButtonTheme, isNotNull);
    });

    test('has input decoration theme', () {
      expect(theme.inputDecorationTheme, isNotNull);
      expect(theme.inputDecorationTheme.filled, true);
    });
  });

  group('AppThemes.defaultDarkTheme', () {
    final theme = AppThemes.defaultDarkTheme;

    test('has dark brightness', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, true);
    });

    test('app bar has white foreground', () {
      expect(theme.appBarTheme.foregroundColor, Colors.white);
    });

    test('app bar has no elevation', () {
      expect(theme.appBarTheme.elevation, 0);
    });
  });

  group('AppThemes.highContrastTheme', () {
    final theme = AppThemes.highContrastTheme;

    test('has dark brightness', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('has black scaffold background', () {
      expect(theme.scaffoldBackgroundColor, Colors.black);
    });

    test('uses yellow accent as primary', () {
      expect(theme.colorScheme.primary, Colors.yellowAccent);
    });

    test('has white text on background', () {
      expect(theme.colorScheme.onBackground, Colors.white);
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, true);
    });

    test('app bar has black background', () {
      expect(theme.appBarTheme.backgroundColor, Colors.black);
    });
  });

  group('AppThemes.colorblindTheme', () {
    final theme = AppThemes.colorblindTheme;

    test('has light brightness', () {
      expect(theme.brightness, Brightness.light);
    });

    test('uses blue as primary', () {
      expect(theme.colorScheme.primary, Colors.blue);
    });

    test('uses deep orange as secondary', () {
      expect(theme.colorScheme.secondary, Colors.deepOrange);
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, true);
    });
  });

  group('AppThemes.amoledTheme', () {
    final theme = AppThemes.amoledTheme;

    test('has dark brightness', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('has true black scaffold background', () {
      expect(theme.scaffoldBackgroundColor, const Color(0xFF000000));
    });

    test('has true black background color', () {
      expect(theme.colorScheme.background, const Color(0xFF000000));
    });

    test('has true black surface color', () {
      expect(theme.colorScheme.surface, const Color(0xFF000000));
    });

    test('has off-white text color', () {
      expect(theme.colorScheme.onBackground, const Color(0xFFF2F2F2));
      expect(theme.colorScheme.onSurface, const Color(0xFFF2F2F2));
    });

    test('app bar has black background', () {
      expect(theme.appBarTheme.backgroundColor, const Color(0xFF000000));
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, true);
    });
  });

  group('All themes', () {
    test('all themes use Material 3', () {
      expect(AppThemes.defaultLightTheme.useMaterial3, true);
      expect(AppThemes.defaultDarkTheme.useMaterial3, true);
      expect(AppThemes.highContrastTheme.useMaterial3, true);
      expect(AppThemes.colorblindTheme.useMaterial3, true);
      expect(AppThemes.amoledTheme.useMaterial3, true);
    });

    test('all themes have valid color schemes', () {
      expect(AppThemes.defaultLightTheme.colorScheme, isNotNull);
      expect(AppThemes.defaultDarkTheme.colorScheme, isNotNull);
      expect(AppThemes.highContrastTheme.colorScheme, isNotNull);
      expect(AppThemes.colorblindTheme.colorScheme, isNotNull);
      expect(AppThemes.amoledTheme.colorScheme, isNotNull);
    });
  });
}
