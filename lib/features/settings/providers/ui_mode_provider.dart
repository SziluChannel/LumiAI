import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_mode_provider.g.dart';

enum UiMode { standard, simplified }

@Riverpod(keepAlive: true)
class UiModeController extends _$UiModeController {
  @override
  UiMode build() {
    return UiMode.standard;
  }

  void toggleMode() {
    if (state == UiMode.standard) {
      state = UiMode.simplified;
    } else {
      state = UiMode.standard;
    }
  }

  void setMode(UiMode mode) {
    state = mode;
  }
}
