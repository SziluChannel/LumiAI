import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/features/global_listening/tools/camera_tools.dart';

void main() {
  // ==========================================================================
  // Camera Tools Definition Tests
  // ==========================================================================
  group('cameraTools', () {
    test('cameraTools is a non-empty list', () {
      expect(cameraTools, isNotEmpty);
    });

    test('cameraTools has exactly one element', () {
      expect(cameraTools.length, 1);
    });

    test('first element contains functionDeclarations', () {
      expect(cameraTools[0], contains('functionDeclarations'));
    });

    test('functionDeclarations is a list', () {
      final declarations = cameraTools[0]['functionDeclarations'];
      expect(declarations, isList);
    });

    test('has exactly 3 function declarations', () {
      final declarations = cameraTools[0]['functionDeclarations'] as List;
      expect(declarations.length, 3);
    });

    group('get_camera_status tool', () {
      late Map<String, dynamic> tool;

      setUp(() {
        final declarations = cameraTools[0]['functionDeclarations'] as List;
        tool = declarations[0] as Map<String, dynamic>;
      });

      test('has correct name', () {
        expect(tool['name'], 'get_camera_status');
      });

      test('has non-empty description', () {
        expect(tool['description'], isNotEmpty);
      });

      test('description mentions camera status', () {
        expect(
          (tool['description'] as String).toLowerCase(),
          contains('status'),
        );
      });
    });

    group('open_camera tool', () {
      late Map<String, dynamic> tool;

      setUp(() {
        final declarations = cameraTools[0]['functionDeclarations'] as List;
        tool = declarations[1] as Map<String, dynamic>;
      });

      test('has correct name', () {
        expect(tool['name'], 'open_camera');
      });

      test('has non-empty description', () {
        expect(tool['description'], isNotEmpty);
      });

      test('description mentions opening camera', () {
        final desc = (tool['description'] as String).toLowerCase();
        expect(desc, contains('open'));
        expect(desc, contains('camera'));
      });
    });

    group('close_camera tool', () {
      late Map<String, dynamic> tool;

      setUp(() {
        final declarations = cameraTools[0]['functionDeclarations'] as List;
        tool = declarations[2] as Map<String, dynamic>;
      });

      test('has correct name', () {
        expect(tool['name'], 'close_camera');
      });

      test('has non-empty description', () {
        expect(tool['description'], isNotEmpty);
      });

      test('description mentions closing camera', () {
        final desc = (tool['description'] as String).toLowerCase();
        expect(desc, contains('close'));
      });
    });

    test('all tools have name and description', () {
      final declarations = cameraTools[0]['functionDeclarations'] as List;

      for (final tool in declarations) {
        final toolMap = tool as Map<String, dynamic>;
        expect(toolMap, contains('name'));
        expect(toolMap, contains('description'));
        expect(toolMap['name'], isNotEmpty);
        expect(toolMap['description'], isNotEmpty);
      }
    });
  });
}
