import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'bulk.dart';

//import 'package:image_feature_detector/image_feature_detector.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lens/Bloc/CameraBloc.dart';
import 'dart:async';

import 'dart:io';
import 'dart:ui';

import 'package:lens/Utils/cropper.dart';
import 'package:lens/Utils/plugin.dart';

class ImageEdit extends StatefulWidget {
  final img;
  final i;
  final cameraBloc;
  ImageEdit({this.img, this.i, this.cameraBloc});
  @override
  _ImageEdit createState() => _ImageEdit();
}

class _ImageEdit extends State<ImageEdit> {
  @override
  initState() {
    super.initState();
    getContours(widget.img);
  }

  static double maxH, maxW;
  /*x1 = 0,
      y1 = 0,
      x2 = maxW - 50,
      y2 = 0,
      x3 = maxW - 50,
      y3 = maxH - 150,
      x4 = 0,
      y4 = maxH - 150; */
  @override
  Widget build(BuildContext context) {
    maxH = MediaQuery.of(context).size.height;
    maxW = MediaQuery.of(context).size.width;
    return Container(
      height: maxH,
      width: maxW,
      color: Colors.white,
      child: Column(children: [
        SizedBox(height: 25),
        Cropper(widget.img),
        //-----------------------------Editer Container-----------------------//
/*        Container(
          height: maxH - 100,
          width: maxW,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.amberAccent.withOpacity(0.2)])),
          child: Center(
            child: Container(
              height: maxH - 130,
              width: maxW - 30,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: maxH - 130,
                    width: maxW - 30,
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Container(
                        //image or background
                        height: maxH - 170,
                        width: maxW - 70,
                        color: Colors.deepPurpleAccent,
                        child: Image.file(
                          File(widget.img),
                          fit: BoxFit.fill,
                        )),
                  ),
                  CustomPaint(
                    painter: Polygon(
                      x1: x1,
                      y1: y1,
                      x2: x2,
                      y2: y2,
                      x3: x3,
                      y3: y3,
                      x4: x4,
                      y4: y4,
                      x5: x1,
                      y5: y1,
                    ),
                  ),
                  Positioned(
//--------------Point 1------------------------//
                    top: y1 - 20,
                    left: x1 - 20,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          x1 += x1 >= 20 && x1 <= maxW - 50 ? d.delta.dx : 0;
                          x1 = x1 < 20 ? 20 : x1;
                          x1 = x1 > maxW - 50 ? maxW - 50 : x1;
                          y1 += y1 >= 20 && y1 <= maxH - 150 ? d.delta.dy : 0;
                          y1 = y1 < 20 ? 20 : y1;
                          y1 = y1 > (maxH - 150) ? maxH - 150 : y1;
                          print("Point 1 $x1 : $y1");
                        });

                        //print(Image.file(widget.img).height);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.lightBlueAccent,
                              width: 3,
                            ),
                            color: Colors.white),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
//-----------------------------------topMiddle------------------//
            Positioned(
              top: (y1+y2)/2 - 10,
              left: (x1+x2)/2 - 10,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    //x1 += x1 >= 20 && x1 <= maxW - 50 ? d.delta.dx : 0;
                    //x1 = x1 < 20 ? 20 : x1;
                    //x1 = x1 > maxW - 50 ? maxW - 50 : x1;
                    y1 += y1 >= 20 && y1 <= maxH - 150 ? d.delta.dy : 0;
                    y1 = y1 < 20 ? 20 : y1;
                    y1 = y1 > (maxH - 150) ? maxH - 150 : y1;
                    y2 += y2 >= 20 && y2 <= maxH - 150 ? d.delta.dy : 0;
                    y2 = y2 < 20 ? 20 : y2;
                    y2 = y2 > (maxH - 150) ? maxH - 150 : y2;
                    print("Point 1 $y2 : $y1");
                  });

                  //print(Image.file(widget.img).height);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.lightBlueAccent,
                        width: 3,
                      ),
                      color: Colors.white),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
                  Positioned(
//--------------Point 2------------------------//
                    top: y2 - 20,
                    left: x2 - 20,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          x2 += x2 >= 20 && x2 <= maxW - 50 ? d.delta.dx : 0;
                          x2 = x2 < 20 ? 20 : x2;
                          x2 = x2 > maxW - 50 ? maxW - 50 : x2;
                          y2 += y2 >= 20 && y2 <= maxH - 150 ? d.delta.dy : 0;
                          y2 = y2 < 20 ? 20 : y2;
                          y2 = y2 > (maxH - 150) ? maxH - 150 : y2;
                        });
                        print("Point 2 $x2 : $y2");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.lightBlueAccent,
                              width: 3,
                            ),
                            color: Colors.white),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
//-----------------------------------RightMiddle------------------//
            Positioned(
              top: (y2+y3)/2 - 10,
              left: (x2+x3)/2 - 10,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    x2 += x2 >= 20 && x2 <= maxW - 50 ? d.delta.dx : 0;
                    x2 = x2 < 20 ? 20 : x2;
                    x2 = x2 > maxW - 50 ? maxW - 50 : x2;
                    x3 += x3 >= 20 && x3 <= maxW - 50 ? d.delta.dx : 0;
                    x3 = x3 < 20 ? 20 : x3;
                    x3 = x3 > maxW - 50 ? maxW - 50 : x3;
                    //y2 += y2 >= 20 && y2 <= maxH - 150 ? d.delta.dy : 0;
                    //y2 = y2 < 20 ? 20 : y2;
                    //y2 = y2 > (maxH - 150) ? maxH - 150 : y2;
                    //y3 += y3 >= 20 && y3 <= maxH - 150 ? d.delta.dy : 0;
                    //y3 = y3 < 20 ? 20 : y3;
                    //y3 = y3 > (maxH - 150) ? maxH - 150 : y3;
                    print("Point 1 $y2 : $y1");
                  });

                  //print(Image.file(widget.img).height);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.lightBlueAccent,
                        width: 3,
                      ),
                      color: Colors.white),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
                  Positioned(
//--------------Point 3------------------------//
                    top: y3 - 20,
                    left: x3 - 20,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          x3 += x3 >= 20 && x1 <= maxW - 50 ? d.delta.dx : 0;
                          x3 = x3 < 20 ? 20 : x3;
                          x3 = x3 > maxW - 50 ? maxW - 50 : x3;
                          y3 += y3 >= 20 && y3 <= maxH - 150 ? d.delta.dy : 0;
                          y3 = y3 < 20 ? 20 : y3;
                          y3 = y3 > (maxH - 150) ? maxH - 150 : y3;
                        });
                        print("Point 3 $x3 : $y3");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.lightBlueAccent,
                              width: 3,
                            ),
                            color: Colors.white),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
//-----------------------------------bottomMiddle------------------//
            Positioned(
              top: (y3+y4)/2 - 10,
              left: (x3+x4)/2 - 10,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    //x1 += x1 >= 20 && x1 <= maxW - 50 ? d.delta.dx : 0;
                    //x1 = x1 < 20 ? 20 : x1;
                    //x1 = x1 > maxW - 50 ? maxW - 50 : x1;
                    y4 += y4 >= 20 && y4 <= maxH - 150 ? d.delta.dy : 0;
                    y4 = y4 < 20 ? 20 : y4;
                    y4 = y4 > (maxH - 150) ? maxH - 150 : y4;
                    y3 += y3 >= 20 && y3 <= maxH - 150 ? d.delta.dy : 0;
                    y3 = y3 < 20 ? 20 : y3;
                    y3 = y3 > (maxH - 150) ? maxH - 150 : y3;
                    print("Point 1 $y2 : $y1");
                  });

                  //print(Image.file(widget.img).height);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.lightBlueAccent,
                        width: 3,
                      ),
                      color: Colors.white),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
                  Positioned(
//--------------Point 4------------------------//
                    top: y4 - 20,
                    left: x4 - 20,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          x4 += x4 >= 20 && x4 <= maxW - 50 ? d.delta.dx : 0;
                          x4 = x4 < 20 ? 20 : x4;
                          x4 = x4 > maxW - 50 ? maxW - 50 : x4;
                          y4 += y4 >= 20 && y4 <= maxH - 150 ? d.delta.dy : 0;
                          y4 = y4 < 20 ? 20 : y4;
                          y4 = y4 > (maxH - 150) ? maxH - 150 : y4;
                        });
                        print("Point 4 $x4 : $y4");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.lightBlueAccent,
                              width: 3,
                            ),
                            color: Colors.white),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
//-----------------------------------LeftMiddle------------------//
            Positioned(
              top: (y1+y4)/2 - 10,
              left: (x1+x4)/2 - 10,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    x1 += x1 >= 20 && x1 <= maxW - 50 ? d.delta.dx : 0;
                    x1 = x1 < 20 ? 20 : x1;
                    x1 = x1 > maxW - 50 ? maxW - 50 : x1;
                    x4 += x4 >= 20 && x4 <= maxW - 50 ? d.delta.dx : 0;
                    x4 = x4 < 20 ? 20 : x4;
                    x4 = x4 > maxW - 50 ? maxW - 50 : x4;
                    //y2 += y2 >= 20 && y2 <= maxH - 150 ? d.delta.dy : 0;
                    //y2 = y2 < 20 ? 20 : y2;
                    //y2 = y2 > (maxH - 150) ? maxH - 150 : y2;
                    //y3 += y3 >= 20 && y3 <= maxH - 150 ? d.delta.dy : 0;
                    //y3 = y3 < 20 ? 20 : y3;
                    //y3 = y3 > (maxH - 150) ? maxH - 150 : y3;
                    print("Point 1 $y2 : $y1");
                  });

                  //print(Image.file(widget.img).height);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.lightBlueAccent,
                        width: 3,
                      ),
                      color: Colors.white),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
                ],
              ),
            ),
          ),
        ),
        */
//-------------------------Edit bottomBar container ---------------------------------------------------------//
        Container(
          width: maxW,
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //No Crop
              Container(
                  height: 60,
                  width: 60,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        x1 = 20;
                        y1 = 20;
                        x2 = maxW - 50;
                        y2 = 20;
                        x3 = maxW - 50;
                        y3 = maxH - 150;
                        x4 = 20;
                        y4 = maxH - 150;
                      });
                    },
                    child: Icon(
                      Icons.maximize,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                  )),
              //Done
              Container(
                  height: 60,
                  width: 60,
                  child: GestureDetector(
                    onTap: () async {
                      List<double> cLIst = [
                        (x1 - 20) / (maxW - 70),
                        (y1 - 20) / (maxH - 170),
                        (x2 - 20) / (maxW - 70),
                        (y2 - 20) / (maxH - 170),
                        (x3 - 20) / (maxW - 70),
                        (y3 - 20) / (maxH - 170),
                        (x4 - 20) / (maxW - 70),
                        (y4 - 20) / (maxH - 170)
                      ];
                      String onlyWarped =
                          await Plugin.customWarp(widget.img, cLIst, true);

                      setState(() {
                        widget.cameraBloc.currentProcessingImg[widget.i] = onlyWarped;
                      });
                      print(
                          ")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))");
                      Navigator.pop(context, true);
                    },
                    child: Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.blueAccent,
                    ),
                  )),
            ],
          ),
        )
      ]),
    );
  }

  Future getContours(String imgPath) async {
    try {
      var imageContours = await Plugin.foundVertices(imgPath);
      //var imgContor = json.decode(imageContours);
      print("$imgPath");
      for (int i = 0; i <= 3; i++) {
        print("X: ${imageContours[0].x}");
        print("Y: ${imageContours[0].y}");
      }
      setState(() {
        x1 = (imageContours[0].x * (maxW - 70)) + 20;
        y1 = (imageContours[0].y * (maxH - 170)) + 20;
        x2 = (imageContours[1].x * (maxW - 70)) + 20;
        y2 = (imageContours[1].y * (maxH - 170)) + 20;
        x3 = (imageContours[2].x * (maxW - 70)) + 20;
        y3 = (imageContours[2].y * (maxH - 170)) + 20;
        x4 = (imageContours[3].x * (maxW - 70)) + 20;
        y4 = (imageContours[3].y * (maxH - 170)) + 20;
      });
    } on PlatformException {
      print("Platform exception");
    }
  }
}

class Polygon extends CustomPainter {
  double x1, y1, x2, y2, x3, y3, x4, y4, x5, y5;
  Polygon(
      {this.x1,
      this.y1,
      this.x2,
      this.y2,
      this.x3,
      this.y3,
      this.x4,
      this.y4,
      this.x5,
      this.y5});
  Paint polygon = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.square
    ..strokeWidth = 5;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final points = <Offset>[
      Offset(x1, y1),
      Offset(x2, y2),
      Offset(x3, y3),
      Offset(x4, y4),
      Offset(x5, y5)
    ];
    canvas.drawPoints(PointMode.polygon, points, polygon);
  }

  bool shouldRepaint(oldDelagate) => true;
}

/*
Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: (){
              setState(() {
                      x1 = 20;
                      y1 = 20;
                      x2 = maxW - 50;
                      y2 = 20;
                      x3 = maxW - 50;
                      y3 = maxH - 150;
                      x4 = 20;
                      y4 = maxH - 150;
                    });
            },
            icon: Icon(FeatherIcons.maximize, color: Colors.blue[300],)
          ),
          IconButton(
            onPressed: () async{
              List<double> cLIst = [
                    (x1 - 20) / (maxW - 70),
                    (y1 - 20) / (maxH - 170),
                    (x2 - 20) / (maxW - 70),
                    (y2 - 20) / (maxH - 170),
                    (x3 - 20) / (maxW - 70),
                    (y3 - 20) / (maxH - 170),
                    (x4 - 20) / (maxW - 70),
                    (y4 - 20) / (maxH - 170)
                  ];
                  String onlyWarped =
                      await Plugin.customWarp(widget.img, cLIst);

                  setState(() {
                    imgList[widget.i] = onlyWarped;
                  });
                  print(
                      ")))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))");
                  Navigator.pop(context, true);
            },
            icon: Icon(FeatherIcons.checkSquare, color: Colors.blue[300],)
          )
      ],)
 * 
 * 
 */
