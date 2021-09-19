import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

//chewie video
class ChewieVdViewOnline extends StatefulWidget {
  final File videoUrl;
  const ChewieVdViewOnline({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _ChewieVdViewOnlineState createState() => _ChewieVdViewOnlineState();
}

class _ChewieVdViewOnlineState extends State<ChewieVdViewOnline> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  var _permissionStatus;
  @override
  void initState() {
    print("Video -->>>> ${widget.videoUrl}");
    super.initState();
        () async {
      _permissionStatus = await Permission.storage.status;

      if (_permissionStatus != PermissionStatus.granted) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        setState(() {
          _permissionStatus = permissionStatus;
        });
      }
    }();
    initApp();
  }

  void initApp() async {
    await loadLocalFilePath();
    await _getPref();
    if (offline == "on") {
      //_loadCourseDataOffline();
    } else {
      //this._loadCourseData();
    }
    this.initializePlayer();
  }

  late String firstName;
  late String offline;

  _getPref() async {
    User? user = (await preferenceUtil.getUser());
    String? firstNameLocal = user?.firstname;
    String? offlineLocal = (await preferenceUtil.getOnline());
    setState(() {
      if (firstNameLocal != null) {
        firstName = firstNameLocal;
      }
      offline = offlineLocal;
    });
  }

  late String mainOfflinePath;
  Future<String> loadLocalFilePath() async {
    mainOfflinePath = await FileSystemUtil().extDownloadsPath + "/HE Health";
    return mainOfflinePath;
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.file(widget.videoUrl);
    // if (offline == "on") {
    //   _controller = VideoPlayerController.file(
    //       new File("$mainOfflinePath${widget.videoUrl}"));
    // } else {
    //   _controller = VideoPlayerController.file(widget.videoUrl);
    // }
    await _controller?.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:
      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Watch Video",
          style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
//download file if its not existing
}
