import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
          } catch (e, stackTrace) {
            print("🚨 Parsing Error: $e");
            print(
              "📋 Raw data received: ${data.toString().substring(0, data.toString().length > 500 ? 500 : data.toString().length)}",
            );
            print("Stack trace: $stackTrace");
          }
        },
        onError: (e, stackTrace) {
          print("🚨 WebSocket Stream Error: $e");
          print("Stack trace: $stackTrace");
          disconnect();
        },
        onDone: () {
          print("🛑 WebSocket Connection Closed");
          // Try to get close code and reason if available
          try {
            final closeCode = _channel?.closeCode;
            final closeReason = _channel?.closeReason;
            if (closeCode != null) {
              print("📊 Close Code: $closeCode");
              print("📝 Close Reason: ${closeReason ?? 'No reason provided'}");
              print(
                "🔍 Close Code Meaning: ${_getCloseCodeMeaning(closeCode)}",
              );
            } else {
              print("⚠️ No close code available");
            }
          } catch (e) {
            print("⚠️ Could not retrieve close information: $e");
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
          "systemInstruction": AppPrompts.systemInstruction,
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
  }) {
    if (_channel == null) {
      print("⚠️ Cannot send: Disconnected");
      return;
    }

    // For real-time audio streaming, use realtimeInput with dedicated audio field
    // Using modern format (not deprecated mediaChunks)
    if (isRealtime && audioBytes != null) {
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

    final List<Map<String, dynamic>> parts = [];

    // 1. Add Text
    if (text != null && text.isNotEmpty) {
      parts.add({"text": text});
    }

    // 2. Add Image (sent as inlineData in clientContent, not realtimeInput)
    // Images should be sent via clientContent, not realtimeInput video stream
    if (imageBytes != null) {
      print("📸 Sending image: ${imageBytes.length} bytes (image/jpeg)");
      parts.add({
        "inlineData": {
          "mimeType": "image/jpeg",
          "data": base64Encode(imageBytes),
        },
      });
    }

    // 3. Add Video (for actual video files)
    if (videoBytes != null) {
      parts.add({
        "inlineData": {
          "mimeType": videoMimeType,
          "data": base64Encode(videoBytes),
        },
      });
      print(
        "📹 Sending video data: ${videoBytes.length} bytes, type: $videoMimeType",
      );
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

    if (parts.isEmpty) {
      print("⚠️ Warning: Attempted to send empty payload.");
      return;
    }

    // Send Client Content (text, images, video, or audio)
    final payload = {
      "clientContent": {
        "turns": [
          {"role": "user", "parts": parts},
        ],
        "turnComplete": true,
      },
    };

    // Debug logging
    print("📤 Sending clientContent with ${parts.length} parts:");
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.containsKey('text')) {
        print("  Part $i: Text (${part['text'].toString().length} chars)");
      } else if (part.containsKey('inlineData')) {
        final mimeType = part['inlineData']['mimeType'];
        final dataLength = part['inlineData']['data'].toString().length;
        print("  Part $i: InlineData ($mimeType, $dataLength chars base64)");
      }
    }

    _sendJson(payload);
  }

  void _sendJson(Map<String, dynamic> data) {
    try {
      if (_channel == null) return;
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      print("🚨 Send Error: $e");
    }
  }

  String _getCloseCodeMeaning(int code) {
    switch (code) {
      case 1000:
        return "Normal Closure";
      case 1001:
        return "Going Away - Server is shutting down or browser navigating away";
      case 1002:
        return "Protocol Error";
      case 1003:
        return "Unsupported Data";
      case 1006:
        return "Abnormal Closure - No close frame received";
      case 1007:
        return "Invalid Frame Payload Data";
      case 1008:
        return "Policy Violation";
      case 1009:
        return "Message Too Big";
      case 1010:
        return "Mandatory Extension";
      case 1011:
        return "Internal Server Error";
      case 1012:
        return "Service Restart";
      case 1013:
        return "Try Again Later";
      case 1014:
        return "Bad Gateway";
      case 1015:
        return "TLS Handshake Failure";
      default:
        if (code >= 3000 && code <= 3999) {
          return "Application-specific error (Registered)";
        } else if (code >= 4000 && code <= 4999) {
          return "Application-specific error (Private use) - Likely API-specific error";
        }
        return "Unknown close code";
    }
  }

  void _parseServerMessage(Map<String, dynamic> msg) {
    try {
      if (msg.containsKey('setupComplete')) {
        print("✅ Setup Complete - Ready");
      }

      if (msg.containsKey('serverContent')) {
        final content = msg['serverContent'];
        print(
          "📥 Received serverContent with fields: ${content.keys.join(', ')}",
        );

        // Handle audio transcription (for AUDIO response modality)
        // This gives us text from the audio output for local TTS
        if (content.containsKey('outputTranscription')) {
          final transcription = content['outputTranscription'];
          if (transcription is Map && transcription.containsKey('text')) {
            final transcribedText = transcription['text'] as String;
            print("📝 Transcription: $transcribedText");
            // Send transcribed text to text stream for local TTS
            _textController.add(transcribedText);
          }
        }

        // Extract Text (for TEXT response modality)
        if (content.containsKey('modelTurn')) {
          final parts = content['modelTurn']['parts'] as List;
          print("📦 Model turn has ${parts.length} parts");
          for (var part in parts) {
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
                print("🔊 Received audio chunk: ${audioData.length} bytes");
              }
            }
          }
        }

        // Check for Generation Complete (marks end of transcription)
        // generationComplete indicates the model is done generating output
        // turnComplete comes later after audio playback would finish
        if (content.containsKey('generationComplete') &&
            content['generationComplete'] == true) {
          print("✅ Generation complete");
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
