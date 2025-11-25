import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Add http package for the REST call
import 'package:http/http.dart' as http;
import 'package:lumiai/core/constants/gemini_live_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

part 'gemini_live_client.g.dart';

@Riverpod(keepAlive: true)
GeminiLiveClient geminiLiveClient(Ref ref) {
  final client = GeminiLiveClient();
  ref.onDispose(() => client.dispose());
  return client;
}

class GeminiLiveClient {
  WebSocketChannel? _channel;
  final _textController = StreamController<String>.broadcast();
  final _turnCompleteController = StreamController<bool>.broadcast();

  static const _baseUrl = GeminiLiveParams.webSocketEndpoint;
  static const _modelName = GeminiLiveParams.nativeAudioModel;

  Stream<String> get textStream => _textController.stream;
  Stream<bool> get turnCompleteStream => _turnCompleteController.stream;
  bool get isConnected => _channel != null;

  Future<void> connect() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) throw Exception("Missing GEMINI_API_KEY");

    disconnect();

    print("🔌 Connecting to Gemini Live...");

    // ---------------------------------------------------------
    // 🔍 DEBUG: LIST AVAILABLE MODELS (REST API CALL)
    // ---------------------------------------------------------
    /*
    try {
      print("🔎 Querying API for supported models...");
      final listUri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
      );
      final response = await http.get(listUri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['models'] as List;
        print(data);

        print("\n=== 📋 MODELS SUPPORTING LIVE API (BidiGenerateContent) ===");
        bool foundCurrent = false;

        for (var m in models) {
          final methods = List<String>.from(
            m['supportedGenerationMethods'] ?? [],
          );
          // Filter for models that specifically support the Realtime/WebSocket protocol
          if (methods.contains('BidiGenerateContent')) {
            print("✅ ${m['name']}");
            if (m['name'] == _modelName) foundCurrent = true;
          }
        }

        if (!foundCurrent) {
          print(
            "\n⚠️ WARNING: Your configured model '$_modelName' was NOT found in the supported list above.",
          );
          print(
            "   Please update GeminiLiveParams.nativeTextModel to one of the models listed above.\n",
          );
        } else {
          print("=== End of List ===\n");
        }
      } else {
        print(
          "❌ Failed to list models: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("❌ Error checking models: $e");
    }*/
    // ---------------------------------------------------------
    // END DEBUG
    // ---------------------------------------------------------

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
          if (_channel?.closeCode != null) {
            print("   Code: ${_channel?.closeCode}");
            print("   Reason: ${_channel?.closeReason}");
          }
          disconnect();
        },
      );

      final setupMsg = {
        "setup": {
          "model": _modelName,
          "generationConfig": {
            "responseModalities": ["TEXT"],
            "speechConfig": {
              "voiceConfig": {
                "prebuiltVoiceConfig": {"voiceName": "Aoede"},
              },
            },
          },
        },
      };

      print("📤 Sending Setup with model: $_modelName");
      _sendJson(setupMsg);
    } catch (e) {
      print("💥 Connection Failed (Handshake Error): $e");
      disconnect();
      rethrow;
    }
  }

  void sendText(String text) {
    if (_channel == null) {
      print("⚠️ Cannot send: Disconnected");
      return;
    }

    _sendJson({
      "clientContent": {
        "turns": [
          {
            "role": "user",
            "parts": [
              {"text": text},
            ],
          },
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
        print("✅ Setup Complete - Ready for interaction");
      }

      if (msg.containsKey('serverContent')) {
        final content = msg['serverContent'];

        if (content.containsKey('modelTurn')) {
          final parts = content['modelTurn']['parts'] as List;
          for (var part in parts) {
            if (part is Map && part.containsKey('text')) {
              _textController.add(part['text']);
            }
          }
        }

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
      _channel!.sink.close(status.normalClosure);
      _channel = null;
    }
  }

  void dispose() {
    disconnect();
    _textController.close();
    _turnCompleteController.close();
  }
}
