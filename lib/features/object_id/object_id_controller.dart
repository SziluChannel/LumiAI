import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumiai/core/network/gemini_api.dart'; // Adjust path
import 'package:lumiai/core/services/image_utils.dart'; // Adjust path
import 'package:lumiai/core/services/tts_service.dart'; // Adjust path

import 'object_id_state.dart';

part 'object_id_controller.g.dart';

@riverpod
class ObjectIdController extends _$ObjectIdController {
  @override
  ObjectIdState build() => const ObjectIdState();

  /// Step 1: Open Camera
  Future<void> captureImage() async {
    final tts = ref.read(ttsServiceProvider); // Assuming you have a provider
    tts.speak('Opening camera.');

    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) {
        tts.speak('Camera closed. No image taken.');
        return;
      }

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
      tts.speak('Error opening camera.');
    }
  }

  /// Step 2: Retake
  void retakeImage() {
    captureImage();
  }

  /// Step 3: Confirm and Send to Gemini
  Future<void> confirmAndAnalyze() async {
    if (state.imageFile == null) return;

    final tts = ref.read(ttsServiceProvider);
    final gemini = ref.read(geminiApiClientProvider);

    state = state.copyWith(status: ObjectIdStatus.processing);
    tts.speak('Processing image. Please wait.');

    try {
      // 1. Compress
      late final Uint8List compressedBytes;
      final String path = state.imageFile!.path;

      if (kIsWeb) {
        final response = await http.get(Uri.parse(path));
        compressedBytes = await compressImageBytes(response.bodyBytes);
      } else {
        compressedBytes = await compressImageFromPath(path);
      }

      // 2. Connect & Send
      await gemini.connect();
      await gemini.sendImageAndText(
        compressedBytes,
        "Describe this image for a visually impaired user.",
      );

      // 3. Wait for response
      final response = await gemini.messageStream.firstWhere(
        (msg) => msg.text != null && msg.text!.isNotEmpty,
      );

      final result = response.text ?? "No description available.";

      // 4. Update State
      state = state.copyWith(
        status: ObjectIdStatus.success,
        resultText: result,
      );
      tts.speak(result);
    } catch (e) {
      state = state.copyWith(
        status: ObjectIdStatus.error,
        errorMessage: e.toString(),
      );
      tts.speak('An error occurred during processing.');
    }
  }

  /// Step 4: Reset
  void reset() {
    state = const ObjectIdState(); // Reset to idle
    final tts = ref.read(ttsServiceProvider);
    tts.speak('Returning to main menu.');
  }
}
