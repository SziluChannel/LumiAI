import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum ColorIdentifierStatus {
  initial,
  loading,
  active,
  error,
}

@immutable
class ColorIdentifierState {
  final ColorIdentifierStatus status;
  final CameraController? cameraController;
  final bool isCameraInitialized;
  final Color currentColor;
  final String currentColorName;
  final bool isProcessing;
  final String? errorMessage;

  const ColorIdentifierState({
    this.status = ColorIdentifierStatus.initial,
    this.cameraController,
    this.isCameraInitialized = false,
    this.currentColor = Colors.transparent,
    this.currentColorName = "Detecting...",
    this.isProcessing = false,
    this.errorMessage,
  });

  ColorIdentifierState copyWith({
    ColorIdentifierStatus? status,
    CameraController? cameraController,
    bool? isCameraInitialized,
    Color? currentColor,
    String? currentColorName,
    bool? isProcessing,
    String? errorMessage,
  }) {
    return ColorIdentifierState(
      status: status ?? this.status,
      cameraController: cameraController ?? this.cameraController,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      currentColor: currentColor ?? this.currentColor,
      currentColorName: currentColorName ?? this.currentColorName,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
