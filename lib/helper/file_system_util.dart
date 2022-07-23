import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' show parse;

/*
Handle file system operations
 */
class FileSystemUtil {
  final String appDir = 'nl_health_app_storage';

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  Future<Directory> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  /*
  Create or get the current main app storage dir
   */
  Future<String> get localDocumentsPath async {
    var directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "/$appDir";
    print(">>> $path");
    if (await Directory(path).exists()) {
      return path;
    } else {
      //FileUtils.mkdir([path],recursive: true);
      await directory.create(recursive: true);
      return path;
    }
  }

  Future<String> get extDownloadsPath async {
    String path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS) +
        "/$appDir";
    //print(">>> Ext Download $path");

    if (await File(path).exists()) {
      return path;
    } else {
      await Directory(path).create(recursive: true);
      //FileUtils.mkdir([path],recursive: true);
      return path;
    }
  }

  Future<bool> checkFilePresent(String path) async {
    if (await File(path).exists()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkDirectoryOrCreate(String path) async {
    var folder = Directory(path);
    if (await folder.exists()) {
      return true;
    } else {
      var directory = await folder.create(recursive: true);
      return directory.exists();
    }
  }

  Future<File> get localAppFolder async {
    final path = await localPath;
    print(path.parent.path);
    return File('${path.path}/$appDir');
  }

  Future<String> readFileContentFile(String path) async {
    try {
      final storageDirectory = await localDocumentsPath;
      final filePath = '$storageDirectory$path';
      print("Read file path ->$filePath");
      final file = File(filePath);
      String body = await file.readAsString();
      //body = await this.parseProcessHtml(body);
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> readFileContentLink(String url) async {
    return "Read Content";
    // try {
    //   print(">> URL " + url);
    //   var response = await OpenApi().readHtmlTxt(url);
    //   return response.body;
    // } catch (e) {
    //   return e.toString();
    // }
  }

  Future<File?> writeFile(String data) async {
    try {
      final file = await localAppFolder;
      return file.writeAsString(data);
    } catch (e) {
      return null;
    }
  }

  Future<String> parseProcessHtml(String body) async {
    try {
      final storageDirectory = await localDocumentsPath;
      var document = parse(body);
      var videosList = document.getElementsByTagName("video");
      var sourceElm = videosList.removeAt(0).getElementsByTagName('source');
      sourceElm.first.attributes['src'] = '$storageDirectory/2/' +
          sourceElm.first.attributeSpans!['src'].toString();

      print(sourceElm.first.attributes['src']);
      return document.outerHtml;
    } catch (e) {
      print("error reading html$e");
      return body;
    }
  }

  Future<File> getLocalFile(String filename) async {
    String dir = await FileSystemUtil().extDownloadsPath + "/HE Health";
    File f = File('$dir$filename');
    return f;
  }
//file

}

/// Load images from file system as bytes
Future<Image?> _loadThumb(BuildContext context, File imgFile,
    [double? w, double? h]) async {
  try {
    // read image
    //List<int> thumbInts = await imgFile.readAsBytes();
//    ByteBuffer buffer = Uint8List.fromList(thumbInts).buffer;
//    ByteData byteData = new ByteData.view(buffer);
    var uint8list = await _readFileBytep(imgFile.path);

    var _imageThumbView = Image.memory(
      uint8list,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      scale: 1.0,
      filterQuality: FilterQuality.low,
      height: h,
      width: w ?? MediaQuery.of(context).size.width * .90,
    );
    return _imageThumbView;
  } catch (e) {
    return null;
  }
}

// Widget? fileImageBuilder(BuildContext context, File imageFilePath, [double? w, double? h]) {
//   try{
//     return new FutureBuilder(
//         future: _loadThumb(context, imageFilePath, w, h),
//         builder: (BuildContext context, AsyncSnapshot<Image> image) {
//           if (image.hasData) {
//             return image.data; // image is ready
//           } else {
//             return new Center(
//               child: new Container(),
//             );
//           }
//         });
//   }catch(e){
//     return null;
//   }
// }

//new stuff
Future<Uint8List> _readFileBytep(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = new File.fromUri(myUri);
  late Uint8List bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is completed');
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
}

Future<String?> fileToBase64String(String myPath) async {
  try {
    Uint8List audioByte = await _readFileBytep(myPath);
    String audioString = base64.encode(audioByte);
    return audioString;
  } catch (e) {
    // if path invalid or not able to read
    print(e);
    return null;
  }
}

Future<PermissionStatus> requestPermission(Permission permission) async {
  final status = await permission.request();
  return status;
}

Future<void> createDownloadFile() async {
  PermissionStatus checkPermission1 = await Permission.storage.status;
  // print(checkPermission1);
  if (checkPermission1.isGranted == false) {
    await requestPermission(Permission.storage);
  }
  if (checkPermission1.isGranted == true) {
    String dirloc = "";
    if (Platform.isAndroid) {
      //dirloc = await FileSystemUtil().extDownloadsPath + "/HE Health/";
      dirloc = await FileSystemUtil().extDownloadsPath;
      //print("Download path $dirloc");
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }
    try {
      bool exists = await Directory(dirloc).exists();
      // if (!exists) {
      //   FileUtils.mkdir([dirloc]);
      // } else {
      //
      // }
    } catch (e) {
      print(e);
    }
  }
}
