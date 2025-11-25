import 'dart:async';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:lumiai/core/constants/app_prompts.dart';
import 'package:lumiai/core/network/gemini_live_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'object_id_state.dart';

part 'object_id_controller.g.dart';

@riverpod
class ObjectIdController extends _$ObjectIdController {
  StreamSubscription? _textSubscription;
  StreamSubscription? _turnSubscription;

  String _ttsBuffer = '';
  final List<String> _ttsQueue = [];
  bool _isSpeaking = false;

  @override
  ObjectIdState build() {
    ref.onDispose(() {
      _textSubscription?.cancel();
      _turnSubscription?.cancel();
      // We do NOT dispose the client here because it's shared
    });
    return const ObjectIdState();
  }

  Future<void> captureImage() async {
    final tts = ref.read(ttsServiceProvider);
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile == null) return;

      state = state.copyWith(
        status: ObjectIdStatus.confirmingImage,
        imageFile: pickedFile,
      );
      tts.speak('Photo captured. Confirm or Retake.');
    } catch (e) {
      state = state.copyWith(
        status: ObjectIdStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void retakeImage() => captureImage();

  Future<void> confirmAndAnalyze() async {
    if (state.imageFile == null) return;

    final tts = ref.read(ttsServiceProvider);

    // 1. Get Shared Client
    final client = ref.read(geminiLiveClientProvider.notifier);

    state = state.copyWith(status: ObjectIdStatus.processing, resultText: "");
    _ttsBuffer = "";
    _ttsQueue.clear();
    tts.speak('Analyzing...');

    try {
      final Uint8List imageBytes = await state.imageFile!.readAsBytes();

      // 2. Connect
      if (!client.isConnected) {
        await client.connect();
      }

      // 3. Listen to Text (Chunks)
      _textSubscription?.cancel();
      _textSubscription = client.textStream.listen(
        (textChunk) {
          if (textChunk.isNotEmpty) {
            _handleTextChunk(textChunk);
          }
        },
        onError: (e) {
          state = state.copyWith(
            status: ObjectIdStatus.error,
            errorMessage: e.toString(),
          );
          tts.speak("Connection error.");
        },
      );

      // 4. Listen to Turn Complete
      _turnSubscription?.cancel();
      _turnSubscription = client.turnCompleteStream.listen((_) {
        _finalizeStream();
      });

      // 5. Send Image + Prompt using Unified Method
      client.send(imageBytes: imageBytes, text: AppPrompts.identifyObject);
    } catch (e) {
      state = state.copyWith(
        status: ObjectIdStatus.error,
        errorMessage: e.toString(),
      );
      tts.speak('An error occurred.');
    }
  }

  void _handleTextChunk(String newChunk) {
    final currentText = state.resultText ?? "";
    state = state.copyWith(
      status: ObjectIdStatus.streaming,
      resultText: currentText + newChunk,
    );

    _ttsBuffer += newChunk;
    if (RegExp(r'[.?!:\n](\s|$)').hasMatch(_ttsBuffer)) {
      _ttsQueue.add(_ttsBuffer);
      _ttsBuffer = "";
      _processTtsQueue();
    }
  }

  Future<void> _processTtsQueue() async {
    if (_isSpeaking || _ttsQueue.isEmpty) return;

    _isSpeaking = true;
    final tts = ref.read(ttsServiceProvider);
    final textToSpeak = _ttsQueue.removeAt(0);

    await tts.speak(textToSpeak);

    _isSpeaking = false;
    _processTtsQueue();
  }

  void _finalizeStream() {
    _textSubscription?.cancel();
    _turnSubscription?.cancel();

    if (_ttsBuffer.isNotEmpty) {
      _ttsQueue.add(_ttsBuffer);
      _processTtsQueue();
    }

    state = state.copyWith(status: ObjectIdStatus.success);
  }

  void reset() {
    _textSubscription?.cancel();
    _turnSubscription?.cancel();
    state = const ObjectIdState();
    _ttsQueue.clear();
    _isSpeaking = false;
    ref.read(ttsServiceProvider).stop();
    ref.read(ttsServiceProvider).speak('Returning to main menu.');
  }
}
