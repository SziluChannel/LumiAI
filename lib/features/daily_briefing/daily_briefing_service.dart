import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// Service Provider
// Service Provider
// Service Provider
final dailyBriefingServiceProvider = Provider<DailyBriefingService>((ref) {
  return DailyBriefingService(ref.read(ttsServiceProvider.future));
});

class DailyBriefingService {
  final Future<TtsService> _ttsServiceFuture;
  final http.Client _httpClient;

  DailyBriefingService(this._ttsServiceFuture, {http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  final List<String> _quotes = [
    "The only way to do great work is to love what you do.",
    "Believe you can and you're halfway there.",
    "Act as if what you do makes a difference. It does.",
    "Success is not final, failure is not fatal: it is the courage to continue that counts.",
    "Keep your face always toward the sunshine—and shadows will fall behind you.",
    "It is never too late to be what you might have been.",
    "You do not find the happy life. You make it.",
  ];

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 18) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  Future<String> _fetchRealWeather() async {
    try {
      // 1. Check/Request Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return "Weather information is unavailable because location permission was denied.";
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return "Weather information is unavailable because location permission is permanently denied.";
      }

      // 2. Get Position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // 3. Call Open-Meteo API
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m,weather_code',
      );
      
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        final double temp = current['temperature_2m'];
        final int code = current['weather_code'];
        
        final condition = _getWeatherDescription(code);
        
        return "It's currently ${temp.round()} degrees and $condition.";
      } else {
        return "I couldn't fetch the weather data at the moment.";
      }
    } catch (e) {
      return "I couldn't check the weather due to an error. $e";
    }
  }

  String _getWeatherDescription(int code) {
    // WMO Weather interpretation codes (WW)
    switch (code) {
      case 0: return "clear sky";
      case 1: return "mainly clear";
      case 2: return "partly cloudy";
      case 3: return "overcast";
      case 45: return "foggy";
      case 48: return "depositing rime fog";
      case 51: return "light drizzle";
      case 53: return "moderate drizzle";
      case 55: return "dense drizzle";
      case 61: return "slight rain";
      case 63: return "moderate rain";
      case 65: return "heavy rain";
      case 71: return "slight snow fall";
      case 73: return "moderate snow fall";
      case 75: return "heavy snow fall";
      case 77: return "snow grains";
      case 80: return "slight rain showers";
      case 81: return "moderate rain showers";
      case 82: return "violent rain showers";
      case 85: return "slight snow showers";
      case 86: return "heavy snow showers";
      case 95: return "thunderstorm";
      case 96: return "thunderstorm with slight hail";
      case 99: return "thunderstorm with heavy hail";
      default: return "weather is uncertain";
    }
  }

  Future<void> speakBriefing() async {
    try {
      // WaitFor TTS Service to be ready
      final ttsService = await _ttsServiceFuture;

      final now = DateTime.now();
      final timeString = DateFormat('h:mm a').format(now);
      
      final greeting = _getTimeGreeting();
      
      // Fetch Real Weather
      final weather = await _fetchRealWeather();
      
      final quote = _quotes[Random().nextInt(_quotes.length)];

      final message = "$greeting! It is $timeString. $weather Here is your daily quote: $quote";

      await ttsService.speak(message);
    } catch (e) {
      // Log error if TTS fails to init
      print("Error speaking briefing: $e");
    }
  }
}
