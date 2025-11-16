import 'dart:async';
import 'dart:convert'; // For base64Encode
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_live/gemini_live.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_api.g.dart'; // Generated file for Riverpod

/// Enum to define the desired response modality from the model.
enum ResponseMode { text, audio }

@Riverpod(keepAlive: true)
GeminiApiClient geminiApiClient(GeminiApiClientRef ref) {
  final client = GeminiApiClient();
  ref.onDispose(() {
    client.dispose();
  });
  return client;
}

@Riverpod(keepAlive: true)
Stream<LiveServerMessage> geminiLiveMessages(GeminiLiveMessagesRef ref) {
  final client = ref.watch(geminiApiClientProvider);
  return client.messageStream;
}

class GeminiApiClient {
  late final GoogleGenAI _genAI;
  LiveSession? _session;
  final _messageController = StreamController<LiveServerMessage>.broadcast();
  ResponseMode _responseMode = ResponseMode.text; // Default response mode

  Stream<LiveServerMessage> get messageStream => _messageController.stream;

  GeminiApiClient() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    _genAI = GoogleGenAI(apiKey: apiKey);
  }

  Future<void> connect({ResponseMode mode = ResponseMode.text}) async {
    if (_session != null) {
      await _session?.close();
      _session = null;
    }

    _responseMode = mode; // Update the response mode

    try {
      _session = await _genAI.live.connect(
        LiveConnectParameters(
          model: 'gemini-2.0-flash-live-001',
          config: GenerationConfig(
            responseModalities: _responseMode == ResponseMode.audio
                ? [Modality.AUDIO]
                : [Modality.TEXT],
          ),
          systemInstruction: Content(
            parts: [
              Part(
                text: "You are a helpful AI assistant. "
                    "Your goal is to provide comprehensive, detailed, and well-structured answers. Always explain the background, key concepts, and provide illustrative examples. Do not give short or brief answers."
                    "**You must respond in the same language that the user uses for their question.** For example, if the user asks a question in Korean, you must reply in Korean. "
                    "If they ask in Japanese, reply in Japanese.",
              ),
            ],
          ),
          callbacks: LiveCallbacks(
            onOpen: () => print('✅ Connection opened'),
            onMessage: (LiveServerMessage message) {
              _messageController.add(message); // Add message to stream
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

  Future<void> sendImageAndText(Uint8List imageBytes, String text) async {
    if (_session == null) {
      throw Exception('GeminiLive session not connected. Call connect() first.');
    }

    final List<Part> parts = [];
    if (text.isNotEmpty) {
      parts.add(Part(text: text));
    }
    parts.add(
      Part(
        inlineData: Blob(
          mimeType: 'image/jpeg', // Assuming JPEG for images
          data: base64Encode(imageBytes),
        ),
      ),
    );

    _session!.sendMessage(
      LiveClientMessage(
        clientContent: LiveClientContent(
          turns: [
            Content(role: "user", parts: parts),
          ],
          turnComplete: true,
        ),
      ),
    );
  }

  Future<void> sendVoiceMessage(List<int> audioBytes) async {
    if (_session == null) {
      throw Exception('GeminiLive session not connected. Call connect() first.');
    }

    _session!.sendMessage(
      LiveClientMessage(
        clientContent: LiveClientContent(
          turns: [
            Content(
              role: "user",
              parts: [
                Part(
                  inlineData: Blob(
                    mimeType: 'audio/m4a', // Assuming m4a for recorded audio
                    data: base64Encode(Uint8List.fromList(audioBytes)),
                  ),
                ),
              ],
            ),
          ],
          turnComplete: true,
        ),
      ),
    );
  }

  void dispose() {
    _session?.close();
    _messageController.close();
  }
}
