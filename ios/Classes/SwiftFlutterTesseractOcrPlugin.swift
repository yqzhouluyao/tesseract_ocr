import Flutter
import UIKit
import SwiftyTesseract

public class SwiftFlutterTesseractOcrPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_tesseract_ocr", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterTesseractOcrPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "extractText" {

            guard let args = call.arguments else {
                result("iOS could not recognize flutter arguments in method: (sendParams)")
                return
            }

            let params: [String : Any] = args as! [String : Any]
            let language: String? = params["language"] as? String

            let dataSource = DocumentsDirectoryDataSource()
            let swiftyTesseract: SwiftyTesseract
            if let lang = language {
                swiftyTesseract = SwiftyTesseract(language: .custom(lang), dataSource: dataSource)
            } else {
                swiftyTesseract = SwiftyTesseract(language: .english, dataSource: dataSource)
            }

            let  imagePath = params["imagePath"] as! String
            guard let image = UIImage(contentsOfFile: imagePath) else { return }

            swiftyTesseract.performOCR(on: image) { recognizedString in
                guard let extractText = recognizedString else { return }
                result(extractText)
            }
        }
    }

}

public class DocumentsDirectoryDataSource: LanguageModelDataSource {
    public var pathToTrainedData: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return (documentsDirectory as NSString).appendingPathComponent("tessdata")
    }
}
