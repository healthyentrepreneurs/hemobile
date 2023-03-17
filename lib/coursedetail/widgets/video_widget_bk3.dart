import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoView extends StatefulWidget {
  final String videoUrl;
  final String courseId;
  final HenetworkStatus heNetworkState;

  ChewieVideoView({
    Key? key,
    required this.videoUrl,
    required this.courseId,
    required this.heNetworkState,
  }) : super(key: key);

  @override
  _ChewieVideoViewState createState() => _ChewieVideoViewState();
}

class _ChewieVideoViewState extends State<ChewieVideoView> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _initializePlayer() {
    if (widget.heNetworkState == HenetworkStatus.noInternet) {
      File fileVideo = FoFiRepository().getLocalFileHe(widget.videoUrl);
      _videoPlayerController = VideoPlayerController.file(fileVideo);
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    }

    _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio:
        _videoPlayerController.value.aspectRatio, // Set aspect ratio
        autoPlay: false,
        looping: false,
        autoInitialize: true,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null
        ? _videoPlay()
        : const Center(child: Text("To Be Continued ."));
  }

  Widget _videoPlay() {
    return SizedBox(
      // width: MediaQuery.of(context).size.width * .90,
      child: Center(
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
    );
  }
}
