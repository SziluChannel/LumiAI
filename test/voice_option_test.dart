import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/core/services/tts_service.dart';

void main() {
  // ==========================================================================
  // VoiceOption Tests
  // ==========================================================================
  group('VoiceOption', () {
    test('constructor sets name correctly', () {
      const voice = VoiceOption(name: 'Test Voice', identifier: 'test-id');

      expect(voice.name, 'Test Voice');
    });

    test('constructor sets identifier correctly', () {
      const voice = VoiceOption(name: 'Test Voice', identifier: 'test-id');

      expect(voice.identifier, 'test-id');
    });

    test('can create with US English voice identifiers', () {
      const voice = VoiceOption(
        name: 'Woman 1 (US)',
        identifier: 'en-US-Wavenet-F',
      );

      expect(voice.name, 'Woman 1 (US)');
      expect(voice.identifier, 'en-US-Wavenet-F');
    });

    test('can create with different voice configurations', () {
      const voices = [
        VoiceOption(name: 'Voice A', identifier: 'en-US-Wavenet-A'),
        VoiceOption(name: 'Voice B', identifier: 'en-US-Wavenet-B'),
        VoiceOption(name: 'Voice C', identifier: 'en-US-Wavenet-C'),
      ];

      expect(voices.length, 3);
      expect(voices[0].name, 'Voice A');
      expect(voices[1].name, 'Voice B');
      expect(voices[2].name, 'Voice C');
    });

    test('name and identifier can be empty strings', () {
      const voice = VoiceOption(name: '', identifier: '');

      expect(voice.name, '');
      expect(voice.identifier, '');
    });

    test('name and identifier can contain special characters', () {
      const voice = VoiceOption(
        name: 'Voice (Special) - Test',
        identifier: 'custom/voice_id-123',
      );

      expect(voice.name, 'Voice (Special) - Test');
      expect(voice.identifier, 'custom/voice_id-123');
    });
  });
}
