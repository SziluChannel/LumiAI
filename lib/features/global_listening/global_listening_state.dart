import 'package:camera/camera.dart';

enum GlobalListeningStatus {
  idle,
  connecting,
  listening, // Mic active, waiting for user
  cameraActive, // Mic + Camera active
  error,
}

class GlobalListeningState {
  final GlobalListeningStatus status;
  final String? errorMessage;
  final CameraController? cameraController;
  final bool isCameraInitialized;
  final bool isMuted;

  const GlobalListeningState({
    this.status = GlobalListeningStatus.idle,
    this.errorMessage,
    this.cameraController,
    this.isCameraInitialized = false,
    this.isMuted = false,
  });

  GlobalListeningState copyWith({
    GlobalListeningStatus? status,
    String? errorMessage,
    CameraController? cameraController,
    bool? isCameraInitialized,
    bool? isMuted,
  }) {
    return GlobalListeningState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      cameraController: cameraController ?? this.cameraController,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
