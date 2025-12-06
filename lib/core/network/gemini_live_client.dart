import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lumiai/core/constants/app_prompts.dart';
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
  final _toolCallController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  // Configuration
  static const _baseUrl = GeminiLiveParams.webSocketEndpoint;
  static const _modelName = GeminiLiveParams.liveModel;

  // Streams for external controllers
  Stream<String> get textStream => _textController.stream;
  Stream<bool> get turnCompleteStream => _turnCompleteController.stream;
  Stream<Uint8List> get audioStream => _audioController.stream;
  Stream<List<Map<String, dynamic>>> get toolCallStream =>
      _toolCallController.stream;
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
  Future<void> connect({List<Map<String, dynamic>>? tools}) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) throw Exception("Missing GEMINI_API_KEY");

    // Close existing connection to ensure a clean state
    disconnect();

    debugPrint("🔌 Connecting to Gemini Live...");
    final uri = Uri.parse('$_baseUrl?key=$apiKey');

    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      debugPrint("✅ WebSocket Connection Established!");

      _channel!.stream.listen(
        (data) {
          try {
            final decoded = (data is String)
                ? jsonDecode(data)
                : jsonDecode(utf8.decode(data));
            _parseServerMessage(decoded);
          } catch (e, stackTrace) {
            debugPrint("🚨 Parsing Error: $e\n$stackTrace");
          }
        },
        onError: (e) {
          debugPrint("🚨 WebSocket Stream Error: $e");
          disconnect();
        },
        onDone: () {
          debugPrint("🛑 WebSocket Connection Closed");
          // Try to get close code and reason if available
          try {
            final closeCode = _channel?.closeCode;
            final closeReason = _channel?.closeReason;
            if (closeCode != null) {
              debugPrint("📊 Close Code: $closeCode");
              debugPrint(
                "📝 Close Reason: ${closeReason ?? 'No reason provided'}",
              );
            } else {
              debugPrint("⚠️ No close code available");
            }
          } catch (e) {
            debugPrint("⚠️ Could not retrieve close information: $e");
          }
          disconnect();
        },
      );

      // Send Handshake (Setup)
      final setupMsg = {
        "setup": {
          "model": _modelName,
          // Enable output audio transcription to get text from audio responses
          "outputAudioTranscription": {},
          "generationConfig": {
            // Using AUDIO response modality with native audio model
            // We'll get transcriptions of the audio for local TTS
            "responseModalities": ["AUDIO"],
          },
          "systemInstruction": {
            "parts": [
              {"text": AppPrompts.systemInstruction},
            ],
          },
          if (tools != null) "tools": tools,
        },
      };

      _sendJson(setupMsg);
    } catch (e) {
      debugPrint("💥 Connection Failed: $e");
      disconnect();
      rethrow;
    }
  }

  /// Unified method to send Text, Images (as video frames), Video, and Audio.
  ///
  /// [text] - Optional text prompt.
  /// [imageBytes] - Optional JPEG image bytes (sent as video frame with image/jpeg MIME type).
  /// [videoBytes] - Optional video bytes.
  /// [videoMimeType] - MIME type for video (e.g., 'video/mp4', 'video/webm').
  /// [audioBytes] - Optional Audio bytes (defaults to 16k PCM if mimeType not provided).
  /// [audioMimeType] - The mime type of the audio (e.g., 'audio/wav', 'audio/pcm;rate=16000').
  /// [isRealtime] - If true, sends audio as realtime input chunks for streaming.
  void send({
    String? text,
    Uint8List? imageBytes,
    Uint8List? videoBytes,
    String videoMimeType = 'video/mp4',
    Uint8List? audioBytes,
    String audioMimeType = 'audio/pcm;rate=16000',
    bool isRealtime = false,
    bool turnComplete = false, // Default to true for normal interactions
  }) {
    if (_channel == null) {
      debugPrint("⚠️ Cannot send: Disconnected");
      return;
    }

    // For real-time streaming, use realtimeInput with dedicated fields
    // Using modern format (not deprecated mediaChunks)
    if (isRealtime) {
      if (audioBytes != null) {
        _sendJson({
          "realtimeInput": {
            "audio": {
              "mimeType": audioMimeType,
              "data": base64Encode(audioBytes),
            },
          },
        });
        return;
      }

      if (imageBytes != null) {
        // Use 'video' field for realtime video input (not deprecated mediaChunks)
        debugPrint("📸 Sending image frame");
        _sendJson({
          "realtimeInput": {
            "video": {
              "mimeType": "image/jpeg",
              "data": base64Encode(imageBytes),
            },
          },
        });
        return;
      }

      // For text, fall through to clientContent below
      // This ensures proper turn management for prompts that need responses
    }

    final List<Map<String, dynamic>> parts = [];

    // ... (text/image/video/audio parts adding remains same) ...
    // 1. Add Text
    if (text != null && text.isNotEmpty) {
      debugPrint("📝 Sending text: $text");
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

    // 3. Add Video
    if (videoBytes != null) {
      parts.add({
        "inlineData": {
          "mimeType": videoMimeType,
          "data": base64Encode(videoBytes),
        },
      });
    }

    // 4. Add Audio (non-realtime)
    if (audioBytes != null) {
      parts.add({
        "inlineData": {
          "mimeType": audioMimeType,
          "data": base64Encode(audioBytes),
        },
      });
    }

    if (parts.isEmpty) return;

    // Send Client Content
    final payload = {
      "clientContent": {
        "turns": [
          {"role": "user", "parts": parts},
        ],
        "turnComplete": turnComplete,
      },
    };

    _sendJson(payload);
  }

  void sendToolResponse(List<Map<String, dynamic>> functionResponses) {
    _sendJson({
      "toolResponse": {"functionResponses": functionResponses},
    });
  }

  void _sendJson(Map<String, dynamic> data) {
    try {
      if (_channel == null) return;
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      debugPrint("🚨 Send Error: $e");
    }
  }

  void _parseServerMessage(Map<String, dynamic> msg) {
    try {
      if (msg.containsKey('setupComplete')) {
        debugPrint("✅ Setup Complete - Ready");
      }

      if (msg.containsKey('toolCall')) {
        final toolCall = msg['toolCall'];
        if (toolCall.containsKey('functionCalls')) {
          final functionCalls = List<Map<String, dynamic>>.from(
            toolCall['functionCalls'],
          );
          debugPrint("🛠️ Received Tool Call: $functionCalls");
          _toolCallController.add(functionCalls);
        }
      }

      if (msg.containsKey('serverContent')) {
        final content = msg['serverContent'];

        // Handle audio transcription (for AUDIO response modality)
        // This gives us text from the audio output for local TTS
        if (content.containsKey('outputTranscription')) {
          final transcription = content['outputTranscription'];
          if (transcription is Map && transcription.containsKey('text')) {
            final transcribedText = transcription['text'] as String;
            _textController.add(transcribedText);
          }
        }

        // Extract Text (for TEXT response modality)
        // Filter out 'thought' parts - only process actual text responses
        if (content.containsKey('modelTurn')) {
          final parts = content['modelTurn']['parts'] as List;
          for (var part in parts) {
            // Skip thought/thinking parts - these are internal reasoning
            if (part is Map && part.containsKey('thought')) {
              debugPrint("🧠 Skipping thought: ${part['thought']}");
              continue;
            }
            if (part is Map && part.containsKey('text')) {
              _textController.add(part['text']);
            }
            // Handle audio responses (if needed for playback)
            if (part is Map && part.containsKey('inlineData')) {
              final inlineData = part['inlineData'];
              if (inlineData['mimeType']?.toString().contains('audio') ==
                  true) {
                final audioData = base64Decode(inlineData['data']);
                _audioController.add(audioData);
              }
            }
          }
        }

        // Check for Generation Complete (marks end of transcription)
        // generationComplete indicates the model is done generating output
        // turnComplete comes later after audio playback would finish
        if (content.containsKey('generationComplete') &&
            content['generationComplete'] == true) {
          _turnCompleteController.add(true);
        }
      }
    } catch (e) {
      debugPrint("Error parsing JSON body: $e");
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
    if (!_toolCallController.isClosed) _toolCallController.close();
  }
}
