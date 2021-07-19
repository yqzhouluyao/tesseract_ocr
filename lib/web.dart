import 'dart:io';
import 'dart:js';

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:path_provider/path_provider.dart';

@JS('Tesseract.createWorker')
external dynamic createWorker();

class FlutterTesseractOcr {
  static const String TESS_DATA_CONFIG = 'assets/tessdata_config.json';
  static const String TESS_DATA_PATH = 'assets/tessdata';
  static var worker = createWorker();

  static extractText(String imagePath, {String? language, Map? args}) async {
    await promiseToFuture(worker.load());
    await promiseToFuture(worker.loadLanguage(language));
    await promiseToFuture(worker.initialize(language));

    await promiseToFuture(worker.setParameters(jsify(args!)));

    var rtn = await promiseToFuture(worker.recognize(imagePath, {}, worker.id));

    return rtn?.data?.text; //rtn?.data?.text;
  }

  static Future<String> extractHocr(String imagePath,
      {String? language, Map? args}) async {
    return "";
  }

  static Future<String> getTessdataPath() async {
    return "";
  }

  static Future<String> _loadTessData() async {
    return "";
  }

  static Future _copyTessDataToAppDocumentsDirectory(
      String tessdataDirectory) async {
    // final String config = await rootBundle.loadString(TESS_DATA_CONFIG);
    // print(config);
    // Map<String, dynamic> files = jsonDecode(config);
    // for (var file in files["files"]) {
    //   if (!await File('$tessdataDirectory/$file').exists()) {
    //     final ByteData data = await rootBundle.load('$TESS_DATA_PATH/$file');
    //     final Uint8List bytes = data.buffer.asUint8List(
    //       data.offsetInBytes,
    //       data.lengthInBytes,
    //     );
    //     await File('$tessdataDirectory/$file').writeAsBytes(bytes);
    //   }
    // }
  }
}
