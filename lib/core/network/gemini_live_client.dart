import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lumiai/core/constants/gemini_live_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

part 'gemini_live_client.g.dart';

@Riverpod(keepAlive: true)
class GeminiLiveClient extends _$GeminiLiveClient {
  WebSocketChannel? _channel;
  final _textController = StreamController<String>.broadcast();
  final _turnCompleteController = StreamController<bool>.broadcast();
  final _audioController = StreamController<Uint8List>.broadcast();

  // Configuration
  static const _baseUrl = GeminiLiveParams.webSocketEndpoint;
  static const _modelName = GeminiLiveParams.liveModel;

  // Streams for external controllers
  Stream<String> get textStream => _textController.stream;
  Stream<bool> get turnCompleteStream => _turnCompleteController.stream;
  Stream<Uint8List> get audioStream => _audioController.stream;
  bool get isConnected => _channel != null;

  @override
  GeminiLiveClient build() {
    // Automatically cleanup when the provider is destroyed
    ref.onDispose(() {
      dispose();
    });
    return this;
  }

  /// Connects to the Gemini Live WebSocket
  Future<void> connect() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) throw Exception("Missing GEMINI_API_KEY");

    // Close existing connection to ensure a clean state
    disconnect();

    print("🔌 Connecting to Gemini Live...");
    final uri = Uri.parse('$_baseUrl?key=$apiKey');

    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      print("✅ WebSocket Connection Established!");

      _channel!.stream.listen(
        (data) {
          try {
            final decoded = (data is String)
                ? jsonDecode(data)
                : jsonDecode(utf8.decode(data));
            _parseServerMessage(decoded);
          } catch (e) {
            print("🚨 Parsing Error: $e");
          }
        },
        onError: (e) {
          print("🚨 WebSocket Stream Error: $e");
          disconnect();
        },
        onDone: () {
          print("🛑 WebSocket Closed by Server");
          disconnect();
        },
      );

      // Send Handshake (Setup)
      final setupMsg = {
        "setup": {
          "model": _modelName,
          "generationConfig": {
            "responseModalities": ["TEXT"], // Receive text only, use local TTS
            "speechConfig": {
              "voiceConfig": {
                "prebuiltVoiceConfig": {"voiceName": "Puck"},
              },
            },
          },
        },
      };

      print("📤 Sending Setup...");
      _sendJson(setupMsg);
    } catch (e) {
      print("💥 Connection Failed: $e");
      disconnect();
      rethrow;
    }
  }

  /// Unified method to send Text, Images, and Audio in a single turn.
  ///
  /// [text] - Optional text prompt.
  /// [imageBytes] - Optional JPEG image bytes.
  /// [audioBytes] - Optional Audio bytes (defaults to 16k PCM if mimeType not provided).
  /// [audioMimeType] - The mime type of the audio (e.g., 'audio/wav', 'audio/pcm;rate=16000').
  /// [isRealtime] - If true, sends audio as realtime input chunks for streaming.
  void send({
    String? text,
    Uint8List? imageBytes,
    Uint8List? audioBytes,
    String audioMimeType = 'audio/pcm;rate=16000',
    bool isRealtime = false,
  }) {
    if (_channel == null) {
      print("⚠️ Cannot send: Disconnected");
      return;
    }

    // For real-time audio streaming, use realtimeInput format
    if (isRealtime && audioBytes != null) {
      _sendJson({
        "realtimeInput": {
          "mediaChunks": [
            {
              "mimeType": audioMimeType,
              "data": base64Encode(audioBytes),
            },
          ],
        },
      });
      return;
    }

    final List<Map<String, dynamic>> parts = [];

    // 1. Add Text
    if (text != null && text.isNotEmpty) {
      parts.add({"text": text});
    }

    // 2. Add Image
    if (imageBytes != null) {
      parts.add({
        "inlineData": {
          "mimeType": "image/jpeg",
          "data": base64Encode(imageBytes),
        },
      });
    }

    // 3. Add Audio (non-realtime)
    if (audioBytes != null) {
      parts.add({
        "inlineData": {
          "mimeType": audioMimeType,
          "data": base64Encode(audioBytes),
        },
      });
    }

    if (parts.isEmpty) {
      print("⚠️ Warning: Attempted to send empty payload.");
      return;
    }

    // Send Client Content
    _sendJson({
      "clientContent": {
        "turns": [
          {"role": "user", "parts": parts},
        ],
        "turnComplete": true,
      },
    });
  }

  void _sendJson(Map<String, dynamic> data) {
    try {
      if (_channel == null) return;
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      print("🚨 Send Error: $e");
    }
  }

  void _parseServerMessage(Map<String, dynamic> msg) {
    try {
      if (msg.containsKey('setupComplete')) {
        print("✅ Setup Complete - Ready");
      }

      if (msg.containsKey('serverContent')) {
        final content = msg['serverContent'];

        // Extract Text
        if (content.containsKey('modelTurn')) {
          final parts = content['modelTurn']['parts'] as List;
          for (var part in parts) {
            if (part is Map && part.containsKey('text')) {
              _textController.add(part['text']);
            }
            // Handle audio responses
            if (part is Map && part.containsKey('inlineData')) {
              final inlineData = part['inlineData'];
              if (inlineData['mimeType']?.toString().contains('audio') == true) {
                final audioData = base64Decode(inlineData['data']);
                _audioController.add(audioData);
                print("🔊 Received audio chunk: ${audioData.length} bytes");
              }
            }
          }
        }

        // Check for End of Turn
        if (content.containsKey('turnComplete') &&
            content['turnComplete'] == true) {
          _turnCompleteController.add(true);
        }
      }
    } catch (e) {
      print("Error parsing JSON body: $e");
    }
  }

  void disconnect() {
    if (_channel != null) {
      try {
        _channel!.sink.close(status.normalClosure);
      } catch (e) {
        // Ignore errors during closing
      }
      _channel = null;
    }
  }

  void dispose() {
    disconnect();
    if (!_textController.isClosed) _textController.close();
    if (!_turnCompleteController.isClosed) _turnCompleteController.close();
    if (!_audioController.isClosed) _audioController.close();
  }
}
