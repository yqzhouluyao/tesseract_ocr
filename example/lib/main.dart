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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tesseract Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ocrText = '';
  String _ocrHocr = '';
  String path =
      "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FqCviW%2FbtqGWTUaYLo%2FwD3ZE6r3ARZqi4MkUbcGm0%2Fimg.png";

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
            "preserve_interword_spaces": "1",
          });
      setState(() {});

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   'OCR result:',
            // ),
            ElevatedButton(
                onPressed: () async {
                  print(await FlutterTesseractOcr.extractText(path,
                      language: 'kor',
                      args: {
                        "psm": "4",
                        "preserve_interword_spaces": "1",
                      }));
                },
                child: Text("test")),

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
            Image.network(path),

            // Image.file(File(path)),
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
