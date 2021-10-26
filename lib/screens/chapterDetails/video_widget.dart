import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:nl_health_app/models/utils.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/screens/utilits/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

//chewie video
class ChewieVideoViewOnline extends StatefulWidget {
  final String videoUrl;
  final String courseId;

  const ChewieVideoViewOnline(
      {Key? key, required this.videoUrl, required this.courseId})
      : super(key: key);

  @override
  _ChewieVideoViewOnlineState createState() => _ChewieVideoViewOnlineState();
}

class _ChewieVideoViewOnlineState extends State<ChewieVideoViewOnline> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  late String firstName;
  File? f;
  bool videoDownloading = false;

  @override
  void initState() {
    // print("Video -->>>> ${widget.videoUrl}");
    super.initState();
    initApp();
  }

  void initApp() async {
    // await loadLocalFilePath();
    await _getPref();

    f = await getFirebaseFile("${widget.videoUrl}", widget.courseId);
    print("The file path>> ${f?.path}");

    this.initializePlayer();
  }

  Future<void> downloadVideoFile() async {
    try {
      setState(() {
        videoDownloading = true;
      });
      var file =
          await FirebaseCacheManager().getSingleFile("${widget.videoUrl}");
      setState(() {
        videoDownloading = false;
        f = file;
      });
      addFilePathToFirebaseCache("${widget.videoUrl}", file);
    } catch (e) {
      setState(() {
        videoDownloading = false;
      });
    }
  }

  _getPref() async {
    User? user = (await preferenceUtil.getUser());
    String? firstNameLocal = user?.firstname;
    setState(() {
      if (firstNameLocal != null) {
        firstName = firstNameLocal;
      }
    });
  }

  /* late String mainOfflinePath;
  Future<String> loadLocalFilePath() async {
    mainOfflinePath = await FileSystemUtil().extDownloadsPath + "/HE Health";
    return mainOfflinePath;
  }*/

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.file(f!);
    //_controller = VideoPlayerController.network("https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4");
    //_controller = VideoPlayerController.file(new File(widget.videoUrl));
    //_controller = VideoPlayerController.asset("assets/video/malaria.mp4");
    await _controller?.initialize();
//    _controller.setLooping(true);
//    _controller.setVolume(1.0);
//    _controller.play();

    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (f == null)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                videoDownloading
                    ? Text("Wait Video is Downloading ...")
                    : Text("Download Video"),
                IconButton(
                  onPressed: () {
                    downloadVideoFile();
                  },
                  icon: Icon(Icons.cloud_download),
                )
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width * .90,
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
          );
  }

//download file if its not existing
}
