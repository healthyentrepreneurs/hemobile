import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:he/coursedetail/coursedetail.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/objects/objectbookquiz.dart';
import 'package:he/objects/objectcontentstructure.dart';
import 'package:he_api/he_api.dart';

import '../../helper/file_system_util.dart';
import '../../objects/blocs/repo/fofiperm_repo.dart';

class ChapterDisplay extends StatefulWidget {
  final ObjectBookQuiz? courseModule;
  final ObjectContentStructure? coursePage;
  final List<BookContent>? courseContents;
  final String courseId;

  const ChapterDisplay(
      {Key? key,
      required this.courseId,
      this.coursePage,
      this.courseContents,
      this.courseModule})
      : super(key: key);

  @override
  _ChapterDisplayState createState() => _ChapterDisplayState();
}

class _ChapterDisplayState extends State<ChapterDisplay> {
  @override
  Widget build(BuildContext context) {
    final heNetworkState =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    ObjectContentStructure _coursePage = widget.coursePage!;
    List<BookContent>? _courseContents = widget.courseContents;
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
    if (_htmlContentList.isNotEmpty &&
        heNetworkState != HenetworkStatus.noInternet) {
      contentText = _htmlContentList.first.fileurl;
    } else if (_htmlContentList.isNotEmpty &&
        heNetworkState == HenetworkStatus.noInternet) {
      File fileImage = fofirepo.getLocalFileHe(_htmlContentList.first.fileurl!);
      if (fileImage.existsSync()) {
        contentText = fileImage.readAsStringSync();
      } else {
        contentText = fileImage.path;
      }
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
                    }
                    var content = findSingleFileContent(videoSourceUrl);
                    if (content != null) {
                      return _htmlVideoCardFromOnline(
                          "${content.fileurl}", widget.courseId);
                    } else {
                      return const SizedBox(height: 1.0);
                    }
                  }
                  if (element.localName == 'img') {
                    String videoSourceUrl =
                        Uri.decodeFull(element.attributes['src'].toString());
                    var content = findSingleFileContent(videoSourceUrl);
                    if (content != null) {
                      return _displayFSImage(content, "${content.fileurl}");
                    } else {
                      return Image.asset('assets/images/grid.png');
                    }
                  }
                  return null;
                },
                textStyle: const TextStyle(color: Colors.black54),
              ))
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
                      child: Text('Error: No Content '),
                    )
                  ],
                ),
              )
      ]),
    );
  }

  Widget _htmlVideoCardFromOnline(String videoUrl, String courseId) {
    // print("Online video display ... $videoUrl");

    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 6.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChewieVideoViewOnline(
                        videoUrl: videoUrl,
                        courseId: courseId,
                      )));
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width * .97,
                  height: MediaQuery.of(context).size.height * .32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white38),
                  child: ChewieVideoViewOnline(
                    videoUrl: videoUrl,
                    courseId: courseId,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BookContent? findSingleFileContent(String fileName) {
    printOnlyDebug("HeOfflineMedia A $fileName");
    try {
      // 7-LU.mp4?time=1606398138322
      if (fileName.contains('?')) {
        fileName = fileName.split('?').first;
      }
      var courseContents = widget.courseContents;
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

  Widget _displayFSImage(BookContent content, String imageUrl) {
    // printOnlyDebug("Image in pager $_imageUrl");
    debugPrint("Davos $imageUrl");
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget chapterImageOffline(String photo, FoFiRepository fofi) {
    File fileImage = fofi.getLocalFileHe(photo);
    if (!fileImage.existsSync()) {
      return Image.asset(
        'assets/images/grid.png',
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      fileImage,
      fit: BoxFit.cover,
    );
  }

  bool downloading = false;
  var progress = "";
  var path = "No Data";
  String? privateToken;
  String? token;

  // https://flutterappworld.com/flutter-widget-from-html/
  // String getMeHtml() {}
  @override
  void initState() {
    super.initState();
    initApp();
  } //Create the Skill Card

  void initApp() async {}

  @override
  void dispose() {
    // don't forget to close the store
    super.dispose();
  }
}
