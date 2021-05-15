import 'dart:async';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';
import 'package:image/image.dart' as im;
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tesseract Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tesseract Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ocrText = '';
  String _ocrHocr = '';
  String path = "";

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void _ocr() async {
    // final filename = 'test1.png';
    // var bytes = await rootBundle.load("assets/test1.png");
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // writeToFile(bytes, '$dir/$filename');
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // ---- dynamic add traineddata ---- ▼
      // https://github.com/tesseract-ocr/tessdata/raw/master/dan_frak.traineddata
      // download
      // String newTessDataFile = "deu.traineddata";
      // Directory d = Directory(await TesseractOcr.getTessdataPath());
      // d.list().forEach((event) {
      //   print(event);
      // });
      // File('${d.path}/${newTessDataFile}').writeAsBytes([Uint8List bytes]);
      // ---- dynamic add traineddata ---- ▲

      _ocrText = await FlutterTesseractOcr.extractText(pickedFile.path,
          language: 'kor',
          args: {
            "psm": "4",
            "preserve_interword_spaces": "1",
          });
      setState(() {});
      // for (int i = 600; i <= 700; i += 10) {
      // print('---------------------${i} ------------------------------------');

      im.Image image = im.decodeImage(File(pickedFile.path).readAsBytesSync())!;
      image = im.adjustColor(
        image.clone(),
        // blacks: 100,
        // amount: 1,
        // saturation: 0,
        gamma: 5,
        // exposure: 0.7,
      );

      File('${pickedFile.path}_op.jpg')..writeAsBytesSync(im.encodeJpg(image));
      path = '${pickedFile.path}_op.jpg';
      setState(() {});
      _ocrHocr = await FlutterTesseractOcr.extractText(
          '${pickedFile.path}_op.jpg',
          language: 'kor',
          args: {
            "psm": "4",
            "preserve_interword_spaces": "1",
          });
      print(_ocrHocr.split('   ').length);
      setState(() {});
      // print(test);
      // print('---------------------------------------------------------');
      // }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   'OCR result:',
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_ocrText',
                  // style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  '$_ocrHocr',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Divider(),
            Image.file(File(path)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ocr,
        tooltip: 'OCR',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class _PhotoOptimizerForOCR {
//   /// The exif metadata key representing a photo's length (corresponding to width of an [ui.Image])
//   static const exifTagImageLength = "EXIF ExifImageLength";

//   /// The exif metadata key representing a photo's width (corresponding to height of an [ui.Image])
//   static const exifTagImageWidth = "EXIF ExifImageWidth";

//   /// Returns the raw Map of exif metadata on the [path].
//   ///
//   /// __PS__. Not every photo would have exif metadata; hence it is normal to return an empty [Map].
//   static Future<Map<String?, IfdTag>?> getPhotoFileMeta(String path) async {
//     final fileBytes = File(path).readAsBytesSync();
//     Future<Map<String?, IfdTag>?> _meta = readExifFromBytes(fileBytes);
//     return _meta;
//   }

//   /// Returns the String description of the exif metadata on [path].
//   ///
//   /// __PS__. Not every photo would have exif metadata;
//   /// hence if no metadata available a message "oops, no exif data available for this photo!!!" would be returned
//   // static Future<String> getPhotoFileMetaInString(String path) async {
//   //   final fileBytes = File(path).readAsBytesSync();
//   //   Map<String, IfdTag> _meta =
//   //       readExifFromBytes(fileBytes) as Map<String, IfdTag>;
//   //   // Map<String, IfdTag> _meta =
//   //   //     (await readExifFromBytes(File(path).readAsBytesSync()));
//   //   StringBuffer _s = StringBuffer();

//   //   if (_meta == null || _meta.isEmpty) {
//   //     _s.writeln("oops, no exif data available for this photo!!!");
//   //     return _s.toString();
//   //   }
//   //   // Iterate all keys and its value.
//   //   _meta.keys.forEach((_k) {
//   //     _s.writeln("[$_k]: (${_meta[_k]?.tagType} - ${_meta[_k]})");
//   //   });
//   //   return _s.toString();
//   // }

//   /// Optimizes the photo at [path] by a constraint of [maxWidthOrLength].
//   ///
//   /// Resize logic is based on comparing the width and height of the image on [path] with the [maxWidthOrLength];
//   /// if either dimension is larger than [maxWidthOrLength], a corresponding resizing would be implemented.
//   /// Aspect ratio would be maintained to prevent image distortion. Finally the resized image would replace the original one.
//   // static Future<bool> optimizeByResize(String path,
//   //     {int maxWidthOrLength = 1500}) async {
//   //   int _w = 0;
//   //   int _h = 0;
//   //   Map<String?, IfdTag?> _meta =
//   //       (await _PhotoOptimizerForOCR.getPhotoFileMeta(path))!;

//   //   // Note that not every photo might have exif information~~~
//   //   if (_meta == null ||
//   //       _meta.isEmpty ||
//   //       _meta[_PhotoOptimizerForOCR.exifTagImageWidth] == null ||
//   //       _meta[_PhotoOptimizerForOCR.exifTagImageLength] == null) {
//   //     // Use the old fashion ImageProvider to resolve the photo's dimensions.
//   //     Completer _completer = Completer();
//   //     FileImage(File(path))
//   //         .resolve(ImageConfiguration())
//   //         .addListener(ImageStreamListener((imgInfo, _) {
//   //       _completer.complete(imgInfo.image);
//   //     }));
//   //     var _img = await _completer.future as ui.Image;
//   //     _w = _img.height;
//   //     _h = _img.width;
//   //   } else {
//   //     _w = _meta[_PhotoOptimizerForOCR.exifTagImageWidth]?.values![0] as int;
//   //     _h = _meta[_PhotoOptimizerForOCR.exifTagImageLength]?.values![0] as int;
//   //   }

//   //   double _factor = 1.0;
//   //   // Update the resized w and h after resizing.
//   //   if (_w >= _h) {
//   //     _factor = maxWidthOrLength / _w;
//   //     _w = (_w * _factor).round();
//   //     _h = (_h * _factor).round();
//   //   } else {
//   //     _factor = maxWidthOrLength / _h;
//   //     _w = (_w * _factor).round();
//   //     _h = (_h * _factor).round();
//   //   }

//   //   // [DOC] note the exif width = height of the image !! whilst exif length = width of the image !!

//   //   im.Image _resizedImage = im.copyResize(
//   //       im.decodeImage(File(path).readAsBytesSync())!,
//   //       width: _h,
//   //       height: _w);

//   //   // Overwrite existing file with the resized one.
//   //   File('${path}_op.jpg')..writeAsBytesSync(im.encodeJpg(_resizedImage));

//   //   return true;
//   // }
// }
