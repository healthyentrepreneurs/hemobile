import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:he/asyncfiles/storageheutil.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he/service/service.dart';
import 'package:he_api/he_api.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _videoExists = true;
  final FoFiRepository _fofi = FoFiRepository();

  @override
  void initState() {
    super.initState();
    _initializePlayer(_fofi);
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // Future<void> _initializePlayer(FoFiRepository _fofi) async {
  //   try {
  //     if (widget.heNetworkState == HenetworkStatus.noInternet) {
  //       Uint8List fileBytes =
  //           await _fofi.getLocalFileHeFileWalah(widget.videoUrl);
  //       String tempPath = (PermitFoFiService.directory).path;
  //       String filePath = '$tempPath/temp_video.mp4';
  //       File fileVideo = await File(filePath).writeAsBytes(fileBytes);
  //       if (await fileVideo.exists()) {
  //         _videoPlayerController = VideoPlayerController.file(fileVideo);
  //         await _videoPlayerController?.initialize(); // Use null-aware operator
  //       } else {
  //         _videoExists = false;
  //       }
  //     } else {
  //       final gcsPathOrError = convertUrlToWalahPath(widget.videoUrl, 0);
  //       String gcsPath = "";
  //       if (gcsPathOrError.isRight()) {
  //         gcsPath = gcsPathOrError.getOrElse(() => "");
  //       }
  //       debugPrint("YELELE $gcsPath");
  //       String videoUrl = await _getVideoUrlFromFirebase(gcsPath);
  //       _videoPlayerController = VideoPlayerController.network(videoUrl);
  //       await _videoPlayerController?.initialize(); // Use null-aware operator
  //     }
  //
  //     if (_videoExists) {
  //       _chewieController = ChewieController(
  //         videoPlayerController:
  //             _videoPlayerController!, // Use null assertion operator
  //         aspectRatio: _videoPlayerController!
  //             .value.aspectRatio, // Use null assertion operator
  //         autoPlay: false,
  //         looping: false,
  //         autoInitialize: true,
  //       );
  //     }
  //   } catch (e) {
  //     _videoExists = false;
  //   } finally {
  //     setState(() {});
  //   }
  // }
  Future<void> _initializePlayer(FoFiRepository _fofi) async {
    try {
      if (widget.heNetworkState == HenetworkStatus.noInternet) {
        Uint8List fileBytes =
            await _fofi.getLocalFileHeFileWalah(widget.videoUrl);
        String tempPath = (PermitFoFiService.directory).path;

        // Extract filename from widget.videoUrl
        String filename = widget.videoUrl.split('/').last;

        String filePath = '$tempPath/$filename';
        File fileVideo = File(filePath);

        // Check if the file already exists
        if (!(await fileVideo.exists())) {
          fileVideo = await fileVideo.writeAsBytes(fileBytes);
        }

        if (await fileVideo.exists()) {
          _videoPlayerController = VideoPlayerController.file(fileVideo);
          await _videoPlayerController?.initialize(); // Use null-aware operator
        } else {
          _videoExists = false;
        }
      } else {
        final gcsPathOrError = convertUrlToWalahPath(widget.videoUrl, 0);
        String gcsPath = "";
        if (gcsPathOrError.isRight()) {
          gcsPath = gcsPathOrError.getOrElse(() => "");
        }
        debugPrint("YELELE $gcsPath");
        String videoUrl = await _getVideoUrlFromFirebase(gcsPath);
        _videoPlayerController = VideoPlayerController.network(videoUrl);
        await _videoPlayerController?.initialize(); // Use null-aware operator
      }

      if (_videoExists) {
        _chewieController = ChewieController(
          videoPlayerController:
              _videoPlayerController!, // Use null assertion operator
          aspectRatio: _videoPlayerController!
              .value.aspectRatio, // Use null assertion operator
          autoPlay: false,
          looping: false,
          autoInitialize: true,
        );
      }
    } catch (e) {
      _videoExists = false;
    } finally {
      setState(() {});
    }
  }

  Future<String> _getVideoUrlFromFirebase(String path) async {
    final storageRef = getIt<FirebaseStorage>().ref();
    final ref = storageRef.child(path);
    final String videoUrl = await ref.getDownloadURL();
    return videoUrl;
  }

  @override
  Widget build(BuildContext context) {
    // /next_link/get_details_percourse/2/148/mod_book/chapter/7/15-LU.mp4
    if (_chewieController != null && _videoExists) {
      return _videoPlay();
    } else if (!_videoExists) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.video_file,
          color: Colors.grey[600],
          size: 70,
        ),
      );
    } else {
      return const Center(child: SpinKitThreeBounce(color: Colors.blue));
    }
  }

  Widget _videoPlay() {
    return SizedBox(
      child: Center(
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
    );
  }
}
