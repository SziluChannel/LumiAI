import 'dart:async';
import 'dart:convert'; // For base64Encode
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_live/gemini_live.dart';
import 'package:lumiai/core/constants/app_prompts.dart';
import 'package:lumiai/core/constants/gemini_live_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_api.g.dart'; // Generated file for Riverpod

/// Enum to define the desired response modality from the model.
enum ResponseMode { text, audio }

@Riverpod(keepAlive: true)
GeminiApiClient geminiApiClient(Ref ref) {
  final client = GeminiApiClient();
  ref.onDispose(() {
    client.dispose();
  });
  return client;
}

@Riverpod(keepAlive: true)
Stream<LiveServerMessage> geminiLiveMessages(Ref ref) {
  final client = ref.watch(geminiApiClientProvider);
  return client.messageStream;
}

class GeminiApiClient {
  late final GoogleGenAI _genAI;
  LiveSession? _session;
  final _messageController = StreamController<LiveServerMessage>.broadcast();
  ResponseMode _responseMode = ResponseMode.text; // Default response mode

  Stream<LiveServerMessage> get messageStream => _messageController.stream;
  bool get isConnected => _session != null;

  GeminiApiClient() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    _genAI = GoogleGenAI(apiKey: apiKey);
  }

  /// Establishes the WebSocket connection.
  Future<void> connect({ResponseMode mode = ResponseMode.text}) async {
    // If already connected, close the previous session (allows switching modes)
    if (_session != null) {
      await disconnect();
    }

    _responseMode = mode;

    try {
      _session = await _genAI.live.connect(
        LiveConnectParameters(
          model: GeminiLiveModels.nativeText,
          config: GenerationConfig(responseModalities: [Modality.AUDIO]),
          systemInstruction: Content(
            parts: [Part(text: AppPrompts.systemInstruction)],
          ),
          callbacks: LiveCallbacks(
            onOpen: () => print('✅ Connection opened'),
            onMessage: (LiveServerMessage message) {
              _messageController.add(message);
            },
            onError: (e, s) => print('🚨 Error: $e, \n $s'),
            onClose: (code, reason) =>
                print('🚪 Connection closed code: $code, reason: $reason'),
          ),
        ),
      );
    } catch (e) {
      print('Connection failed: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _session?.close();
    _session = null;
  }

  /// Centralized method to send any combination of Text, Image, or Audio.
  ///
  /// Throws an exception if the session is not connected.
  Future<void> send({
    String? text,
    Uint8List? imageBytes,
    Uint8List? audioBytes,
    String audioMimeType = 'audio/m4a', // Default to mobile format
  }) async {
    if (_session == null) {
      throw Exception(
        'GeminiLive session not connected. Call connect() first.',
      );
    }

    final List<Part> parts = [];

    // 1. Add Text
    if (text != null && text.isNotEmpty) {
      parts.add(Part(text: text));
    }

    // 2. Add Image (JPEG assumed)
    if (imageBytes != null) {
      parts.add(
        Part(
          inlineData: Blob(
            mimeType: 'image/jpeg',
            data: base64Encode(imageBytes),
          ),
        ),
      );
    }

    // 3. Add Audio (m4a assumed)
    if (audioBytes != null) {
      parts.add(
        Part(
          inlineData: Blob(
            mimeType: audioMimeType, // Use the passed variable here
            data: base64Encode(audioBytes),
          ),
        ),
      );
    }

    if (parts.isEmpty) {
      print("⚠️ Warning: Attempted to send an empty message.");
      return;
    }

    // 4. Send the constructed payload
    _session!.sendMessage(
      LiveClientMessage(
        clientContent: LiveClientContent(
          turns: [Content(role: "user", parts: parts)],
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
