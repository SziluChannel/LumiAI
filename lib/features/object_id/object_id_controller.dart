import 'dart:async';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumiai/core/network/gemini_api.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'object_id_state.dart';

part 'object_id_controller.g.dart';

@riverpod
class ObjectIdController extends _$ObjectIdController {
  StreamSubscription? _geminiSubscription;

  // Buffers for smooth streaming
  String _ttsBuffer = '';
  final List<String> _ttsQueue = [];
  bool _isSpeaking = false;

  @override
  ObjectIdState build() {
    // Clean up subscription if the provider is destroyed
    ref.onDispose(() {
      _geminiSubscription?.cancel();
    });
    return const ObjectIdState();
  }

  // ... (captureImage and retakeImage remain the same) ...
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
      /* Error handling */
    }
  }

  void retakeImage() => captureImage();

  /// Step 3: Stream Logic
  Future<void> confirmAndAnalyze() async {
    if (state.imageFile == null) return;

    final tts = ref.read(ttsServiceProvider);
    final gemini = ref.read(geminiApiClientProvider);

    // Initial Processing State
    state = state.copyWith(status: ObjectIdStatus.processing, resultText: "");
    _ttsBuffer = "";
    _ttsQueue.clear();
    tts.speak('Analyzing...');

    try {
      final Uint8List imageBytes = await state.imageFile!.readAsBytes();

      // 1. Connect
      await gemini.connect();

      // 2. Send Data
      await gemini.sendImageAndText(
        imageBytes,
        "Describe this image for a visually impaired user. Be descriptive but concise.",
      );

      // 3. Listen to the Stream (Chunk by Chunk)
      _geminiSubscription?.cancel();
      _geminiSubscription = gemini.messageStream.listen(
        (message) {
          // A. Handle Text Chunk
          if (message.text != null && message.text!.isNotEmpty) {
            _handleTextChunk(message.text!);
          }

          // B. Handle End of Turn
          if (message.serverContent?.turnComplete ?? false) {
            _finalizeStream();
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
    } catch (e) {
      state = state.copyWith(
        status: ObjectIdStatus.error,
        errorMessage: e.toString(),
      );
      tts.speak('An error occurred.');
    }
  }

  void _handleTextChunk(String newChunk) {
    // 1. Update UI immediately (Append text)
    final currentText = state.resultText ?? "";
    state = state.copyWith(
      status: ObjectIdStatus.streaming, // Switch to streaming mode
      resultText: currentText + newChunk,
    );

    // 2. Queue for TTS (Sentence Buffering)
    _ttsBuffer += newChunk;

    // Check for sentence endings (. ? ! \n)
    // We look for punctuation followed by a space or end of string
    if (RegExp(r'[.?!](\s|$)').hasMatch(_ttsBuffer)) {
      _ttsQueue.add(_ttsBuffer);
      _ttsBuffer = ""; // Clear buffer
      _processTtsQueue(); // Trigger playback
    }
  }

  Future<void> _processTtsQueue() async {
    if (_isSpeaking || _ttsQueue.isEmpty) return;

    _isSpeaking = true;
    final tts = ref.read(ttsServiceProvider);
    final textToSpeak = _ttsQueue.removeAt(0);

    // We await the speak completion to prevent overlap
    // Note: Ensure your TtsService.speak returns a Future that completes when audio finishes
    // If it doesn't, we might need a rough estimate delay based on word count.
    await tts.speak(textToSpeak);

    _isSpeaking = false;
    _processTtsQueue(); // Recursive call for next item
  }

  void _finalizeStream() {
    _geminiSubscription?.cancel();

    // Flush remaining buffer to TTS
    if (_ttsBuffer.isNotEmpty) {
      _ttsQueue.add(_ttsBuffer);
      _processTtsQueue();
    }

    state = state.copyWith(status: ObjectIdStatus.success);
  }

  void reset() {
    _geminiSubscription?.cancel();
    state = const ObjectIdState();
    _ttsQueue.clear();
    _isSpeaking = false;
    ref.read(ttsServiceProvider).stop(); // Stop any ongoing speech
    ref.read(ttsServiceProvider).speak('Returning to main menu.');
  }
}
