import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lens/Screens/Home/Home.dart';
import 'package:lens/Screens/ImageCheck/imageEditModified.dart';
import 'package:lens/Utils/plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

//import 'home.dart';

List<String> selectedImageList = List<String>();
List<String> procImg = List<String>();

class Slide extends StatefulWidget {
  final sender;
  final cameraBloc;
  Slide(this.sender, this.cameraBloc);
  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  bool processing = false;
  bool pdfProcessing = false;
  bool save = false;
  String pdfFileName = "${DateTime.now()}";
  Future<void> autoCropper(List<String> imList) async {
    if (widget.sender == "gallary") {
      for (int i = 0; i <= (imList.length - 1); i++) {
        String im = await Plugin.autoCrop(imList[i]);
        widget.cameraBloc.currentProcessingImg.add(im);
        print("loooooooooop run $i $imList");
      }
    }
    print("runned after 5 seconds");

    processing = false;
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => autoCropper(widget.cameraBloc.selectedImageList));
  }

  String img = '';
  int current = 0;
  double maxW, maxH;
  TextEditingController fileName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    maxW = MediaQuery.of(context).size.width;
    maxW = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () {
          exitAlert(context);
        },
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            //appBar: appBarNameEdit(),
            body: Column(
              children: [
                appBarNameEdit(),
                Expanded(
                  child: Center(child: !save ? pageView() : proc()),
                ),
                _bottomBar(),
              ],
            )));
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
                      widget.cameraBloc.currentProcessingImg.clear();
                      widget.cameraBloc.selectedImageList.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    })
              ]);
        });
  }

  appBarNameEdit() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 5.0, spreadRadius: 5.0)
        ]),
        height: 70,
        child: Center(
          child: Container(
              height: 40,
              child: TextField(
                  controller: fileName,
                  decoration: InputDecoration(
                    labelText: "$pdfFileName",
                    suffixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ))),
        ),
      ),
    );
  }

  Widget pageView() {
    return processing
        ? CircularProgressIndicator(
            backgroundColor: Colors.purple,
          )
        : PageView.builder(
            itemCount: widget.cameraBloc.currentProcessingImg.length ?? 0,
            itemBuilder: (context, i) {
              img = widget.cameraBloc.currentProcessingImg[i];
              current = i;
              print(current);

              return InteractiveViewer(
                child: ImageView(img),
              );
            });
  }

  void rotater() async {
    Directory temPath = await getTemporaryDirectory();
    String newFilePath = "${temPath.path}/${DateTime.now()}.jpg";
    final resultimg = await FlutterImageCompress.compressAndGetFile(
      widget.cameraBloc.currentProcessingImg[current],
      newFilePath,
      rotate: 90,
    );
    widget.cameraBloc.currentProcessingImg[current] = resultimg.path;
    setState(() {});
  }

  Widget _bottomBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(offset: Offset(3, 3), blurRadius: 5.0, spreadRadius: 5.0)
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: Icon(Icons.crop),
              onPressed: () async {
                imageEditPush(context);
              }),
          IconButton(
              icon: Icon(Icons.note_add),
              onPressed: () {
                _addFileAlerDialog();
              }),
          //remove Image feature
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                int delIndex = current;
                setState(() {
                  if (current != 0) {
                    current = 0;
                  } else {
                    Navigator.pop(context);
                    widget.cameraBloc.currentProcessingImg.clear();
                  }
                  widget.cameraBloc.currentProcessingImg.removeAt(delIndex);
                });
              }),
          //save as image
          IconButton(
              icon: Icon(Icons.photo),
              onPressed: () async {
                File image1 =
                    File(widget.cameraBloc.currentProcessingImg[current]);
                String pocket = _internalPath();
                image1.copy("$pocket/${DateTime.now()}.jpg");
                print("image saved successfully");
                showSnackBar(context);
                //_showSnackBar("Image saved successfully", context);
              }),
          //Rotating Image
          IconButton(
              icon: Icon(Icons.rotate_right),
              onPressed: () {
                //imgScreenRefresh = true;
                rotater();
              }),

          IconButton(
              icon: Icon(Icons.done_all, color: Colors.blueAccent),
              onPressed: () async {
                _processing(context);
                await Future.delayed(Duration(milliseconds: 500));
                pdfCreator();
              }),
        ],
      ),
    );
  }

  _backToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
    print("Pdf created successfully .........................");
    widget.cameraBloc.currentProcessingImg.clear();
    widget.cameraBloc.selectedImageList.clear();
  }

  proc() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Pdf creation is in progress"),
              content: FutureBuilder(
                  future: pdfCreator(),
                  builder: (context, sp) {
                    if (sp.connectionState == ConnectionState.done) {
                      return Container();
                    } else {
                      return Container(
                        height: 100,
                        width: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.purple),
                        ),
                      );
                    }
                  }));
        });
  }

  showSnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text("yaylhjhkhjh"));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _internalPath() async {
    Directory internal = await getExternalStorageDirectory();
    var a = internal.path.split("Android")[0];
    String internalPath = a + "PocketLens";
    print(internalPath);
    if (await internal.exists()) {
      print("directory exists");
      return internalPath;
    } else {
      await Directory(internalPath).create(recursive: true);
      return internalPath;
    }
  }

  Future<void> pdfCreator() async {
    _processing(context);
    setState(() {});
    final doc = pw.Document();
    for (int i = 0;
        i < widget.cameraBloc.currentProcessingImg.length - 1;
        i++) {
      final image = pw.MemoryImage(
        File(widget.cameraBloc.currentProcessingImg[i]).readAsBytesSync(),
      );
      //final image = ImageProvider(); //Image.file(File(imgList[i]));
      doc.addPage(
        pw.Page(
            margin: pw.EdgeInsets.all(10),
            build: (pw.Context context) => pw.Column(
                  children: <pw.Widget>[
                    pw.Expanded(
                        child: pw.Container(
                            child: pw.Center(child: pw.Image(image)))),
                    pw.Container(
                        child: pw.Header(

                            // padding: pw.EdgeInsets.all(5),
                            level: 4,
                            child: pw.Center(
                                child: pw.Text(
                              "crafted with love by ak",
                            ))))
                  ],
                )),
      );
    }
    try {
      fileName.text == ""
          ? print("fileName is empty")
          : pdfFileName = fileName.text;
      String internalPath = await _internalPath();
      final file = File('$internalPath/$pdfFileName.pdf');
      file.writeAsBytesSync(await doc.save());

      print("pdf saved successfullly");
      _backToHome();
    } on IOException catch (e) {
      print(e);
    }
  }

  imageEditPush(context) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageEdit(
                  img: widget.cameraBloc.selectedImageList[current],
                  i: current,
                  cameraBloc: widget.cameraBloc,
                )));

    if (result) {
      setState(() {});
      result = false;
    }
  }

  _processing(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Pdf creation is in progress"),
              content: Container(
                height: 100,
                width: 200,
                child: Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.purple),
                ),
              ));
        }).then((e) {
      pdfCreator();
    });
  }

  _addFileAlerDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.lightBlueAccent.withOpacity(0.9),
              contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              actionsOverflowButtonSpacing: 40,
              elevation: 5,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                      onPressed: null, child: Icon(Icons.camera)),
                  FloatingActionButton(
                      onPressed: null, child: Icon(Icons.image)),
                ],
              ),
              title: Center(
                child: Text("Choose"),
              ));
        });
  }
}

class ImageView extends StatefulWidget {
  String img;
  ImageView(this.img);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(20, 20),
            spreadRadius: 10,
            blurRadius: 20,
          )
        ]),
        child: Image.file(File(widget.img)));
  }
}
