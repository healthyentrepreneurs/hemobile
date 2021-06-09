import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:file_utils/file_utils.dart';
import 'dart:math';

class FileDownloader extends StatefulWidget {
  final FileSystemUtil fileSystemUtil;

  const FileDownloader({Key key, this.fileSystemUtil}) : super(key: key);

  @override
  _FileDownloaderState createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  final imgUrl =
      "https://www.evertop.pl/wp-content/uploads/1-i671WU-ZNgP7Y1VsTXstHQ.png";
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  Permission permission1 = Permission.storage;
  var _onPressed;
  static final Random random = Random();
  Directory externalDir;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    PermissionStatus checkPermission1 = await permission1.status;

    // print(checkPermission1);
    if (checkPermission1.isGranted == false) {
      await requestPermission(permission1);
    }

    if (checkPermission1.isGranted == true) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = (await widget.fileSystemUtil.localDocumentsPath) + "/";
        print("Download path $dirloc");
        //dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      //var randid = random.nextInt(10000);
      var randid = random.nextInt(10000);

      try {
        FileUtils.mkdir([dirloc]);
        await dio.download(imgUrl, dirloc + randid.toString() + ".jpg",
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress =
                ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        progress = "Download Completed.";
        path = dirloc + randid.toString() + ".jpg";
      });
    } else {
      setState(() {
        progress = "Permission Denied!";
        _onPressed = () {
          downloadFile();
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('File Downloader'),
      ),
      body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Downloading File: $progress',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(path),
                    MaterialButton(
                      child: Text('Request Permission Again.'),
                      onPressed: _onPressed,
                      disabledColor: Colors.blueGrey,
                      color: Colors.pink,
                      textColor: Colors.white,
                      height: 40.0,
                      minWidth: 100.0,
                    ),
                  ],
                )));
}

//universal file downloader
class UniFileDownloader extends StatefulWidget {
  final FileSystemUtil fileSystemUtil;
  final String imgUrl;
  final String fileName;

  const UniFileDownloader(
      {Key key, this.fileSystemUtil, this.imgUrl, this.fileName})
      : super(key: key);

  @override
  _UniFileDownloaderState createState() => _UniFileDownloaderState();
}

class _UniFileDownloaderState extends State<UniFileDownloader> {
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  Permission permission1 = Permission.storage;
  var _onPressed;
  Directory externalDir;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    PermissionStatus checkPermission1 = await permission1.status;

    // print(checkPermission1);
    if (checkPermission1.isGranted == false) {
      await requestPermission(permission1);
    }

    if (checkPermission1.isGranted == true) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = (await widget.fileSystemUtil.extDownloadsPath) + "/";
        print("Download path $dirloc");
        //dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      try {
        FileUtils.mkdir([dirloc]);
        await dio.download(widget.imgUrl, "$dirloc${widget.fileName}",
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress = ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        progress = "Download Completed.";
        path = dirloc + widget.fileName;
      });

    } else {
      setState(() {
        progress = "Permission Denied!";
        _onPressed = () {
          downloadFile();
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('File Downloader'),
      ),
      body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Downloading File ${widget.fileName}: $progress',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              :Text("Done downloading ${widget.fileName}")
      )
  );




}
