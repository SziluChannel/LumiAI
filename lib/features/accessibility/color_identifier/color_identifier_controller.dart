import 'dart:async';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lumiai/core/utils/color_utils.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'color_identifier_state.dart';

part 'color_identifier_controller.g.dart';

@Riverpod(keepAlive: true)
class ColorIdentifierController extends _$ColorIdentifierController {
  Timer? _throttleTimer;
  String _lastSpokenColor = "";

  @override
  ColorIdentifierState build() {
    ref.onDispose(() {
      _throttleTimer?.cancel();
      state.cameraController?.dispose();
    });
    return const ColorIdentifierState();
  }

  Future<void> initialize() async {
    if (state.status == ColorIdentifierStatus.active) return;

    state = state.copyWith(status: ColorIdentifierStatus.loading);

    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
       state = state.copyWith(
        status: ColorIdentifierStatus.error, 
        errorMessage: "Camera permission denied"
      );
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(
          status: ColorIdentifierStatus.error, 
          errorMessage: "No cameras found"
        );
        return;
      }

      CameraController? controller;
      String? lastError;

      // Robust camera selection loop (matching GlobalListeningController logic)
      for (final camera in cameras) {
        try {
          if (state.cameraController != null) {
            await state.cameraController!.dispose();
          }

          final c = CameraController(
            camera,
            ResolutionPreset.low,
            enableAudio: false,
            // imageFormatGroup removed to match GlobalListeningController exactly
          );

          await c.initialize();
          controller = c;
          debugPrint("📷 ColorIdentifier: Camera initialized successfully: ${camera.name}");
          break;
        } catch (e) {
          lastError = e.toString();
          debugPrint("📷 ColorIdentifier: Camera init error: $e");
          if (kIsWeb && camera.lensDirection != CameraLensDirection.external) {
            try {
              final externalCamera = CameraDescription(
                name: camera.name,
                lensDirection: CameraLensDirection.external,
                sensorOrientation: camera.sensorOrientation,
              );
              final c2 = CameraController(
                externalCamera,
                ResolutionPreset.low,
                enableAudio: false,
              );
              await c2.initialize();
              controller = c2;
              break;
            } catch (_) {
              // Fallback failed, try next camera
            }
          }
          continue;
        }
      }

      if (controller == null) {
         state = state.copyWith(
          status: ColorIdentifierStatus.error,
          errorMessage: "Failed to initialize camera: $lastError",
        );
        return;
      }
      
      state = state.copyWith(
        status: ColorIdentifierStatus.active,
        cameraController: controller,
        isCameraInitialized: true,
      );

      await controller.startImageStream(_processImage);

    } catch (e) {
      state = state.copyWith(
        status: ColorIdentifierStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> disposeCamera() async {
    _throttleTimer?.cancel();
    if (state.cameraController != null) {
      await state.cameraController!.stopImageStream();
      await state.cameraController!.dispose();
    }
    state = const ColorIdentifierState(); // Reset to initial
  }

  void _processImage(CameraImage image) {
    if (state.isProcessing) return;
    
    // Throttle: Max 5 FPS (200ms)
    if (_throttleTimer != null && _throttleTimer!.isActive) return;
    _throttleTimer = Timer(const Duration(milliseconds: 200), () {});

    state = state.copyWith(isProcessing: true);

    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

      final int x = width ~/ 2;
      final int y = height ~/ 2;

      final int yp = image.planes[0].bytes[y * width + x];
      final int up = image.planes[1].bytes[(y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride];
      final int vp = image.planes[2].bytes[(y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride];

      int r = (yp + (1.370705 * (vp - 128))).toInt();
      int g = (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128))).toInt();
      int b = (yp + (1.732446 * (up - 128))).toInt();

      final color = Color.fromARGB(255, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
      final colorName = ColorUtils.getColorName(color);

      state = state.copyWith(
        currentColor: color,
        currentColorName: colorName,
        isProcessing: false,
      );

      if (colorName != _lastSpokenColor && colorName != "Unknown") {
        ref.read(feedbackServiceProvider).triggerSelectionFeedback();
        ref.read(ttsServiceProvider).value?.speak(colorName);
        _lastSpokenColor = colorName;
      }
    } catch (e) {
      debugPrint("Error processing image: $e");
      state = state.copyWith(isProcessing: false);
    }
  }
}
