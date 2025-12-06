import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/features/global_listening/tools/settings_tools.dart';

void main() {
  // ==========================================================================
  // Settings Tools Definition Tests
  // ==========================================================================
  group('settingsTools', () {
    test('settingsTools is a non-empty list', () {
      expect(settingsTools, isNotEmpty);
    });

    test('settingsTools has exactly one element', () {
      expect(settingsTools.length, 1);
    });

    test('first element contains functionDeclarations', () {
      expect(settingsTools[0], contains('functionDeclarations'));
    });

    test('functionDeclarations is a list', () {
      final declarations = settingsTools[0]['functionDeclarations'];
      expect(declarations, isList);
    });

    test('has exactly 1 function declaration (update_settings)', () {
      final declarations = settingsTools[0]['functionDeclarations'] as List;
      expect(declarations.length, 1);
    });

    group('update_settings tool', () {
      late Map<String, dynamic> tool;

      setUp(() {
        final declarations = settingsTools[0]['functionDeclarations'] as List;
        tool = declarations[0] as Map<String, dynamic>;
      });

      test('has correct name', () {
        expect(tool['name'], 'update_settings');
      });

      test('has non-empty description', () {
        expect(tool['description'], isNotEmpty);
      });

      test('has parameters object', () {
        expect(tool, contains('parameters'));
        expect(tool['parameters'], isMap);
      });

      test('parameters has type object', () {
        final params = tool['parameters'] as Map<String, dynamic>;
        expect(params['type'], 'object');
      });

      test('parameters has properties', () {
        final params = tool['parameters'] as Map<String, dynamic>;
        expect(params, contains('properties'));
        expect(params['properties'], isMap);
      });

      group('parameter properties', () {
        late Map<String, dynamic> properties;

        setUp(() {
          final params = tool['parameters'] as Map<String, dynamic>;
          properties = params['properties'] as Map<String, dynamic>;
        });

        test('has language property', () {
          expect(properties, contains('language'));
          expect(properties['language']['type'], 'string');
          expect(properties['language']['enum'], contains('en-US'));
          expect(properties['language']['enum'], contains('hu-HU'));
        });

        test('has speed property', () {
          expect(properties, contains('speed'));
          expect(properties['speed']['type'], 'number');
        });

        test('has pitch property', () {
          expect(properties, contains('pitch'));
          expect(properties['pitch']['type'], 'number');
        });

        test('has font_size property', () {
          expect(properties, contains('font_size'));
          expect(properties['font_size']['type'], 'number');
        });

        test('has theme_mode property', () {
          expect(properties, contains('theme_mode'));
          expect(properties['theme_mode']['type'], 'string');
          expect(properties['theme_mode']['enum'], contains('light'));
          expect(properties['theme_mode']['enum'], contains('dark'));
          expect(properties['theme_mode']['enum'], contains('system'));
        });

        test('has accessibility_theme property', () {
          expect(properties, contains('accessibility_theme'));
          expect(properties['accessibility_theme']['type'], 'string');
          expect(properties['accessibility_theme']['enum'], contains('none'));
          expect(
            properties['accessibility_theme']['enum'],
            contains('high_contrast'),
          );
          expect(
            properties['accessibility_theme']['enum'],
            contains('colorblind'),
          );
          expect(properties['accessibility_theme']['enum'], contains('amoled'));
        });

        test('has ui_mode property', () {
          expect(properties, contains('ui_mode'));
          expect(properties['ui_mode']['type'], 'string');
          expect(properties['ui_mode']['enum'], contains('standard'));
          expect(properties['ui_mode']['enum'], contains('simplified'));
        });

        test('all properties have description', () {
          for (final entry in properties.entries) {
            final prop = entry.value as Map<String, dynamic>;
            expect(
              prop,
              contains('description'),
              reason: '${entry.key} should have description',
            );
            expect(
              prop['description'],
              isNotEmpty,
              reason: '${entry.key} description should not be empty',
            );
          }
        });
      });

      test('required is an empty list', () {
        final params = tool['parameters'] as Map<String, dynamic>;
        expect(params['required'], isEmpty);
      });
    });
  });
}
