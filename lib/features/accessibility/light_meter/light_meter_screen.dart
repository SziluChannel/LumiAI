import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/l10n/app_localizations.dart';
import 'package:lumiai/core/services/feedback_service.dart';
import 'package:permission_handler/permission_handler.dart';

class LightMeterScreen extends ConsumerStatefulWidget {
  const LightMeterScreen({super.key});

  @override
  ConsumerState<LightMeterScreen> createState() => _LightMeterScreenState();
}

class _LightMeterScreenState extends ConsumerState<LightMeterScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  double _brightness = 0.0; // 0.0 to 1.0
  int _lastHapticTime = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Use back camera
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.low, // Low resolution is enough for light metering and faster
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      await _controller!.startImageStream(_processImage);
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void _processImage(CameraImage image) {
    if (_isProcessing) return;
    _isProcessing = true;

    // Calculate average luminance (Y plane)
    // Y plane is always the first plane in YUV420
    final plane = image.planes.first;
    final bytes = plane.bytes;
    int total = 0;
    
    // Sample pixels for performance (skip every 10th pixel)
    for (int i = 0; i < bytes.length; i += 10) {
      total += bytes[i];
    }
    
    // Average value (0-255)
    final count = (bytes.length / 10).ceil();
    final average = total / count;
    
    // Normalize to 0.0 - 1.0
    final newBrightness = (average / 255.0).clamp(0.0, 1.0);

    // Apply simple smoothing
    final smoothedBrightness = _brightness * 0.8 + newBrightness * 0.2;

    if (mounted) {
      setState(() {
        _brightness = smoothedBrightness;
      });
      _triggerHapticFeedback(smoothedBrightness);
    }

    _isProcessing = false;
  }

  void _triggerHapticFeedback(double brightness) {
    // Haptic feedback logic:
    // Frequency of vibration increases with brightness
    // OR Intensity increases with brightness.
    
    // Let's use impact intensity.
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Throttle feedback to avoid overwhelming the user/device (every 1000ms - brightness * 800)
    // Brighter = Faster interval (down to 200ms)
    // Darker = Slower interval (up to 1000ms)
    final interval = 1000 - (brightness * 800); 

    if (now - _lastHapticTime > interval) {
      if (brightness > 0.8) {
         HapticFeedback.heavyImpact();
      } else if (brightness > 0.4) {
         HapticFeedback.mediumImpact();
      } else if (brightness > 0.1) {
         HapticFeedback.lightImpact();
      }
      _lastHapticTime = now;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Background color based on brightness
    final bgColor = Color.lerp(Colors.black, Colors.white, _brightness)!;
    final textColor = _brightness > 0.5 ? Colors.black : Colors.white;
    final percentage = (_brightness * 100).toInt();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Light Meter"), // Should be localized
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _brightness > 0.5 ? Icons.wb_sunny : Icons.nightlight_round,
              size: 100,
              color: textColor,
            ),
            const SizedBox(height: 20),
            Text(
              "$percentage%",
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _brightness > 0.8 ? "Very Bright" : 
              _brightness > 0.5 ? "Bright" : 
              _brightness > 0.2 ? "Dim" : "Dark",
               style: TextStyle(
                fontSize: 24,
                color: textColor.withAlpha(200),
              ),
            ),
            if (!_isCameraInitialized)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
