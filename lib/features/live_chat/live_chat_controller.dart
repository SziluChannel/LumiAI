import 'dart:async';
import 'dart:convert'; // For base64Decode
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:gemini_live/gemini_live.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sound_stream/sound_stream.dart'; // <--- NEW IMPORT
import 'package:lumiai/core/network/gemini_api.dart';
import 'package:lumiai/core/services/tts_service.dart';

import 'live_chat_state.dart';

part 'live_chat_controller.g.dart';

@riverpod
class LiveChatController extends _$LiveChatController {
  StreamSubscription? _geminiSubscription;
  StreamSubscription? _amplitudeSubscription;
  StreamSubscription? _audioStreamSubscription;

  late final AudioRecorder _audioRecorder;
  late final PlayerStream _playerStream; // <--- PLAYER FOR INCOMING AUDIO

  final _amplitudeController = StreamController<double>.broadcast();
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  final List<int> _webAudioBuffer = [];

  // We don't need TTS buffer anymore if we play audio directly!
  // But keeping it if you want text fallback.

  Uint8List? _currentImageBytes;

  @override
  LiveChatState build() {
    _audioRecorder = AudioRecorder();
    _playerStream = PlayerStream(); // Initialize Player

    ref.onDispose(() {
      _geminiSubscription?.cancel();
      _amplitudeSubscription?.cancel();
      _audioStreamSubscription?.cancel();
      _amplitudeController.close();
      _audioRecorder.dispose();
      _playerStream.dispose(); // Dispose Player
    });
    return const LiveChatState();
  }

  Future<void> startSession(Uint8List imageBytes) async {
    _currentImageBytes = imageBytes;

    // Initialize Player Stream (24kHz is standard for Gemini Live audio response)
    await _playerStream.initialize(sampleRate: 24000);

    _listenToStream();
    await startRecording();
  }

  Future<void> startRecording() async {
    final tts = ref.read(ttsServiceProvider);

    // Permission Check (Mobile only, Web handles it via browser UI)
    if (!kIsWeb && !await Permission.microphone.request().isGranted) {
      tts.speak("Microphone permission denied.");
      return;
    }

    state = state.copyWith(status: LiveChatStatus.listening);

    try {
      _amplitudeSubscription?.cancel();
      _amplitudeSubscription = _audioRecorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amp) {
            final double normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
            _amplitudeController.add(normalized);
          });

      _webAudioBuffer.clear();

      // --- CONFIGURATION ---
      // 16000Hz is Gemini's preferred Sample Rate
      const int sampleRate = 16000;

      if (kIsWeb) {
        // WEB: Use PCM 16-bit (Raw Audio)
        // This is the only reliable stream format for 'record' on web
        const config = RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels: 1,
        );

        final stream = await _audioRecorder.startStream(config);
        _audioStreamSubscription = stream.listen((data) {
          _webAudioBuffer.addAll(data);
        });
      } else {
        // MOBILE: Use WAV (File based)
        // Mobile can natively save WAV files with headers
        const config = RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: sampleRate,
          numChannels: 1,
        );

        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/live_query.wav';

        await _audioRecorder.start(config, path: filePath);
      }
    } catch (e) {
      print("❌ Start Recording Error: $e");
      state = state.copyWith(
        status: LiveChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> stopRecordingAndSend() async {
    final tts = ref.read(ttsServiceProvider);

    if (!await _audioRecorder.isRecording()) {
      startRecording();
      return;
    }

    try {
      _amplitudeSubscription?.cancel();
      _audioStreamSubscription?.cancel();

      late Uint8List audioBytes;

      // Both platforms will result in a valid WAV payload (header + pcm)
      const String mimeType = 'audio/wav';

      if (kIsWeb) {
        await _audioRecorder.stop();

        if (_webAudioBuffer.isEmpty) {
          print("⚠️ Warning: Audio buffer empty.");
          return;
        }

        // --- WEB FIX: Add WAV Header manually ---
        // Raw PCM (from Web) + Header = Valid WAV File
        final rawPCM = Uint8List.fromList(_webAudioBuffer);
        audioBytes = addWavHeader(rawPCM, sampleRate: 16000);
      } else {
        final String? path = await _audioRecorder.stop();
        if (path == null) return;

        final file = File(path);
        audioBytes = await file.readAsBytes();
      }

      state = state.copyWith(status: LiveChatStatus.processing);
      tts.speak("Thinking...");

      final gemini = ref.read(geminiApiClientProvider);
      if (!gemini.isConnected) await gemini.connect();

      print("📤 Sending ${audioBytes.length} bytes of $mimeType...");

      await gemini.send(
        imageBytes: _currentImageBytes,
        audioBytes: audioBytes,
        audioMimeType: mimeType,
      );
    } catch (e) {
      print("❌ Send Error: $e");
      state = state.copyWith(
        status: LiveChatStatus.error,
        errorMessage: e.toString(),
      );
      tts.speak("Error sending message.");
    }
  }

  void _writeString(ByteData view, int offset, String value) {
    for (int i = 0; i < value.length; i++) {
      view.setUint8(offset + i, value.codeUnitAt(i));
    }
  }

  // --- STREAM HANDLING ---
  void _listenToStream() {
    final gemini = ref.read(geminiApiClientProvider);
    _geminiSubscription?.cancel();

    _geminiSubscription = gemini.messageStream.listen((message) async {
      // 1. Handle Text (Optional: display it, but don't speak it via TTS if playing audio)
      if (message.text != null && message.text!.isNotEmpty) {
        _handleTextChunk(message.text!);
      }

      // 2. Handle Audio (The "serverContent" -> "modelTurn" -> "parts" logic)
      // The gemini_live package usually parses this into `message.inlineData` or similar
      // If 'LiveServerMessage' doesn't expose it directly, we might need to parse the raw map
      // But assuming you have access to the raw structure or a field:

      if (message.serverContent!.modelTurn?.parts != null) {
        final data = message.serverContent!.modelTurn!.parts!;
        // Check if it's audio
        for (Part p in data) {
          if (p.inlineData != null &&
              p.inlineData!.mimeType.startsWith('audio/')) {
            final Uint8List audioBytes = base64Decode(p.inlineData!.data);

            // WRITE TO PLAYER IMMEDIATELY
            await _playerStream.writeChunk(audioBytes);
          }
        }
      }

      // NOTE: If your 'gemini_live' package abstracts this away,
      // you might need to check how it exposes the 'parts'.
      // For example, if 'message' is just a wrapper, check its fields.

      // 3. Turn Complete
      if (message.serverContent?.turnComplete ?? false) {
        _finalizeStream();
      }
    }, onError: (e) => print("Stream Error: $e"));
  }

  void _handleTextChunk(String newChunk) {
    final currentText = (state.status == LiveChatStatus.processing)
        ? ""
        : (state.messages ?? "");
    state = state.copyWith(
      status: LiveChatStatus.streaming,
      messages: currentText + newChunk,
    );
    // We DO NOT add to TTS queue here because we are playing the audio response directly!
  }

  void _finalizeStream() {
    state = state.copyWith(status: LiveChatStatus.idle);
  }
}
