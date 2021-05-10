# example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Common Issues

Tessearct may crash with SIG: 9. It is resolved maybe by `flutter clean` or downgrade NDK. If it reports class not found for TessBaseAPI, please add tesseract4android-release following the example.

For the following error,

```
> Direct local .aar file dependencies are not supported when building an AAR. The resulting AAR would be broken because the classes and Android resources from any local .aar file dependencies would not be packaged in the resulting AAR. Previous versions of the Android Gradle Plugin produce broken AARs in this case too (despite not throwing this error). The following direct local .aar file dependencies of the :flutter_tesseract_ocr project caused this error: C:\dev\git\QuanotesX\packages\flutter_tesseract_ocr\android\libs\tesseract4android-release.aar
```

Add compileOnly and comment implementation, like:

```
dependencies {
    compileOnly files('libs/tesseract4android-release.aar')
    //implementation fileTree(include: '*.aar', dir: 'libs')
}
```

For error

```
> No version of NDK matched the requested version 21.0.6113669. Versions available locally: 20.0.5594570
```

Just install the requested version.

A verified combination is:

- classpath 'com.android.tools.build:gradle:3.6.2'
- NdkVersion "20.0.5594570"
- aar attached
