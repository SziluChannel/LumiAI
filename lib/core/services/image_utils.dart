import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

// --- Isolate Workers ---

Future<List<int>> _compressDataIsolate(Map<String, dynamic> args) {
  final Uint8List bytes = args['bytes'] as Uint8List;
  var image = img.decodeImage(bytes);
  if (image == null) {
    throw Exception('Unable to decode image in isolate');
  }
  final newImage = img.Image(
    width: image.width,
    height: image.height,
    format: img.Format.uint8,
    numChannels: 3,
  );
  newImage.clear(img.ColorRgb8(255, 255, 255));
  img.compositeImage(newImage, image);
  image = newImage;

  int newWidth = image.width;
  int newHeight = image.height;
  if (image.width >= image.height) {
    if (image.width > (args['maxDim'] as int)) {
      newWidth = args['maxDim'] as int;
      newHeight = (image.height * (args['maxDim'] as int) / image.width)
          .round();
    }
  } else {
    if (image.height > (args['maxDim'] as int)) {
      newHeight = args['maxDim'] as int;
      newWidth = (image.width * (args['maxDim'] as int) / image.height).round();
    }
  }
  final resized = img.copyResize(
    image,
    width: newWidth,
    height: newHeight,
    interpolation: img.Interpolation.cubic,
  );
  return Future.value(img.encodeJpg(resized, quality: args['quality'] as int));
}

Future<List<int>> _compressFileIsolate(Map<String, dynamic> args) async {
  final String filePath = args['filePath'] as String;
  final bytes = await File(filePath).readAsBytes();
  return _compressDataIsolate({
    'bytes': bytes,
    'maxDim': args['maxDim'],
    'quality': args['quality'],
  });
}

// --- Public Functions ---

/// Compresses image data from a [Uint8List]. Recommended for web.
Future<Uint8List> compressImageBytes(
  Uint8List bytes, {
  int maxDim = 1024,
  int quality = 85,
}) async {
  if (maxDim <= 0) {
    throw ArgumentError.value(maxDim, 'maxDim', 'must be > 0');
  }
  final q = quality.clamp(1, 100).toInt();
  // On web, compute is not as effective for this, so we run it directly.
  // On mobile, we could use compute, but the path-based method is better.
  final result = await _compressDataIsolate({
    'bytes': bytes,
    'maxDim': maxDim,
    'quality': q,
  });
  return Uint8List.fromList(result);
}

/// Compresses an image from a [filePath]. Recommended for mobile/desktop.
Future<Uint8List> compressImageFromPath(
  String filePath, {
  int maxDim = 1024,
  int quality = 85,
}) async {
  final q = quality.clamp(1, 100).toInt();
  final result = await compute(_compressFileIsolate, {
    'filePath': filePath,
    'maxDim': maxDim,
    'quality': q,
  });
  return Uint8List.fromList(result);
}
