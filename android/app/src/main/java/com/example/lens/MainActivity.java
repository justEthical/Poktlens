package com.example.lens;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import org.bytedeco.javacpp.Loader;
import java.util.ArrayList;

import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "today.poktlens.imgprocessing";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
  Loader.load(org.bytedeco.javacpp.opencv_java.class);
  //System.load('C:\\Android\\opencv3\\opencv\\build\\java\\x64\\opencv_java3410.dll');
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
            (call, result) -> {
              switch (call.method) {
                case "getBatteryLevel":
                  int batteryLevel = getBatteryLevel();      
                  if (batteryLevel != -1) {
                    result.success(batteryLevel);
                  } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                  }
                  break;
                case "userdir":
                  result.success(userdir());
                  break;
                case "vertices":
                  result.success(Plugin.foundVertices((String)call.argument("filePath")));
                case "autoCrop":
                  result.success(Plugin.autoCrop((String)call.argument("filePath")));
                case "bw":
                  result.success(Plugin.bw((String)call.argument("filePath")));
                case "customWarp":
                  result.success(Plugin.customCrop((String)call.argument("filePath"), (ArrayList<Double>)call.argument("cList"), (boolean)call.argument("scaned")));
                default:
                  result.notImplemented();
                  break;
              }
              }
        );
  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  private String openJ(){
    Mat mat = Mat.eye(3, 3, CvType.CV_8UC1);
    return mat.dump();
  }
  private String userdir(){
    return System.getProperty("java.io.tmpdir");
  }

  private String home(){
    return System.getProperty("home");
  }

  private String ext(){
    return System.getProperty("Java.ext.dirs");
  }
}
