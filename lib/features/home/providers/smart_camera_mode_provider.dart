import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'smart_camera_mode_provider.g.dart';

enum SmartCameraMode { off, color, light }

@Riverpod(keepAlive: true)
class SmartCameraState extends _$SmartCameraState {
  @override
  SmartCameraMode build() => SmartCameraMode.off;

  void setMode(SmartCameraMode mode) {
    state = mode;
  }
}
