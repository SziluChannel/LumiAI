import 'dart:async';
import 'package:lumiai/core/network/gemini_live_client.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'live_chat_state.dart';

part 'live_chat_controller.g.dart';

@riverpod
class LiveChatController extends _$LiveChatController {
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
    _audioRecorder = AudioRecorder();

    ref.onDispose(() {
      _audioRecorder.dispose();
      _audioStreamSub?.cancel();
      _geminiStreamSub?.cancel();
      _amplitudeSubscription?.cancel();
      _amplitudeController.close();
      // We DO NOT dispose the GeminiClient here because it is shared
    });

    return const LiveChatState();
  }

  Future<void> startSession() async {
    try {
      // 1. Request microphone permission first
      if (!await Permission.microphone.request().isGranted) {
        state = state.copyWith(
          status: LiveChatStatus.error,
          errorMessage: 'Microphone permission denied',
        );
        return;
      }

      // 2. Get Shared Client
      final client = ref.read(geminiLiveClientProvider.notifier);

      // 3. Connect (if needed)
      if (!client.isConnected) {
        await client.connect();
      }

      // 4. Listen to Gemini Text Responses
      _geminiStreamSub?.cancel();
      _geminiStreamSub = client.textStream.listen((text) {
        _handleIncomingText(text);
      });

      // 5. Start continuous audio streaming
      await _startContinuousRecording();
    } catch (e) {
      state = state.copyWith(
        status: LiveChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _startContinuousRecording() async {
    state = state.copyWith(status: LiveChatStatus.listening);

    // 1. Start Amplitude Stream (Visuals)
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amp) {
          final double normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
          _amplitudeController.add(normalized);
        });

    // 2. Start continuous audio stream
    const config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 16000,
      numChannels: 1,
    );

    final stream = await _audioRecorder.startStream(config);

    _audioStreamSub?.cancel();
    _audioStreamSub = stream.listen((data) {
      // Continuously stream mic audio to Gemini Live API
      ref
          .read(geminiLiveClientProvider.notifier)
          .send(
            audioBytes: data, 
            audioMimeType: 'audio/pcm;rate=16000',
            isRealtime: true, // Enable real-time streaming
          );
    });
  }

  void stopSession() {
    // Stop audio recording
    _amplitudeSubscription?.cancel();
    _audioStreamSub?.cancel();
    _audioRecorder.stop();
    
    // Reset state
    state = const LiveChatState();
  }

  void _handleIncomingText(String newTextChunk) {
    final currentText = (state.status == LiveChatStatus.processing)
        ? ""
        : (state.messages ?? "");

    state = state.copyWith(
      status: LiveChatStatus.streaming,
      messages: currentText + newTextChunk,
    );

    _ttsBuffer += newTextChunk;
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
