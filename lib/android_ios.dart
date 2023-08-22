import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FlutterTesseractOcr {
  static const String TESS_DATA_PATH = 'assets/tessdata';
  static const MethodChannel _channel =
      const MethodChannel('flutter_tesseract_ocr');

  /// image to text
  static Future<String> extractText(String imagePath,
      {String? language, Map? args}) async {
    print("extractText Image path: $imagePath");

    assert(await File(imagePath).exists(), true);

    final String tessData = await _getTessDataPathForPlatform();
    final String extractText =
        await _channel.invokeMethod('extractText', <String, dynamic>{
      'imagePath': imagePath,
      'tessData': tessData,
      'language': language,
      'args': args,
    });
    return extractText;
  }

  /// image to html text (hocr)
  static Future<String> extractHocr(String imagePath,
      {String? language, Map? args}) async {
    print("extractHocr Image path: $imagePath");

    assert(await File(imagePath).exists(), true);

    final String tessData = await _getTessDataPathForPlatform();
    final String extractText =
        await _channel.invokeMethod('extractHocr', <String, dynamic>{
      'imagePath': imagePath,
      'tessData': tessData,
      'language': language,
      'args': args,
    });
    return extractText;
  }

  /// Private helper method to get tessdata path based on platform
/// Private helper method to get tessdata path based on platform
static Future<String> _getTessDataPathForPlatform() async {
  if (Platform.isIOS) {
    return await getTessdataPath();
  } else { // Android
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    return appDirectory.path;  // Return the parent directory
  }
}


  /// getTessdataPath
  static Future<String> getTessdataPath() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    return join(appDirectory.path, 'tessdata');
  }

  static Future<void> _copyTessDataToAppDocumentsDirectory(String tessdataDirectory) async {
    final Directory tessdataAssetDirectory = Directory(TESS_DATA_PATH);
    final List<FileSystemEntity> files = tessdataAssetDirectory.listSync();

    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith('.traineddata')) {
        final ByteData data = await rootBundle.load(file.path);
        final List<int> bytes = data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);

        final String targetPath = join(tessdataDirectory, basename(file.path));
        if (!await File(targetPath).exists()) {
          await File(targetPath).writeAsBytes(bytes);
        }
      }
    }
  }
}
