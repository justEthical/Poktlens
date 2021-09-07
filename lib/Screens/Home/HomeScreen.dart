import 'package:flutter/material.dart';
import 'package:lens/Bloc/HomeScreenBloc.dart';
import 'package:lens/Utils/FileSystemUtils.dart';
import 'package:lens/Screens/PdfViewer/PdfViewer.dart';
import 'package:thumbnailer/thumbnailer.dart';

import '../../Test.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenBloc homeBloc;
  final FileSystemUtils fileSys;
  HomeScreen(this.homeBloc, this.fileSys);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //FileSystemUtils _fileSystemUtils = new FileSystemUtils();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _topBar(),
          //Center(child: Card(child: ListTile(title: Text("${widget.fileSys.pdfFiles[0]}")),),)
          _listOfPdfCreated()
        ],
      ),
    );
  }

  _listOfPdfCreated() {
    return FutureBuilder(
        future: widget.fileSys.checkExistingPdf(),
        builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (widget.fileSys.pdfFiles.isEmpty) {
                return Center(
                  child: Text("There is no pdf Created yet"),
                );
              } else {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: widget.fileSys.pdfFiles.length ?? 0,
                          itemBuilder: (ctx, i) {
                            return Card(
                                margin: EdgeInsets.only(right: 15, left: 15),
                                elevation: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => PdfViewer(
                                                widget.fileSys.pdfFiles[i])));
                                  },
                                  child: ListTile(
                                      title: Expanded(
                                    child:
                                        Text(" ${widget.fileSys.fileName(i)}"),
                                  )),
                                ));
                          })),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue));
            }
          }
        );
  }

  // _oldList(){
  //   return Container(
  //                 height: maxH - (2.5 * (maxH / 9)),
  //                 width: MediaQuery.of(context).size.width,
  //                 child: ListView.builder(
  //                     itemCount: pdfFiles.length == null ? 0 : pdfFiles.length,
  //                     itemBuilder: (context, i) {
  //                       print("Something run 00000000000000000000000000 $i");
  //                       return Card(
  //                           elevation: 5,
  //                           child: Container(
  //                               height: 75,
  //                               child: ListTile(
  //                                   onTap: () {
  //                                     Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                             builder: (context) =>
  //                                                 PDFView(pdfFiles[i].path)));
  //                                   },
  //                                   contentPadding: EdgeInsets.only(
  //                                       top: 5, left: 7, right: 7),
  //                                   leading: Icon(Icons.picture_as_pdf,
  //                                       color: Colors.red),
  //                                   title: Text(_fileName(i)),
  //                                   trailing: Icon(Icons.share))));
  //                     }))
  // }

  _topBar() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                elevation: 5,
                child: IconButton(
                    onPressed: () {
                      widget.homeBloc.drawerSwitch();
                    },
                    icon: Icon(Icons.menu)),
              ),
              Card(
                  elevation: 5,
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.search)))
            ],
          ),
        ),
      ),
    );
  }
}
