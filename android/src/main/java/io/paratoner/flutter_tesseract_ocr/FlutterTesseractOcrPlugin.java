package io.paratoner.flutter_tesseract_ocr;

import com.googlecode.tesseract.android.TessBaseAPI;

import androidx.annotation.NonNull;

import java.io.File;

import java.util.Map.*;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;


public class FlutterTesseractOcrPlugin implements FlutterPlugin, MethodCallHandler {
  private static final int DEFAULT_PAGE_SEG_MODE = TessBaseAPI.PageSegMode.PSM_AUTO_OSD;
  TessBaseAPI baseApi = null;
  String lastLanguage = "";

  private MethodChannel channel;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    // TODO: your plugin is now attached to a Flutter experience.
    BinaryMessenger messenger = flutterPluginBinding.getBinaryMessenger();
    channel = new MethodChannel(messenger, "flutter_tesseract_ocr");
    channel.setMethodCallHandler(this);

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: your plugin is no longer attached to a Flutter experience.
    channel.setMethodCallHandler(null);
    channel = null;
    this.baseApi.recycle();
    this.baseApi = null;

  }

@Override
public void onMethodCall(final MethodCall call, final Result result) {
    Log.d("TesseractPlugin", "Entering onMethodCall method with call: " + call.method);

    final String tessDataPath = call.argument("tessData");
    final String imagePath = call.argument("imagePath");
    final Map<String, String> args = call.argument("args");
    String DEFAULT_LANGUAGE = "eng";
    if (call.argument("language") != null) {
        DEFAULT_LANGUAGE = call.argument("language");
    }

    Log.d("TesseractPlugin", "TessData path provided: " + tessDataPath);
    Log.d("TesseractPlugin", "Image path provided: " + imagePath);

    switch (call.method) {
        case "extractText":
        case "extractHocr":
            if (baseApi == null || !lastLanguage.equals(DEFAULT_LANGUAGE)) {
                Log.d("TesseractPlugin", "Initializing Tesseract with language: " + DEFAULT_LANGUAGE);
                baseApi = new TessBaseAPI();

                if (baseApi.init(tessDataPath, DEFAULT_LANGUAGE)) {
                    Log.d("TesseractPlugin", "Tesseract initialized successfully");
                } else {
                    Log.e("TesseractPlugin", "Tesseract initialization failed");
                    result.error("INIT_ERROR", "Tesseract initialization failed", null);
                    return;
                }

                lastLanguage = DEFAULT_LANGUAGE;
            }

            int psm = DEFAULT_PAGE_SEG_MODE;
            if (args != null) {
                for (Map.Entry<String, String> entry : args.entrySet()) {
                    if (!entry.getKey().equals("psm")) {
                        baseApi.setVariable(entry.getKey(), entry.getValue());
                    } else {
                        psm = Integer.parseInt(entry.getValue());
                    }
                }
            }

            final File tempFile = new File(imagePath);
            baseApi.setPageSegMode(psm);
            new MyRunnable(baseApi, tempFile, result, call.method.equals("extractHocr")).run();
            break;

        default:
            result.notImplemented();
    }
    Log.d("TesseractPlugin", "Exiting onMethodCall method");
}



}

class MyRunnable implements Runnable {
    private TessBaseAPI baseApi;
    private File tempFile;
    private Result result;
    private boolean isHocr;

    public MyRunnable(TessBaseAPI baseApi, File tempFile, Result result, boolean isHocr) {
        this.baseApi = baseApi;
        this.tempFile = tempFile;
        this.result = result;
        this.isHocr = isHocr;
    }

    @Override
    public void run() {
        try {
            this.baseApi.setImage(this.tempFile);
            String recognizedText;
            if (isHocr) {
                recognizedText = this.baseApi.getHOCRText(0);
            } else {
                recognizedText = this.baseApi.getUTF8Text();
            }
            this.baseApi.stop();
            sendSuccess(recognizedText);
        } catch (Exception e) {
            Log.e("TesseractPlugin", "Error during Tesseract processing", e);
        }
    }

    public void sendSuccess(String msg) {
        final String str = msg;
        final Result res = this.result;
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                res.success(str);
            }
        });
    }
}
