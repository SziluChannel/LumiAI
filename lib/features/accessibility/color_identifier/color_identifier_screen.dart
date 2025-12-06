import 'dart:async';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:lumiai/core/utils/color_utils.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart';

class ColorIdentifierScreen extends ConsumerStatefulWidget {
  const ColorIdentifierScreen({super.key});

  @override
  ConsumerState<ColorIdentifierScreen> createState() =>
      _ColorIdentifierScreenState();
}

class _ColorIdentifierScreenState extends ConsumerState<ColorIdentifierScreen> {
  CameraController? _controller;
  bool _isProcessing = false;
  String _currentColorName = "Detecting...";
  Color _currentColor = Colors.transparent;
  Timer? _throttleTimer;
  String _lastSpokenColor = "";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Use back camera
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      camera,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      
      // Start Image Stream
      _controller!.startImageStream(_processImage);
      setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  void _processImage(CameraImage image) {
    if (_isProcessing) return;
    
    // Throttle processing (e.g., max 5 FPS)
    if (_throttleTimer != null && _throttleTimer!.isActive) return;
    _throttleTimer = Timer(const Duration(milliseconds: 200), () {});

    _isProcessing = true;

    try {
      // Get center pixel color from YUV420 image
      // YUV420 to RGB conversion for the center pixel
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

      r = r.clamp(0, 255);
      g = g.clamp(0, 255);
      b = b.clamp(0, 255);

      final color = Color.fromARGB(255, r, g, b);
      final colorName = ColorUtils.getColorName(color);

      if (mounted) {
        setState(() {
          _currentColor = color;
          _currentColorName = colorName;
        });

        // Announce via TTS if stable
        _announceColor(colorName);
      }
    } catch (e) {
      debugPrint("Error processing image: $e");
    } finally {
      _isProcessing = false;
    }
  }

  void _announceColor(String colorName) {
    if (colorName != _lastSpokenColor && colorName != "Unknown") {
      ref.read(feedbackServiceProvider).triggerSelectionFeedback();
      ref.read(ttsServiceProvider).value?.speak(colorName);
      _lastSpokenColor = colorName;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Color Identifier")),
      body: Stack(
        children: [
          // 1. Camera Preview
          SizedBox.expand(
            child: CameraPreview(_controller!),
          ),

          // 2. Crosshair and Info Box
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Crosshair
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Color Info Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _currentColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ScaledTextWidget(
                        text: _currentColorName,
                        baseFontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
