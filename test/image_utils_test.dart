import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:lumiai/src/image_utils.dart';

// --- Test Data Generators ---
Uint8List createTestJpeg(int width, int height) {
  final image = img.Image(width: width, height: height);
  img.fill(image, color: img.ColorRgb8(255, 0, 0));
  return Uint8List.fromList(img.encodeJpg(image));
}

Uint8List createTestPng(int width, int height) {
  final image = img.Image(width: width, height: height, numChannels: 4);
  img.fill(image, color: img.ColorRgba8(0, 255, 0, 128));
  return Uint8List.fromList(img.encodePng(image));
}

void main() {
  group('Image Utils: compressImageBytes', () {
    test('should resize an image larger than maxDim', () async {
      final largeImageBytes = createTestJpeg(2000, 1500);
      final compressedBytes = await compressImageBytes(
        largeImageBytes,
        maxDim: 1024,
      );
      final resultImage = img.decodeImage(compressedBytes);
      expect(resultImage, isNotNull);
      expect(resultImage!.width, 1024);
      expect(resultImage.height, lessThan(1500));
    });

    test('should NOT resize an image smaller than maxDim', () async {
      final smallImageBytes = createTestJpeg(500, 400);
      final compressedBytes = await compressImageBytes(smallImageBytes);
      final resultImage = img.decodeImage(compressedBytes);
      expect(resultImage, isNotNull);
      expect(resultImage!.width, 500);
      expect(resultImage.height, 400);
    });

    test('should correctly process a PNG with transparency', () async {
      final pngBytes = createTestPng(800, 600);
      final compressedBytes = await compressImageBytes(pngBytes);
      final resultImage = img.decodeImage(compressedBytes);
      expect(resultImage, isNotNull);
      expect(() => img.encodeJpg(resultImage!), returnsNormally);
    });

    test('should throw ArgumentError for maxDim <= 0', () {
      final imageBytes = createTestJpeg(100, 100);
      expect(
        () => compressImageBytes(imageBytes, maxDim: 0),
        throwsArgumentError,
      );
    });
  });
}
