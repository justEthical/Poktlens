import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lens/Bloc/CameraBloc.dart';
import 'package:logger/logger.dart';
//import 'package:lens/Screens/Home/HomeScreen.dart';
//import 'package:lens/bloc.dart';
//import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

class Test extends StatefulWidget {
  final camerabloc;
  Test(this.camerabloc);
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  CameraBloc _cameraBloc = CameraBloc();
  Logger _logger = Logger();
  List<AssetEntity> _mediaList = [];
  var title = 'kich ni';
  @override
  Widget build(BuildContext context) {
    _cameraBloc = widget.camerabloc;
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: GridView.builder(
            itemCount: _mediaList.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                future: _mediaList[index].thumbDataWithSize(200, 200),
                builder: (BuildContext context, snapshot) {
                  var filePath;
                  if (snapshot.connectionState == ConnectionState.done)
                    return GestureDetector(
                      onTap: () async {
                        var pa = await _mediaList[index].file;
                        filePath = pa.path;
                        _cameraBloc.selectedImageList.add(filePath);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color: !_cameraBloc.selectedImageList
                                        .contains(filePath)
                                    ? Colors.transparent
                                    : Colors.blueAccent)),
                        margin: EdgeInsets.all(2),
                        child: Image.memory(
                          snapshot.data,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  return Container();
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await PhotoManager.requestPermission();
            if (result) {
              _fetchNewMedia();
            } else {
              print('lkjlkja;ldsjfaaaaaaaaaaaaaaaaaaaaaaaaaaa');
            }

            //_logger.d("message");
          },
        ));
  }

  _fetchNewMedia() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, 10000);
      print(media);
      setState(() {
        _mediaList = media;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }
}
