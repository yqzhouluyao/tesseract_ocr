#import "TesseractOcrPlugin.h"
#import <flutter_tesseract_ocr/flutter_tesseract_ocr-Swift.h>

@implementation TesseractOcrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTesseractOcrPlugin registerWithRegistrar:registrar];
}
@end
