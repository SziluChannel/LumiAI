import 'dart:js_interop';
import 'package:web/web.dart' as web;

Future<void> requestWebCameraPermission() async {
  try {
    final constraints = web.MediaStreamConstraints(video: true.toJS);
    await web.window.navigator.mediaDevices.getUserMedia(constraints).toDart;
  } catch (e) {
    print("Web permission request failed: $e");
  }
}
