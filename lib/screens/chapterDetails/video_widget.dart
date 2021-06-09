import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoView extends StatefulWidget {
  final String videoUrl;

  const VideoView({Key key, this.videoUrl}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    print("Video ${widget.videoUrl}");
//    _controller = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    //_controller = VideoPlayerController.file(new File(widget.videoUrl));
    _controller = VideoPlayerController.asset("assets/video/malaria.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          Container(
            color: Colors.black12,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ToolsUtilities.mainPrimaryColor,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ToolsUtilities.mainPrimaryColor,
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

//download file if its not existing

}

class VideoViewOnline extends StatefulWidget {
  final String videoUrl;

  const VideoViewOnline({Key key, this.videoUrl}) : super(key: key);

  @override
  _VideoViewOnlineState createState() => _VideoViewOnlineState();
}

class _VideoViewOnlineState extends State<VideoViewOnline> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    print("Video -->>>> ${widget.videoUrl}");
    _controller = VideoPlayerController.network(widget.videoUrl);
    //_controller = VideoPlayerController.file(new File(widget.videoUrl));
    //_controller = VideoPlayerController.asset("assets/video/malaria.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          Container(
            color: Colors.black12,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ToolsUtilities.mainPrimaryColor,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ToolsUtilities.mainPrimaryColor,
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

//download file if its not existing

}

//chewie video
class ChewieVideoViewOnline extends StatefulWidget {
  final String videoUrl;

  const ChewieVideoViewOnline({Key key, this.videoUrl}) : super(key: key);

  @override
  _ChewieVideoViewOnlineState createState() => _ChewieVideoViewOnlineState();
}

class _ChewieVideoViewOnlineState extends State<ChewieVideoViewOnline> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    print("Video -->>>> ${widget.videoUrl}");
    super.initState();
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

  String firstName;
  String offline;

  _getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      offline = preferences.getString("offline");
      firstName = preferences.getString("firstName");
    });
  }

  String mainOfflinePath;
  Future<String> loadLocalFilePath() async {
    mainOfflinePath = await FileSystemUtil().extDownloadsPath + "/HE Health";
    return mainOfflinePath;
  }

  Future<void> initializePlayer() async {
    if (offline == "on") {
      _controller = VideoPlayerController.file(new File("$mainOfflinePath${widget.videoUrl}"));
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl);
    }
    //_controller = VideoPlayerController.network("https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4");
    //_controller = VideoPlayerController.file(new File(widget.videoUrl));
    //_controller = VideoPlayerController.asset("assets/video/malaria.mp4");
    await _controller.initialize();
//    _controller.setLooping(true);
//    _controller.setVolume(1.0);
//    _controller.play();

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
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
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
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
                      _chewieController.videoPlayerController.value.initialized
                  ? Chewie(
                      controller: _chewieController,
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
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: ToolsUtilities.mainPrimaryColor,
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),*/
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

//download file if its not existing

}
