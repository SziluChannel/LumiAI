import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/core/constants/app_prompts.dart';

void main() {
  // ==========================================================================
  // AppPrompts Tests
  // ==========================================================================
  group('AppPrompts', () {
    group('Static Constants', () {
      test('systemInstruction is non-empty', () {
        expect(AppPrompts.systemInstruction, isNotEmpty);
      });

      test('systemInstruction contains key instructions', () {
        expect(
          AppPrompts.systemInstruction,
          contains('visually impaired'),
        );
        expect(
          AppPrompts.systemInstruction,
          contains('camera'),
        );
      });

      test('identifyObject is non-empty', () {
        expect(AppPrompts.identifyObject, isNotEmpty);
      });

      test('identifyObject contains spatial guidance', () {
        expect(
          AppPrompts.identifyObject,
          contains('spatial'),
        );
      });

      test('identifyObjectLive is non-empty', () {
        expect(AppPrompts.identifyObjectLive, isNotEmpty);
      });

      test('identifyObjectLive indicates camera is already open', () {
        expect(
          AppPrompts.identifyObjectLive,
          contains('camera is already open'),
        );
      });

      test('describeScene is non-empty', () {
        expect(AppPrompts.describeScene, isNotEmpty);
      });

      test('describeScene requests scene description', () {
        expect(
          AppPrompts.describeScene.toLowerCase(),
          contains('describe'),
        );
      });

      test('readText is non-empty', () {
        expect(AppPrompts.readText, isNotEmpty);
      });

      test('readText mentions reading text', () {
        expect(
          AppPrompts.readText.toLowerCase(),
          contains('read'),
        );
        expect(
          AppPrompts.readText.toLowerCase(),
          contains('text'),
        );
      });
    });

    group('findSpecificObject', () {
      test('returns non-empty string', () {
        final result = AppPrompts.findSpecificObject('keys');
        expect(result, isNotEmpty);
      });

      test('includes the object name in the prompt', () {
        final result = AppPrompts.findSpecificObject('keys');
        expect(result, contains('keys'));
      });

      test('includes the object name with quotes', () {
        final result = AppPrompts.findSpecificObject('my wallet');
        expect(result, contains("'my wallet'"));
      });

      test('works with different object names', () {
        final objects = ['phone', 'glasses', 'remote control', 'water bottle'];

        for (final obj in objects) {
          final result = AppPrompts.findSpecificObject(obj);
          expect(result, contains(obj));
        }
      });

      test('contains location instruction', () {
        final result = AppPrompts.findSpecificObject('book');
        expect(result.toLowerCase(), contains('locate'));
      });

      test('asks for relative position', () {
        final result = AppPrompts.findSpecificObject('phone');
        expect(result.toLowerCase(), contains('camera position'));
      });

      test('handles empty string', () {
        final result = AppPrompts.findSpecificObject('');
        expect(result, isNotEmpty);
        expect(result, contains("''"));
      });

      test('handles special characters', () {
        final result = AppPrompts.findSpecificObject("mom's ring");
        expect(result, contains("mom's ring"));
      });
    });
  });
}
