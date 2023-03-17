import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:video_player/video_player.dart';

import '../../objects/blocs/repo/fofiperm_repo.dart';

class ChewieVideoView extends StatefulWidget {
  final String videoUrl;
  final String courseId;
  final HenetworkStatus heNetworkState;
  const ChewieVideoView({
    Key? key,
    required this.videoUrl,
    required this.courseId,
    required this.heNetworkState,
  }) : super(key: key);

  @override
  _ChewieVideoViewState createState() => _ChewieVideoViewState();
}

class _ChewieVideoViewState extends State<ChewieVideoView> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  late String firstName;
  File? f;
  bool videoDownloading = false;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  void initApp() async {
    debugPrint("CourseId ${widget.courseId} and Video ${widget.videoUrl}");
    initializePlayer();
  }

  Future<void> downloadVideoFile() async {
    try {
      setState(() {
        videoDownloading = true;
      });
      debugPrint("video url ${widget.videoUrl}");
    } catch (e) {
      setState(() {
        videoDownloading = false;
      });
    }
  }

  Future<void> initializePlayer() async {
    if (widget.heNetworkState == HenetworkStatus.noInternet) {
      debugPrint("OfflineBitch ${widget.videoUrl}");
      final FoFiRepository _fofi = FoFiRepository();
      File fileVideo = _fofi.getLocalFileHe(widget.videoUrl);
      _controller = VideoPlayerController.file(fileVideo);
    } else if (widget.heNetworkState != HenetworkStatus.noInternet) {
      debugPrint("OnlineBitch ${widget.videoUrl}");
      _controller = VideoPlayerController.network(widget.videoUrl);
    }
    // _controller = VideoPlayerController.file(f!);
    await _controller?.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoPlay: false,
      looping: false,
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
              ? const Text("Wait Video is Downloading ...")
              : const Text("Download Video"),
          IconButton(
            onPressed: () {
              downloadVideoFile();
            },
            icon: const Icon(Icons.cloud_download),
          ),
        ],
      ),
    )
        : SizedBox(
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
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading'),
          ],
        ),
      ),
    );
  }
}
