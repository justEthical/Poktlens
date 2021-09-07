import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lens/Bloc/HomeScreenBloc.dart';
import 'package:lens/Utils/FileSystemUtils.dart';
import 'package:lens/Screens/CameraScreen/CameraScreen.dart';
import 'package:lens/Screens/Home/CustomDrawer.dart';
import 'package:lens/Screens/Home/HomeScreen.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeScreenBloc bloc = HomeScreenBloc();
  FileSystemUtils fileSystemUtils = FileSystemUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _takingPermissions();
  }

  @override
  Widget build(BuildContext context) {
    //-----For Vertical Orientation ----------->
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //-----For MaxWidth and MaxHeight----------->
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      color: Colors.white,
      child: WillPopScope(
        onWillPop: () {
          bloc.drawerOpen ? bloc.drawerSwitch() : _exitAlertHome();
        },
        //---------Container for drawer and HomeScreen -------------->
        child: Container(
            child: StreamBuilder<double>(
                stream: bloc.drawerStream,
                builder: (context, snapshot) {
                  print("${snapshot.data}");
                  return Stack(
                    children: [
                      Container(
                        width: w,
                        color: Colors.amberAccent,
                      ),
                      //-----HomeScreen container----------->
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        transform:
                            Matrix4.translationValues(snapshot.data ?? 0, 0, 0),
                        child: HomeScreen(bloc, fileSystemUtils),
                      ),
                      //-----HomeScreen dark on Drawer Open ------------------>
                      Visibility(
                        visible: bloc.drawerOpen,
                        child: BackdropFilter(
                            filter: ImageFilter.blur(),
                            child: GestureDetector(
                              onTap: () {
                                bloc.drawerSwitch();
                              },
                              child: Container(
                                  color: Colors.black12.withOpacity(0.5)),
                            )),
                      ),
                      //------FloatingActionButton--------------------->
                      _floatingActionButton(),
                      //------CustomDrawer----------------------------->
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        transform: Matrix4.translationValues(
                            -250.0 + (snapshot.data ?? 0), 0, 0),
                        child: CustomDrawer(snapshot),
                      ),
                    ],
                  );
                })),
      ),
    );
  }

//-----------Floating action Button------------------------------->
  _floatingActionButton() {
    return Positioned(
        bottom: 25,
        right: 20,
        child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blueAccent,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2, 3),
                      spreadRadius: 5,
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.2))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => CameraScreen()));
                      },
                      child: Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                    )),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white,
                ),
                Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(Icons.photo_rounded, color: Colors.white))
              ],
            )));
  }

//-----------Function for Exit Alert Box--------------------------->
  _exitAlertHome() {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black),
            ),
            title: Text("EXIT"),
            content: Text("Are you sure want to exit?"),
            actions: [
              RaisedButton(
                child: Text("OK"),
                onPressed: () => exit(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
              )
            ],
          );
        });
  }

//---Taking Permissions-------------------------------------->
  void _takingPermissions() async {
    await _storagePermission();
    await _cameraPermission();
  }

//----Function for Camera Permission------------------------->
  _cameraPermission() async {
    Permission p = Permission.camera;
    bool ps = await p.isGranted;
    if (!ps) {
      p.request();
    }
    print("$ps rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
  }

//------Function for Storage Permission----------------------->
  _storagePermission() async {
    Permission p = Permission.storage;
    bool ps = await p.isGranted;
    if (ps) {
      fileSystemUtils.checkExistingPdf();
    } else {
      await p.request();
      fileSystemUtils.checkExistingPdf();
    }
  }
}
