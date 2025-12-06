import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumiai/features/daily_briefing/daily_briefing_service.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'daily_briefing_service_test.mocks.dart';

// Create Mocks
@GenerateMocks([http.Client, TtsService])
void main() {
  late MockClient mockHttpClient;
  late MockTtsService mockTtsService;
  late DailyBriefingService service;

  setUp(() {
    mockHttpClient = MockClient();
    mockTtsService = MockTtsService();

    // Mock Geolocator Platform
    GeolocatorPlatform.instance = MockGeolocatorPlatform();

    // No need for container overrides for direct class testing
    service = DailyBriefingService(
      Future.value(mockTtsService),
      httpClient: mockHttpClient,
    );
  });


  group('DailyBriefingService Tests', () {
    test('speakBriefing calls TTS with weather and quote', () async {
      // Arrange
      // 1. Mock Weather Response
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          '{"current": {"temperature_2m": 25.0, "weather_code": 0}}',
          200,
        ),
      );

      // 2. Mock TTS Speak
      when(mockTtsService.speak(any)).thenAnswer((_) async {});

      // Act
      await service.speakBriefing();

      // Assert
      verify(mockHttpClient.get(any)).called(1);
      
      // Verify TTS was called with a string containing expected parts
      final captured = verify(mockTtsService.speak(captureAny)).captured;
      final spokenText = captured.first as String;

      expect(spokenText, contains("Good")); // Greeting
      expect(spokenText, contains("25 degrees")); // Weather
      expect(spokenText, contains("clear sky")); // Weather description for code 0
      expect(spokenText, contains("daily quote"));
    });

    test('Handles weather API failure gracefully', () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 500),
      );
      when(mockTtsService.speak(any)).thenAnswer((_) async {});

      // Act
      await service.speakBriefing();

      // Assert
      final captured = verify(mockTtsService.speak(captureAny)).captured;
      final spokenText = captured.first as String;

      expect(spokenText, contains("couldn't fetch the weather"));
    });
  });
}

// Mock Geolocator Platform to avoid MissingPluginException
class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {
  
  @override
  Future<LocationPermission> checkPermission() async => LocationPermission.always;

  @override
  Future<LocationPermission> requestPermission() async => LocationPermission.always;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    return Position(
      latitude: 52.52,
      longitude: 13.41,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0, 
      altitudeAccuracy: 0.0, 
      headingAccuracy: 0.0,
    );
  }
}
