import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:lens/Screens/Home/HomeScreen.dart';
//import 'package:lens/bloc.dart';
//import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var lst;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text("ljlkjklj")),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await PhotoManager.requestPermission();
            if (result) {
              
              lst = PhotoManager.getAssetPathList();
            } else {
              print('lkjlkja;ldsjfaaaaaaaaaaaaaaaaaaaaaaaaaaa');
            }
          },
        ));
  }
}
