import 'package:flutter/services.dart';
import 'dart:convert';

import 'contour.dart';

class Plugin {
  static const platform = const MethodChannel("today.poktlens.imgprocessing");

  static Future<String> autoCrop(String path) async {
    try {
      String imgPath =
          await platform.invokeMethod("autoCrop", {"filePath": path});
      return imgPath;
    } on PlatformException catch (e) {
      print("Something went wrong $e");
      return null;
    }
  }

  static Future<List<Point>> foundVertices(String path) async {
    try {
      String data = await platform.invokeMethod("vertices", {"filePath": path});
      print(data.length);
      return Contour.fromJson(json.decode(data)).contour;
    } on PlatformException catch (e) {
      print("Something went wrong $e");
      return null;
    }
  }

  static Future<String> customWarp(String path, List<double> cList, bool scaned) async {
    try {
      String imgPath = await platform
          .invokeMethod("customWarp", {"filePath": path, "cList": cList, "scaned": scaned});
      return imgPath;
    } on PlatformException catch (e) {
      print("Something went wrong $e");
      return null;
    }
  }
}
