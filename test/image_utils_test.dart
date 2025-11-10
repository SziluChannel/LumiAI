import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:lumiai/src/image_utils.dart';

void main() {
  test('compressImage reduces dimensions and produces a file', () async {
    final tmpDir = await Directory.systemTemp.createTemp('imgtest');
    final srcPath = p.join(tmpDir.path, 'src.jpg');

    // építünk egy RGBA bájt tömböt és abból hozunk képet (kompatibilis minden image verzióval)
    const int w = 2000;
    const int h = 1500;
    final bytes = Uint8List(w * h * 4);
    final int r = 120, g = 180, b = 200, a = 255;
    for (var i = 0, pIdx = 0; i < w * h; i++, pIdx += 4) {
      bytes[pIdx] = r;
      bytes[pIdx + 1] = g;
      bytes[pIdx + 2] = b;
      bytes[pIdx + 3] = a;
    }

    final srcImage = img.Image.fromBytes(width: w, height: h, bytes: bytes.buffer);
    final jpg = img.encodeJpg(srcImage, quality: 95);
    final srcFile = File(srcPath)..writeAsBytesSync(jpg);

    final outFile = await compressImage(
      srcFile,
      maxDim: 1024,
      quality: 80,
      computeFn: (fn, args) => fn(args), // tesztben szinkron runner
    );

    expect(outFile.existsSync(), isTrue);

    final outBytes = outFile.readAsBytesSync();
    final outImage = img.decodeImage(outBytes);
    expect(outImage, isNotNull);
    expect(outImage!.width <= 1024 || outImage.height <= 1024, isTrue);

    await tmpDir.delete(recursive: true);
  });
}
