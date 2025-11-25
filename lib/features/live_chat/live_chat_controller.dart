import 'dart:async';
import 'package:lumiai/core/network/gemini_live_client.dart'; // Manual Client
import 'package:lumiai/core/services/tts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'live_chat_state.dart';

part 'live_chat_controller.g.dart';

@riverpod
class LiveChatController extends _$LiveChatController {
  late final GeminiLiveClient _geminiClient;
  late final AudioRecorder _audioRecorder;
  StreamSubscription? _audioStreamSub;
  StreamSubscription? _geminiStreamSub;

  // --- AMPLITUDE STREAM FOR UI ---
  StreamSubscription? _amplitudeSubscription;
  final _amplitudeController = StreamController<double>.broadcast();
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  // TTS Buffers
  String _ttsBuffer = '';
  final List<String> _ttsQueue = [];
  bool _isSpeaking = false;

  @override
  LiveChatState build() {
    _geminiClient = GeminiLiveClient();
    _audioRecorder = AudioRecorder();

    ref.onDispose(() {
      _geminiClient.dispose();
      _audioRecorder.dispose();
      _audioStreamSub?.cancel();
      _geminiStreamSub?.cancel();
      _amplitudeSubscription?.cancel();
      _amplitudeController.close();
    });

    return const LiveChatState();
  }

  Future<void> startSession() async {
    try {
      // 1. Connect WebSocket
      await _geminiClient.connect();

      // 2. Listen to Gemini Text Responses
      _geminiStreamSub = _geminiClient.textStream.listen((text) {
        _handleIncomingText(text);
      });

      // 3. Start Microphone
      await startRecording();
    } catch (e) {
      state = state.copyWith(
        status: LiveChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> startRecording() async {
    // Permission Check
    if (!await Permission.microphone.request().isGranted) return;

    state = state.copyWith(status: LiveChatStatus.listening);

    // 1. Start Amplitude Stream (Visuals)
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amp) {
          // Normalize -60dB (silence) to 0dB (loud) into 0.0 - 1.0 range
          final double normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
          _amplitudeController.add(normalized);
        });

    // 2. Start Audio Stream (Data)
    // 16kHz PCM 16-bit is the raw format Gemini loves for real-time streaming
    const config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 16000,
      numChannels: 1,
    );

    final stream = await _audioRecorder.startStream(config);

    _audioStreamSub?.cancel();
    _audioStreamSub = stream.listen((data) {
      // Stream Mic Audio directly to WebSocket!
      _geminiClient.sendText("hello");
    });
  }

  Future<void> stopRecording() async {
    _amplitudeSubscription?.cancel(); // Stop visuals
    await _audioStreamSub?.cancel(); // Stop sending data
    await _audioRecorder.stop(); // Stop hardware mic

    state = state.copyWith(status: LiveChatStatus.processing);
  }

  // =========================================================
  // HANDLE INCOMING TEXT + TTS QUEUE
  // =========================================================
  void _handleIncomingText(String newTextChunk) {
    // 1. Update UI
    final currentText = (state.status == LiveChatStatus.processing)
        ? ""
        : (state.messages ?? "");

    state = state.copyWith(
      status: LiveChatStatus.streaming,
      messages: currentText + newTextChunk,
    );

    // 2. Buffer for TTS
    _ttsBuffer += newTextChunk;

    // 3. Check for Sentence Endings
    if (RegExp(r'[.?!:\n](\s|$)').hasMatch(_ttsBuffer)) {
      _ttsQueue.add(_ttsBuffer.trim());
      _ttsBuffer = "";
      _processTtsQueue();
    }
  }

  Future<void> _processTtsQueue() async {
    if (_isSpeaking || _ttsQueue.isEmpty) return;

    _isSpeaking = true;
    final textToSpeak = _ttsQueue.removeAt(0);
    final tts = ref.read(ttsServiceProvider);

    await tts.speak(textToSpeak);

    _isSpeaking = false;
    _processTtsQueue();
  }
}
