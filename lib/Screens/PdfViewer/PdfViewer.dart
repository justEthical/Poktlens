import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class PdfViewer extends StatefulWidget {
  final pdfFile;
  PdfViewer(this.pdfFile);
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var children2 = [
      Container(
        height: 80,
        child: SafeArea(
            child: Container(
          color: Colors.blueAccent,
          child: Center(
              child: Text(
            "PdfVeiwer",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
        )),
      ),
      PDF.file(
        widget.pdfFile,
        width: w,
        height: h - 80,
      ),
    ];
    return Scaffold(
      body: Column(
        children: children2,
      ),
    );
  }
}
