import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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
  //Start Here @phila three
  const ChapterDisplay({
    Key? key,
    required this.courseId,
    this.coursePage,
    this.courseContents,
    this.courseModule,
  }) : super(key: key);

  // ... (Include the rest of the methods in this class)

  @override
  Widget build(BuildContext context) {
    final heNetworkState =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    ContentStructure _coursePage = coursePage!;
    List<BookContent>? _courseContents = courseContents;
    final chapterIdPath = "/${_coursePage.chapterId}/";
    final FoFiRepository fofirepo = FoFiRepository();
    var _htmlContentList = _courseContents!
        .where((c) => c.filepath.toLowerCase() == chapterIdPath.toLowerCase())
        .where((cname) => cname.filename == "index.html")
        .toList();

    return FutureBuilder<String?>(
      future:
          _getChapterContentText(_htmlContentList, heNetworkState, fofirepo),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or another placeholder widget
        } else if (snapshot.hasError) {
          debugPrint('Error loading chapter content: ${snapshot.error}');
          // You can also add a widget to display when there's an error
          return const Text('Error loading content');
        } else {
          String? contentText = snapshot.data;
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
                          // Your custom widget builder implementation...
                        },
                        textStyle: const TextStyle(color: Colors.black54),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Error: No Content'),
                          ),
                        ],
                      ),
                    ),
            ]),
          );
        }
      },
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

  Widget _displayFSImage(BookContent content, String imageUrl,
      HenetworkStatus heNetworkState, FoFiRepository _fofi) {
    debugPrint("Davos $imageUrl");
    if (heNetworkState == HenetworkStatus.noInternet) {
      return chapterImageOffline(imageUrl, _fofi);
    } else {
      final gcsPathOrError = convertUrlToWalahPath(imageUrl);
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

  Future<String> _getImageUrlFromFirebase(String path) async {
    final storageRef = getIt<FirebaseStorage>().ref();
    final ref = storageRef.child(path);
    final String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Widget chapterImageOffline(String photo, FoFiRepository fofi) {
    return FutureBuilder<File>(
      future: fofi.getLocalFileHeFile(photo),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or another placeholder widget
        } else if (snapshot.hasError) {
          debugPrint('Error loading local file: ${snapshot.error}');
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
        } else {
          File fileImage = snapshot.data!;
          return Image.file(
            fileImage,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }

  Either<bool, String> convertUrlToWalahPath(String url) {
    Either<bool, String> bucketUrlOrError =
        formatForBucket(url, 0); // replace 2 with your changeType
    return bucketUrlOrError.fold(
        (error) => Left(error), (bucketUrl) => Right(bucketUrl));
  }

  Either<bool, String> formatForBucket(String stringUrl, int changeType) {
    String basePath = '';
    switch (changeType) {
      case 0:
        basePath = '/bookresource/';
        break;
      case 1:
        basePath = '/courseresource/';
        break;
      case 2:
        basePath = '/surveyicon/';
        break;
      case 3:
        basePath = '/h5presource/';
        break;
      default:
        return const Left(false);
    }

    String bucketUrl = stringUrl.contains('http://')
        ? stringUrl.replaceFirst('http://', basePath)
        : stringUrl.replaceFirst('https://', basePath);

    if (bucketUrl.contains('?token')) {
      int i = bucketUrl.indexOf('?');
      bucketUrl = bucketUrl.substring(0, i);
    }

    return Right(bucketUrl);
  }


  Future<String?> _getChapterContentText(List<BookContent> htmlContentList,
      HenetworkStatus heNetworkState, FoFiRepository fofirepo) async {
    if (htmlContentList.isNotEmpty) {
      if (heNetworkState == HenetworkStatus.noInternet) {
        File fileImage =
            await fofirepo.getLocalFileHeFile(htmlContentList.first.fileurl!);
        if (fileImage.existsSync()) {
          return fileImage.readAsString();
        }
      } else {
        return htmlContentList.first.fileurl;
      }
    }
    return null;
  }
}
