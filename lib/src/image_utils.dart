import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

// --- Private Top-Level Worker ---

/// A top-level function designed to run in an isolate via `compute`.
///
/// Decodes an image from a byte list, resizes it to fit within [maxDim],
/// and re-encodes it as a JPEG with the given [quality].
/// The arguments are passed as a map to comply with the `compute` function's
/// single-argument requirement.
Future<List<int>> _compressBytesIsolate(Map<String, dynamic> args) async {
  final dynamic rawBytes = args['bytes'];
  final Uint8List bytes = rawBytes is Uint8List
      ? rawBytes
      : Uint8List.fromList(List<int>.from(rawBytes as List));
  final int maxDim = args['maxDim'] as int;
  final int quality = args['quality'] as int;

  final image = img.decodeImage(bytes);
  if (image == null) {
    throw Exception('Unable to decode image in isolate');
  }

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

// --- Public API ---

/// A function signature for a "runner" that executes a worker function.
///
/// This allows for abstracting away the execution logic, enabling either
/// direct synchronous calls for testing or using Flutter's `compute` for
/// running in a background isolate.
typedef ComputeFn =
    Future<List<int>> Function(
      Future<List<int>> Function(Map<String, dynamic>),
      Map<String, dynamic>,
    );

/// Compresses image data from a [Uint8List].
///
/// This is the recommended platform-agnostic function for use in Flutter UIs,
/// as it works with in-memory bytes and does not depend on `dart:io`.
///
/// - [bytes]: The raw image data to compress.
/// - [maxDim]: The maximum dimension (width or height) for the output image.
/// - [quality]: The JPEG quality for the output image, from 1 to 100.
/// - [computeFn]: An optional runner. For Flutter apps, pass `compute` to run
///   this in a background isolate and avoid blocking the UI.
///
/// Returns the compressed image data as a [Uint8List].
Future<Uint8List> compressImageBytes(
  Uint8List bytes, {
  int maxDim = 1024,
  int quality = 85,
  ComputeFn? computeFn,
}) async {
  if (maxDim <= 0) {
    throw ArgumentError.value(maxDim, 'maxDim', 'must be > 0');
  }
  final q = quality.clamp(1, 100).toInt();
  final runner = computeFn ?? (fn, args) async => await fn(args);

  final outBytes = await runner(_compressBytesIsolate, {
    'bytes': bytes,
    'maxDim': maxDim,
    'quality': q,
  });

  if (outBytes is Uint8List) {
    return outBytes;
  }
  return Uint8List.fromList(outBytes);
}

/// Compresses an image [File] by resizing and re-encoding it.
///
/// This function is suitable for server-side or command-line applications
/// that work directly with the file system. For Flutter UI, prefer
/// [compressImageBytes].
///
/// The output is written to a new file with a `_compressed.jpg` suffix.
///
/// Returns the [File] handle for the newly created compressed image.
Future<File> compressImage(
  File input, {
  int maxDim = 1024,
  int quality = 85,
  ComputeFn? computeFn,
}) async {
  if (!await input.exists()) {
    throw Exception('Input file does not exist: ${input.path}');
  }
  final bytes = await input.readAsBytes();
  final compressed = await compressImageBytes(
    bytes,
    maxDim: maxDim,
    quality: quality,
    computeFn: computeFn,
  );

  final out = File('${input.path}_compressed.jpg');
  await out.writeAsBytes(compressed);
  return out;
}
