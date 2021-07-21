# Tesseract OCR for Flutter

Tesseract OCR 4.0 for flutter
This plugin is based on <a href="https://github.com/tesseract-ocr/tesseract">Tesseract OCR 4</a>
This plugin uses <a href="https://github.com/adaptech-cz/Tesseract4Android/"> Tesseract4Android </a> and <a href="https://github.com/SwiftyTesseract/SwiftyTesseract">SwiftyTesseract</a>.

[pub.dev link](https://pub.dev/packages/flutter_tesseract_ocr) 

## Finally did it!
Support latest gradle 


## install 

```

dev_dependencies:
  ...
  flutter_tesseract_ocr:

```

## web  
./web/index.html 

use https://www.npmjs.com/package/tesseract.js/v/2.1.1
```
<body>
  <script src='https://unpkg.com/tesseract.js@v2.1.0/dist/tesseract.min.js'></script>
  ...
  ..
  .
</body>
```




## Getting Started

You must add trained data and trained data config file to your assets directory.
You can find additional language trained data files here <a href="https://github.com/tesseract-ocr/tessdata">Trained language files</a>

add tessdata folder under assets folder, add tessdata_config.json file under assets folder:

```
{
  "files": [
    "eng.traineddata",
    "<other_language>.traineddata"
  ]
}
```

Plugin assumes you have tessdata folder in your assets directory and defined in your pubspec.yaml

Check the contents of example/assets folder and example/pubspec.yaml

## Usage

Using is very simple:

```
//args support android / Web , i don't have a mac 
String text = await FlutterTesseractOcr.extractText('/path/to/image', language: 'kor+eng',
        args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
        });

```

You can leave `language` empty, it will default to `'eng'.

```
//---- dynamic add Tessdata ---- ▼
// https://github.com/tesseract-ocr/tessdata/raw/master/dan_frak.traineddata

HttpClient httpClient = new HttpClient();

HttpClientRequest request = await httpClient.getUrl(Uri.parse(
        'https://github.com/tesseract-ocr/tessdata/raw/master/${langName}.traineddata'));

HttpClientResponse response = await request.close();
Uint8List bytes =await consolidateHttpClientResponseBytes(response);
String dir = await FlutterTesseractOcr.getTessdataPath();

print('$dir/${langName}.traineddata');
File file = new File('$dir/${langName}.traineddata');
await file.writeAsBytes(bytes);
//---- dynamic add Tessdata ---- ▲

```



