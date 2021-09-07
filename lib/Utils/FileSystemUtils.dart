import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class FileSystemUtils {
  List<File> pdfFiles = List<File>();

  Future<List<File>> _filteringPdfFiles(List<FileSystemEntity> files) async {
    List<File> pdfFiles = List<File>();
    
    for (FileSystemEntity f in files) {
      var mimeType = lookupMimeType(f.path);
      var typ = mimeType != null ? mimeType.split("/") : null;

      print(typ);
      if (typ != null) {
        var fileType = typ[typ.length - 1];
        print(f.path);
        fileType == "pdf" ? pdfFiles.add(f) : print("not an pdf file nothing");
      }
    }
    pdfFiles.sort((a, b) {
      return b.path.compareTo(a.path);
    });

    return pdfFiles;
  }

  Future<List<File>> _pdfFileCheck() async {
    Directory extdir = await getExternalStorageDirectory();
    var a = extdir.path.split("Android")[0];
    print(a);
    final Directory pocketLens = Directory("$a/PocketLens");
    // print(pocketLens.path);
    if (await pocketLens.exists()) {
      print("directory exists");
      List<FileSystemEntity> allFiles = pocketLens.listSync();
      List<File> tempPdf = await _filteringPdfFiles(allFiles);
      //print("fffffffffffffffffffffffffff ${tempPdf[0]}");
      return tempPdf;
    } else {
      print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
      await pocketLens.create(recursive: true);
      return null;
    }
  }

  String fileName(itemNumber) {
    List<String> name = pdfFiles[itemNumber].path.split("/");
    String fileName = name[name.length - 1];
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^$fileName");
    return fileName;
  }

  Future<void> checkExistingPdf() async {
    pdfFiles = await _pdfFileCheck();
  }
}
