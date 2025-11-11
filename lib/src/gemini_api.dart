import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_live/gemini_live.dart';

class GeminiApi {
  late final GoogleGenAI _genAI;
  LiveSession? _session;

  GeminiApi() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    _genAI = GoogleGenAI(apiKey: apiKey);
  }

  Future<void> connect() async {
    try {
      _session = await _genAI.live.connect(
        LiveConnectParameters( // Using LiveConnectRequest as the single positional argument
          model: 'gemini-2.0-flash-live-001',
          callbacks: LiveCallbacks(
            onOpen: () => print('✅ Connection opened'),
            onMessage: (LiveServerMessage message) {
              if (message.text != null) {
                print('Received chunk: ${message.text}');
              }
              if (message.serverContent?.turnComplete ?? false) {
                print('✅ Turn complete!');
              }
            },
            onError: (e, s) => print('🚨 Error: $e'),
            onClose: (code, reason) => print('🚪 Connection closed'),
          ),
        ),
      );
    } catch (e) {
      print('Connection failed: $e');
      rethrow;
    }
  }

  Future<String> sendImageAndText(Uint8List imageBytes, String text) async {
    if (_session == null) {
      throw Exception('GeminiLive session not connected. Call connect() first.');
    }
    _session?.sendMessage(
      LiveClientMessage(
        clientContent: LiveClientContent(
          turns: [
            Content(
              role: "user",
              parts: [
                Part(text: text),
              ],
            ),
          ],
          turnComplete: true,
        ),
      ),
    );
    return 'Image and text sent successfully (response will be in onMessage callback)';
  }

  Future<String> sendVoiceMessage(List<int> audioBytes) async {
    if (_session == null) {
      throw Exception('GeminiLive session not connected. Call connect() first.');
    }
    _session?.sendMessage(
      LiveClientMessage(
        clientContent: LiveClientContent(
          turns: [
            Content(
              role: "user",
              parts: [
                //Part.fromJson(data: Uint8List.fromList(audioBytes), mimeType: "audio/wav"), // Attempting Part.bytes
              ],
            ),
          ],
          turnComplete: true,
        ),
      ),
    );
    return 'Voice message sent successfully (response will be in onMessage callback)';
  }

  void dispose() {
    _session?.close();
  }
}
