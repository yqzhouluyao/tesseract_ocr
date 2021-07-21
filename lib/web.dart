import 'dart:io';
import 'dart:js';

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:path_provider/path_provider.dart';

@JS('Tesseract.createWorker')
external dynamic createWorker();

// FlutterTesseractOcr Class
class FlutterTesseractOcr {
  static var worker = createWorker();

  /// image to  text
  ///```
  /// String _ocrText = await FlutterTesseractOcr.extractText(url, language: langs, args: {
  ///    "preserve_interword_spaces": "1",});
  ///```
  static extractText(String imagePath, {String? language, Map? args}) async {
    await promiseToFuture(worker.load());
    await promiseToFuture(worker.loadLanguage(language));
    await promiseToFuture(worker.initialize(language));

    await promiseToFuture(worker.setParameters(jsify(args!)));

    var rtn = await promiseToFuture(worker.recognize(imagePath, {}, worker.id));

    return rtn?.data?.text; //rtn?.data?.text;
  }

  /// image to  html text(hocr)
  ///```
  /// String _ocrHocr = await FlutterTesseractOcr.extractText(url, language: langs, args: {
  ///    "preserve_interword_spaces": "1",});
  ///```
  static Future<String> extractHocr(String imagePath,
      {String? language, Map? args}) async {
    await promiseToFuture(worker.load());
    await promiseToFuture(worker.loadLanguage(language));
    await promiseToFuture(worker.initialize(language));

    await promiseToFuture(worker.setParameters(
        jsify({...args!, "tessjs_create_hocr": "1"}), worker.id));

    var rtn = await promiseToFuture(worker.recognize(imagePath, {}, worker.id));

    return rtn?.data?.hocr;
  }

  //web not support
  static Future<String> getTessdataPath() async {
    return "";
  }

  //web not support
  static Future<String> _loadTessData() async {
    return "";
  }

  //web not support
  static Future _copyTessDataToAppDocumentsDirectory(
      String tessdataDirectory) async {}
}


// var worker = Tesseract.createWorker();
// await worker.load();
// await worker.loadLanguage("eng");
// await worker.initialize("eng");
// // await worker.setParameters({ "tessjs_create_hocr": "1"});
// var rtn = worker.recognize("https://tesseract.projectnaptha.com/img/eng_bw.png");
// console.log(rtn.data);

// await worker.terminate();