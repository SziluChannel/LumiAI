import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Top-level worker függvény, amit vagy compute-tal, vagy szinkron runner-rel hívunk.
Future<List<int>> _compressBytesIsolate(Map<String, dynamic> args) async {
  final dynamic rawBytes = args['bytes'];
  final Uint8List bytes = rawBytes is Uint8List
      ? rawBytes
      : Uint8List.fromList(List<int>.from(rawBytes as List));
  final int maxDim = args['maxDim'] as int;
  final int quality = args['quality'] as int;

  final image = img.decodeImage(bytes);
  if (image == null) throw Exception('Unable to decode image in isolate');

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

// Runner típus — tesztben injektálható compute-útvonal
typedef ComputeFn =
    Future<List<int>> Function(
      Future<List<int>> Function(Map<String, dynamic>),
      Map<String, dynamic>,
    );

Future<File> compressImage(
  File input, {
  int maxDim = 1024,
  int quality = 85,
  ComputeFn? computeFn, // ha null, default szinkron runner lesz használva
}) async {
  if (!await input.exists()) {
    throw Exception('Input file does not exist: ${input.path}');
  }
  if (maxDim <= 0) {
    throw ArgumentError.value(maxDim, 'maxDim', 'must be > 0');
  }

  final int q = quality.clamp(1, 100).toInt();
  final bytes = await input.readAsBytes();

  final runner =
      computeFn ??
      ((fn, args) async {
        return await fn(args);
      });

  final outBytes = await runner(_compressBytesIsolate, {
    'bytes': bytes,
    'maxDim': maxDim,
    'quality': q,
  });

  final out = File('${input.path}_compressed.jpg');
  await out.writeAsBytes(outBytes);
  return out;
}
