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
      // 1. Get Shared Client
      final client = ref.read(geminiLiveClientProvider.notifier);

      // 2. Connect (if needed)
      // Since it's shared, we only connect if disconnected to save resources
      if (!client.isConnected) {
        await client.connect();
      }

      // 3. Listen to Gemini Text Responses
      _geminiStreamSub?.cancel();
      _geminiStreamSub = client.textStream.listen((text) {
        _handleIncomingText(text);
      });

      // 4. Start Microphone
      await startRecording();
    } catch (e) {
      state = state.copyWith(
        status: LiveChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> startRecording() async {
    if (!await Permission.microphone.request().isGranted) return;

    state = state.copyWith(status: LiveChatStatus.listening);

    // 1. Start Amplitude Stream (Visuals)
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amp) {
          final double normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
          _amplitudeController.add(normalized);
        });

    // 2. Start Audio Stream
    const config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 16000,
      numChannels: 1,
    );

    final stream = await _audioRecorder.startStream(config);

    _audioStreamSub?.cancel();
    _audioStreamSub = stream.listen((data) {
      // Stream Mic Audio using the UNIFIED send() method
      ref
          .read(geminiLiveClientProvider.notifier)
          .send(audioBytes: data, audioMimeType: 'audio/pcm;rate=16000');
    });
  }

  Future<void> stopRecording() async {
    _amplitudeSubscription?.cancel();
    await _audioStreamSub?.cancel();
    await _audioRecorder.stop();

    state = state.copyWith(status: LiveChatStatus.processing);
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
