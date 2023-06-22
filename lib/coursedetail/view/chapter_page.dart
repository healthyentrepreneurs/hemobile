import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:he/asyncfiles/storageheutil.dart';
import 'package:he/coursedetail/coursedetail.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he_api/he_api.dart';

import '../../objects/blocs/repo/repo.dart';

class ChapterDisplay extends StatelessWidget {
  final BookQuiz? courseModule;
  final ContentStructure? coursePage;
  final List<BookContent>? courseContents;
  final String courseId;

  const ChapterDisplay({
    Key? key,
    required this.courseId,
    this.coursePage,
    this.courseContents,
    this.courseModule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heNetworkState =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    ContentStructure _coursePage = coursePage!;
    List<BookContent>? _courseContents = courseContents;
    final chapterIdPath = "/${_coursePage.chapterId}/";
    final FoFiRepository fofirepo = FoFiRepository();
    String? contentText;
    var _htmlContentList = _courseContents!
        .where((c) => c.filepath.toLowerCase() == chapterIdPath.toLowerCase())
        .where((cname) => cname.filename == "index.html")
        .toList();
    // if (_htmlContentList.isNotEmpty) {
    //   contentText = _htmlContentList.first.fileurl;
    // }
    // if (_htmlContentList.isNotEmpty &&
    //     heNetworkState != HenetworkStatus.noInternet) {
    //   contentText = _htmlContentList.first.fileurl;
    // } else if (_htmlContentList.isNotEmpty &&
    //     heNetworkState == HenetworkStatus.noInternet) {
    //   File fileImage = fofirepo.getLocalFileHeFileWalah(_htmlContentList.first.fileurl!);
    //   if (fileImage.existsSync()) {
    //     contentText = fileImage.readAsStringSync();
    //   }
    // }
    if (_htmlContentList.isNotEmpty &&
        heNetworkState != HenetworkStatus.noInternet) {
      contentText = _htmlContentList.first.fileurl;
    } else if (_htmlContentList.isNotEmpty &&
        heNetworkState == HenetworkStatus.noInternet) {
      Uint8List fileBytes =
          fofirepo.getLocalFileHeFileWalah(_htmlContentList.first.fileurl!);
      contentText = String.fromCharCodes(fileBytes);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        contentText != null
            ? RepaintBoundary(
                child: HtmlWidget(
                contentText,
                customStylesBuilder: (element) {
                  if (element.localName == 'h3') {
                    return {'color': '#CD5C5C'};
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  String videoSourceUrl;
                  if (element.localName == 'video') {
                    if (element
                        .getElementsByTagName("source")
                        .toList()
                        .isEmpty) {
                      videoSourceUrl = 'none';
                    } else {
                      var videoAttr = element
                          .getElementsByTagName('source')
                          .first
                          .attributes;
                      videoSourceUrl =
                          Uri.decodeFull(videoAttr['src'].toString());
                    }
                    if (videoSourceUrl == "none") {
                      return Image.asset('assets/images/grid.png');
                      // return Icon(Icons.segment_outlined, size: 20.0);
                    }
                    var content = findSingleFileContent(videoSourceUrl);
                    if (content != null) {
                      return _htmlVideoCardFrom(
                          "${content.fileurl}", courseId, heNetworkState);
                    } else {
                      return const SizedBox(height: 1.0);
                    }
                  }
                  if (element.localName == 'img') {
                    String videoSourceUrl =
                        Uri.decodeFull(element.attributes['src'].toString());
                    var content = findSingleFileContent(videoSourceUrl);
                    if (content != null) {
                      return _displayFSImage(content, "${content.fileurl}",
                          heNetworkState, fofirepo);
                    } else {
                      return Image.asset(
                        'assets/images/grid.png',
                        fit: BoxFit.cover,
                      );
                    }
                  }
                  return null;
                },
                textStyle: const TextStyle(color: Colors.black54),
              ))
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Error: No Content '),
                    )
                  ],
                ),
              )
      ]),
    );
  }

  BookContent? findSingleFileContent(String fileName) {
    printOnlyDebug("HeOfflineMedia A $fileName");
    try {
      if (fileName.contains('?')) {
        fileName = fileName.split('?').first;
      }
      // var courseContents = courseContents;
      var list = courseContents!
          .where((c) => c.filename.toLowerCase() == fileName.toLowerCase())
          .toList();
      if (list.isNotEmpty) {
        printOnlyDebug(
            "HeOfflineMedia B findSingleFileContent  list available ${list.first.filename}");
        return list.first;
      } else {
        printOnlyDebug("HeOfflineMedia C findSingleFileContent available null");
      }
      return null;
    } catch (e) {
      printOnlyDebug("Items $fileName");
      printOnlyDebug("HeOfflineMedia E findSingleFileContent error $e");
      return null;
    }
  }

  // Widget _displayFSImage(BookContent content, String imageUrl,
  //     HenetworkStatus heNetworkState, FoFiRepository _fofi) {
  //   debugPrint("Davos $imageUrl");
  //   if (heNetworkState == HenetworkStatus.noInternet) {
  //     return chapterImageOffline(imageUrl, _fofi);
  //   } else {
  //     // imageUrl
  //     // FLilq-XXEAQkE4C.jpeg
  //     return FutureBuilder<String>(
  //       future: _getImageUrlFromFirebase('FLilq-XXEAQkE4C.jpeg'),
  //       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           if (snapshot.hasData) {
  //             return Image.network(
  //               snapshot.data!,
  //               fit: BoxFit.cover,
  //             );
  //           } else {
  //             return Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[200],
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Icon(
  //                 Icons.broken_image,
  //                 color: Colors.grey[600],
  //                 size: 70,
  //               ),
  //             );
  //           }
  //         } else {
  //           return const Center(child: SpinKitThreeBounce(color: Colors.blue));
  //         }
  //       },
  //     );
  //   }
  // }
  Widget _displayFSImage(BookContent content, String imageUrl,
      HenetworkStatus heNetworkState, FoFiRepository _fofi) {
    debugPrint("Davos $imageUrl");
    if (heNetworkState == HenetworkStatus.noInternet) {
      return chapterImageOffline(imageUrl, _fofi);
    } else {
      final gcsPathOrError = convertUrlToWalahPath(imageUrl,0);
      // Only proceed if there was no error during conversion
      String gcsPath = "";
      if (gcsPathOrError.isRight()) {
        gcsPath = gcsPathOrError.getOrElse(() => "");
      } else {
        // Handle the error here, i.e., failed to convert URL to GCS path
        return const CircleAvatar(
          radius: 70,
          child: Icon(Icons.broken_image),
        );
      }
      return FutureBuilder<String>(
        future: _getImageUrlFromFirebase(gcsPath),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey[600],
                  size: 70,
                ),
              );
            }
          } else {
            return const Center(child: SpinKitThreeBounce(color: Colors.blue));
          }
        },
      );
    }
  }
  Widget chapterImageOffline(String photo, FoFiRepository fofi) {
    try {
      Uint8List imageData = fofi.getLocalFileHeFileWalah(photo);
      return Image.memory(
        imageData,
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[600],
          size: 70,
        ),
      );
    }
  }

  Future<String> _getImageUrlFromFirebase(String path) async {
    final storageRef = getIt<FirebaseStorage>().ref();
    final ref = storageRef.child(path);
    final String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Widget _htmlVideoCardFrom(
      String videoUrl, String courseId, HenetworkStatus heNetworkState) {
    debugPrint("Online-video-display ... $videoUrl");
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 3.0),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9, // Modify this ratio according to your needs
              child: ChewieVideoView(
                  videoUrl: videoUrl,
                  courseId: courseId,
                  heNetworkState: heNetworkState),
            ),
          ],
        ),
      ),
    );
  }
}
