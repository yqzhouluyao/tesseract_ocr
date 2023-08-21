// part of flutter_tesseract_ocr;
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FlutterTesseractOcr {
  static const MethodChannel _channel =
      const MethodChannel('flutter_tesseract_ocr');

  /// image to text
  static Future<String> extractText(String imagePath,
      {String? language, Map? args}) async {
    assert(await File(imagePath).exists(), true);

    final String tessData = await getTessdataPath();
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
    assert(await File(imagePath).exists(), true);

    final String tessData = await getTessdataPath();
    final String extractText =
        await _channel.invokeMethod('extractHocr', <String, dynamic>{
      'imagePath': imagePath,
      'tessData': tessData,
      'language': language,
      'args': args,
    });
    return extractText;
  }

  /// getTessdataPath
  static Future<String> getTessdataPath() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String tessdataDirectory = join(appDirectory.path, 'tessdata');
    return tessdataDirectory;
  }
}
