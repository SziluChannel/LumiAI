import 'dart:async';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'light_meter_state.dart';

part 'light_meter_controller.g.dart';

@Riverpod(keepAlive: true)
class LightMeterController extends _$LightMeterController {
  Timer? _throttleTimer;
  int _lastHapticTime = 0;
  String _lastSpokenBrightnessCategory = "";

  @override
  LightMeterState build() {
    ref.onDispose(() {
      _throttleTimer?.cancel();
      state.cameraController?.dispose();
    });
    return const LightMeterState();
  }

  Future<void> initialize() async {
    if (state.status == LightMeterStatus.active) return;
    
    state = state.copyWith(status: LightMeterStatus.loading);

    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      state = state.copyWith(
        status: LightMeterStatus.error, 
        errorMessage: "Camera permission denied"
      );
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(
          status: LightMeterStatus.error, 
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
          debugPrint("📷 LightMeter: Camera initialized successfully: ${camera.name}");
          break;
        } catch (e) {
          lastError = e.toString();
          debugPrint("📷 LightMeter: Camera init error: $e");
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
          status: LightMeterStatus.error,
          errorMessage: "Failed to initialize camera: $lastError",
        );
        return;
      }
      
      state = state.copyWith(
        status: LightMeterStatus.active,
        cameraController: controller,
        isCameraInitialized: true,
      );

      await controller.startImageStream(_processImage);

    } catch (e) {
      state = state.copyWith(
        status: LightMeterStatus.error,
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
    state = const LightMeterState();
  }

  void _processImage(CameraImage image) {
    if (state.isProcessing) return;
    
    // Throttle: Max 5 FPS (200ms)
    if (_throttleTimer != null && _throttleTimer!.isActive) return;
    _throttleTimer = Timer(const Duration(milliseconds: 200), () {});

    state = state.copyWith(isProcessing: true);

    try {
      final plane = image.planes.first;
      final bytes = plane.bytes;
      int total = 0;
      
      // Sample every 10th pixel
      for (int i = 0; i < bytes.length; i += 10) {
        total += bytes[i];
      }
      
      final average = total / (bytes.length / 10).ceil();
      final newBrightness = (average / 255.0).clamp(0.0, 1.0);
      
      // Smoothing
      final smoothed = state.brightness * 0.7 + newBrightness * 0.3;

      state = state.copyWith(
        brightness: smoothed,
        isProcessing: false,
      );
      
      _triggerHapticFeedback(smoothed);
      _announceBrightness(smoothed);

    } catch (e) {
      debugPrint("Error processing image: $e");
      state = state.copyWith(isProcessing: false);
    }
  }

  void _triggerHapticFeedback(double brightness) {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Faster pulse for brighter light
    final interval = 1000 - (brightness * 800); 

    if (now - _lastHapticTime > interval) {
      if (brightness > 0.8) HapticFeedback.heavyImpact();
      else if (brightness > 0.4) HapticFeedback.mediumImpact();
      else if (brightness > 0.1) HapticFeedback.lightImpact();
      _lastHapticTime = now;
    }
  }

  void _announceBrightness(double brightness) {
    String category;
    if (brightness > 0.8) category = "Very Bright";
    else if (brightness > 0.5) category = "Bright";
    else if (brightness > 0.2) category = "Dim";
    else category = "Dark";

    state = state.copyWith(brightnessCategory: category);

    // Debounce speech: Only speak if category changes
    if (category != _lastSpokenBrightnessCategory) {
      ref.read(ttsServiceProvider).value?.speak(category);
      _lastSpokenBrightnessCategory = category;
    }
  }
}
