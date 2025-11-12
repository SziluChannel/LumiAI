import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

// --- Isolate Worker ---

/// A top-level function that reads an image from a [filePath], processes it,
/// and returns the compressed bytes. Designed to run in an isolate.
Future<List<int>> _compressFileIsolate(Map<String, dynamic> args) async {
  final String filePath = args['filePath'] as String;
  final int maxDim = args['maxDim'] as int;
  final int quality = args['quality'] as int;

  // Read the file inside the isolate to avoid blocking the main thread.
  final bytes = await File(filePath).readAsBytes();

  var image = img.decodeImage(bytes);
  if (image == null) {
    throw Exception('Unable to decode image in isolate from path: $filePath');
  }

  // This is the robust PNG-to-JPEG conversion logic.
  final newImage = img.Image(
    width: image.width,
    height: image.height,
    format: img.Format.uint8,
    numChannels: 3,
  );
  newImage.clear(img.ColorRgb8(255, 255, 255));
  img.compositeImage(newImage, image);
  image = newImage;

  // Resize if the image is larger than the max dimension.
  int newWidth = image.width;
  int newHeight = image.height;
  if (image.width >= image.height) {
    if (image.width > maxDim) {
      newWidth = maxDim;
      newHeight = (image.height * maxDim / image.width).round();
    }
  } else {
    if (image.height > maxDim) {
      newHeight = maxDim;
      newWidth = (image.width * maxDim / image.height).round();
    }
  }

  final resized = img.copyResize(
    image,
    width: newWidth,
    height: newHeight,
    interpolation: img.Interpolation.cubic,
  );
  return img.encodeJpg(resized, quality: quality);
}

// --- Public Functions ---

/// Compresses image data from a [Uint8List].
/// This runs on the main thread and is intended for web use where isolates are less effective
/// and file I/O is not direct.
Future<Uint8List> compressImageBytes(
  Uint8List bytes, {
  int maxDim = 1024,
  int quality = 85,
}) async {
  // This is a synchronous version of the isolate logic for web.
  var image = img.decodeImage(bytes);
  if (image == null) throw Exception('Unable to decode image');

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
    if (image.width > maxDim) {
      newWidth = maxDim;
      newHeight = (image.height * maxDim / image.width).round();
    }
  } else {
    if (image.height > maxDim) {
      newHeight = maxDim;
      newWidth = (image.width * maxDim / image.height).round();
    }
  }

  final resized = img.copyResize(
    image,
    width: newWidth,
    height: newHeight,
    interpolation: img.Interpolation.cubic,
  );
  return Uint8List.fromList(img.encodeJpg(resized, quality: quality));
}

/// Compresses an image from a [filePath] in a background isolate.
/// This is the recommended function for mobile/desktop to avoid UI freezes.
Future<Uint8List> compressImageFromPath(
  String filePath, {
  int maxDim = 1024,
  int quality = 85,
}) async {
  final q = quality.clamp(1, 100).toInt();

  // This correctly calls the file-based isolate worker.
  final result = await compute(_compressFileIsolate, {
    'filePath': filePath,
    'maxDim': maxDim,
    'quality': q,
  });

  return Uint8List.fromList(result);
}
