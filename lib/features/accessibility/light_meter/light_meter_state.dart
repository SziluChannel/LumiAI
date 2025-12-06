import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum LightMeterStatus {
  initial,
  loading,
  active,
  error,
}

@immutable
class LightMeterState {
  final LightMeterStatus status;
  final CameraController? cameraController;
  final bool isCameraInitialized;
  final double brightness;
  final String brightnessCategory;
  final bool isProcessing;
  final String? errorMessage;

  const LightMeterState({
    this.status = LightMeterStatus.initial,
    this.cameraController,
    this.isCameraInitialized = false,
    this.brightness = 0.0,
    this.brightnessCategory = "",
    this.isProcessing = false,
    this.errorMessage,
  });

  LightMeterState copyWith({
    LightMeterStatus? status,
    CameraController? cameraController,
    bool? isCameraInitialized,
    double? brightness,
    String? brightnessCategory,
    bool? isProcessing,
    String? errorMessage,
  }) {
    return LightMeterState(
      status: status ?? this.status,
      cameraController: cameraController ?? this.cameraController,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      brightness: brightness ?? this.brightness,
      brightnessCategory: brightnessCategory ?? this.brightnessCategory,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
