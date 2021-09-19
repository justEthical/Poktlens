import 'dart:async';
import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lens/Bloc/CameraBloc.dart';
import 'package:lens/Screens/AllImages/AllImages.dart';
import 'package:lens/Screens/Home/Home.dart';
import 'package:lens/Screens/ImageCheck/imageCheck.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final cambloc;
  CameraScreen(this.cambloc);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraBloc _cameraBloc;

  double maxW, maxH;
  PictureController _pictureController = PictureController();
  ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<double> _zoomNotifier = ValueNotifier(0);
  ValueNotifier<Size> _photoSize = ValueNotifier(null);
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<bool> _enableAudio = ValueNotifier(true);
  ValueNotifier<CameraOrientations> _orientation = ValueNotifier(null);

  List<Size> availableSizes = new List<Size>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cameraBloc = widget.cambloc;
    //-------------------------------------Rotation Off---------------------------------------------//
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    maxW = MediaQuery.of(context).size.width;
    maxH = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () {
          exitAlert(context);
        },
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 60,
                width: maxW,
                color: Colors.white,
                //child: Icon(Icons.home),
              ),
              Container(child: Center(child: _cameraScreen())),
              Container(child: _bottomBar())
            ],
          ),
        ));
  }

  exitAlert(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Go To Home"),
              content: Text("All changes will be discarded"),
              actions: [
                RaisedButton(
                    child: Text(
                      "Discard",
                    ),
                    onPressed: () {
                      _cameraBloc.currentProcessingImg.clear();
                      _cameraBloc.selectedImageList.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    })
              ]);
        });
  }

  Widget _cameraScreen() {
    return Container(
      width: maxW,
      height: maxH - 60 - (maxW / 2),
      color: Colors.black,
      child: CameraAwesome(
        testMode: false,
        //onPermissionsResult: (bool result) {},
        selectDefaultSize: (List<Size> availableSizes) {
          this.availableSizes = availableSizes;
          return availableSizes[0];
          //return Size(1280, 720);
        },
        //onCameraStarted: () {},
        onOrientationChanged: _onOrientationChange,
        zoom: _zoomNotifier,
        sensor: _sensor,
        photoSize: _photoSize,
        switchFlashMode: _switchFlash,
        captureMode: _captureMode,

        orientation: DeviceOrientation.portraitUp,
        //fitted: true,
      ),
    );
  }

  _onOrientationChange(CameraOrientations newOrientation) {
    newOrientation = CameraOrientations.PORTRAIT_UP;
    if (newOrientation == CameraOrientations.LANDSCAPE_LEFT) {
      print("lefttttttttttttttttttttttttttttttttttttttt");
    } else {
      print("sometilgljlkjsdl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
    }
    if (_previewDismissTimer != null) {
      _previewDismissTimer.cancel();
    }
  }

  Timer _previewDismissTimer;

  _bottomBar() {
    return Container(
        height: maxW / 2,
        width: maxW,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
//---------------------------FlashButton--------------------------------------------------------------------//
                Container(
                  width: maxW / 3,
                  height: maxW / 3,
                  child: Center(
                    child: IconButton(
                        onPressed: () {
                          if (_switchFlash.value == CameraFlashes.NONE) {
                            _switchFlash.value = CameraFlashes.ON;
                            setState(() {});
                          } else {
                            _switchFlash.value = CameraFlashes.NONE;
                            setState(() {});
                          }
                        },
                        icon: _switchFlash.value == CameraFlashes.ON
                            ? Icon(
                                Icons.flash_on,
                                color: Colors.blueAccent,
                                size: 30,
                              )
                            : Icon(Icons.flash_off)),
                  ),
                ),
//------------------------CaptureButton--------------------------------------------------------------------//

                Container(
                    width: maxW / 3,
                    height: maxW / 3,
                    child: Center(
                      child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(35),
                              ),
                              border:
                                  Border.all(color: Colors.black, width: 4)),
                          child: Center(
                              child: GestureDetector(
                                  onTap: () {
                                    _capture();
                                  },
                                  child: Center(
                                      child: Icon(
                                    Icons.camera,
                                    size: 60,
                                    color: Colors.black,
                                  ))))),
                    )),
//-------------------------------------Last Image--------------------------------------------------------------//
                Container(
                  width: maxW / 3,
                  height: maxW / 3,
                  color: Colors.white,
                  child: Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.black,
                          child: _cameraBloc.selectedImageList.isEmpty
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        (context),
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Slide("camera", _cameraBloc)));
                                  },
                                  child: Image.file(
                                    File(_cameraBloc.selectedImageList[
                                        _cameraBloc.selectedImageList.length -
                                            1]),
                                    fit: BoxFit.cover,
                                  )))),
                )
              ],
            ),
          ],
        ));
  }

  _capture() async {
    Directory ext = await getTemporaryDirectory();
    String path = '${ext.path}${DateTime.now()}';
    print("captured ");
    await _pictureController.takePicture(path);
    final result =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageCheck(path, _cameraBloc);
    }));

    if (await result) {
      setState(() {});
    }
  }
}
