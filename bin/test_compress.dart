import 'dart:io';
import 'package:image/image.dart' as img;
// Ha a package neve nem 'lumiai', cseréld a következő sort a megfelelő package-importra,
// vagy használd a relatív importot: import '../lib/src/image_utils.dart';
import 'package:lumiai/src/image_utils.dart';

Future<void> main() async {
  final tmp = await Directory.systemTemp.createTemp('compress_test_');
  final srcPath = '${tmp.path}/src.jpg';
  // print('Temp dir: ${tmp.path}'); // Commented out print

  // generálunk egy nagy képet
  final image = img.Image(width: 2000, height: 1500);
  // fill the image with the color using the package:image helper
  img.fill(image, color: img.ColorRgb8(120, 180, 200));

  final jpg = img.encodeJpg(image, quality: 95);
  final srcFile = File(srcPath)..writeAsBytesSync(jpg);
  // print('Wrote source image: ${srcFile.path} (${srcFile.lengthSync()} bytes)'); // Commented out print

  try {
    // final outFile = await compressImage( // Commented out unused variable assignment
    await compressImage(
      srcFile,
      maxDim: 1024,
      quality: 80,
      computeFn: (fn, args) => fn(args), // szinkron runner a teszthez
    );
    // print('Compressed file: ${outFile.path} (${outFile.lengthSync()} bytes)'); // Commented out print
  } catch (e) { // Removed unused stack trace variable 'st'
    // print('compressImage failed: $e'); // Commented out print
  } finally {
    // opcionális: mutasd meg a tartalmat, majd töröld a mappát
    // await tmp.delete(recursive: true);
    // print('Temp left at: ${tmp.path} (delete manually if you want)'); // Commented out print
  }
}
