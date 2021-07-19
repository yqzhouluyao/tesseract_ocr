import 'dart:html';
import 'dart:js';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('Tesseract.recognize')
external String recognize(path, lang);

class FlutterTesseractOcr {
  static const String TESS_DATA_CONFIG = 'assets/tessdata_config.json';
  static const String TESS_DATA_PATH = 'assets/tessdata';

  static extractText(String imagePath, {String? language, Map? args}) async {
    var rtn = await promiseToFuture(recognize(imagePath, "eng"));

    print(rtn.data.text);

    return rtn?.data?.text;
  }

  // static Future<String> extractText(String imagePath,
  //     {String? language, Map? args}) async {
  //   var object = context['Tesseract.recognize'];

  //   // dynamic aa = context.callMethod('Tesseract', [
  //   //   'https://tesseract.projectnaptha.com/img/eng_bw.png',
  //   //   'eng',
  //   // ]);
  //   print(':::: $object');
  //   return "asdf";
  // }

  static Future<String> extractHocr(String imagePath,
      {String? language, Map? args}) async {
    return "asdf";
  }

  static Future<String> getTessdataPath() async {
    // final Directory appDirectory = await getApplicationDocumentsDirectory();
    // final String tessdataDirectory = join(appDirectory.path, 'tessdata');
    return "web";
  }

  static Future<String> _loadTessData() async {
    return "web";
  }

  static Future _copyTessDataToAppDocumentsDirectory(
      String tessdataDirectory) async {
    // final String config = await rootBundle.loadString(TESS_DATA_CONFIG);
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
