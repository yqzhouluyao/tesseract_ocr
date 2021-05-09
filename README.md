# Tesseract OCR for Flutter

Tesseract OCR 4.0 for flutter
This plugin is based on <a href="https://github.com/tesseract-ocr/tesseract">Tesseract OCR 4</a>
This plugin uses <a href="https://github.com/adaptech-cz/Tesseract4Android/"> Tesseract4Android </a> and <a href="https://github.com/SwiftyTesseract/SwiftyTesseract">SwiftyTesseract</a>.

[pub.dev link](https://pub.dev/packages/flutter_tesseract_ocr) 

## install 

```

dev_dependencies:
  ...
  flutter_tesseract_ocr:

```

## android 

1. android/build.gradle

```
 
 dependencies {
        classpath 'com.android.tools.build:gradle:3.6.2'
        ...
  }

```

2. android/app/build.gradle 
```
android {
  compileSdkVersion.....
  ...
  sourceSets {
        ...
  }
  packagingOptions{
      doNotStrip '*/mips/*.so'
      doNotStrip '*/mips64/*.so'
  }
}
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
//args android only 
String text = await TesseractOcr.extractText('/path/to/image', language: 'kor+eng',
        args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
        });

```

You can leave `language` empty, it will default to `'eng'.

```
//---- dynamic add Tessdata ---- ▼
// https://github.com/tesseract-ocr/tessdata/raw/master/dan_frak.traineddata
// download and read Tessdata (Uint8List)

String newTessDataFile = "deu.traineddata";
Directory d = Directory(await TesseractOcr.getTessdataPath());
d.list().forEach((traineddata) {
  print(traineddata); //current traineddata
});
File('${d.path}/${newTessDataFile}').writeAsBytes([Uint8List bytes]);
//---- dynamic add Tessdata ---- ▲

```



