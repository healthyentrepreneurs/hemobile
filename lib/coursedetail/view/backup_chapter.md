import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:he/coursedetail/coursedetail.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/objects/objectbookcontent.dart';
import 'package:he/objects/objectbookquiz.dart';
import 'package:he/objects/objectcontentstructure.dart';

class ChapterDisplay extends StatefulWidget {
  final ObjectBookQuiz? courseModule;
  final ObjectContentStructure? coursePage;
  final List<ObjectBookContent>? courseContents;

  const ChapterDisplay(
      {Key? key, this.coursePage, this.courseContents, this.courseModule})
      : super(key: key);

  @override
  _ChapterDisplayState createState() => _ChapterDisplayState();
}

class _ChapterDisplayState extends State<ChapterDisplay> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: bookHtmlPagerUi(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) return snapshot.data!;
          return const CircularProgressIndicator();
          // return snapshot.data != null ? snapshot.data! : new Container();
        });
  }

  String? contentText;

  bool downloading = false;
  var progress = "";
  var path = "No Data";
  String? privateToken;
  String? token;

  ObjectBookContent? findSingleFileContent(String fileName) {
    printOnlyDebug("file name $fileName");
    try {
      var courseContents = widget.courseContents;
      var list = courseContents!
          .where((c) => c.filename.toLowerCase() == fileName.toLowerCase())
          .toList();
      // ignore: unnecessary_null_comparison
      if (list != null) {
        printOnlyDebug("findSingleFileContent  list available ${list.first}");
        return list.first;
      } else {
        printOnlyDebug("findSingleFileContent available null");
      }
      return null;
    } catch (e) {
      printOnlyDebug("findSingleFileContent error $e");
      return null;
    }
  }

  // https://flutterappworld.com/flutter-widget-from-html/
  Future<Widget> bookHtmlPagerUi() async {
    // print(contentText);
    return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(children: [
          contentText != null
              ? RepaintBoundary(
            child: HtmlWidget(
              contentText!,
              customStylesBuilder: (element) {
                if (element.localName == 'h3') {
                  return {'color': '#CD5C5C'};
                }
                return null;
              },
              customWidgetBuilder: (element) {
                if (element.localName == 'video') {
                  var videoAttr = element
                      .getElementsByTagName('source')
                      .first
                      .attributes;
                  String videoSourceUrl =
                  Uri.decodeFull(videoAttr['src'].toString());
                  var content = findSingleFileContent(videoSourceUrl);
                  if (content != null) {
                    return _htmlVideoCardFromOnline("${content.fileurl}");
                  } else {
                    return const SizedBox(height: 1.0);
                  }
                }
                if (element.localName == 'img') {
                  String videoSourceUrl = Uri.decodeFull(
                      element.attributes['src'].toString());
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
            ),
          )
              : const Text('Loading')
        ]));
  }

  Widget _displayFSImage(ObjectBookContent content, String imageUrl) {
    String _imageUrl =
        "$imageUrl?token=a8400b6d821f54442b9696a03e89e330";
    printOnlyDebug("Image in pager $_imageUrl");
    return Image.network(
      _imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget _htmlVideoCardFromOnline(String videoUrl) {
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
                    courseId: "3",
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
                    courseId: "3",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initApp();
  } //Create the Skill Card

  /// Add stats to server
  void addViewStat() async {
    printOnlyDebug("Am submitting data");
  }

  void initApp() async {
    readContentFile();
    addViewStat();
  }

  Future<void> readContentFile() async {
    try {
      token = "a8400b6d821f54442b9696a03e89e330";
      var e = widget.coursePage;
      final chapterId = e!.chapterId;
      final chapterIdPath = "/$chapterId/";
      // print(">> $chapterIdPath $chapterId}");
      //Filepath
      //Fileurl
      //Type == file

      var courseContents = widget.courseContents;
      var list = courseContents!
          .where((c) => c.filepath.toLowerCase() == chapterIdPath.toLowerCase())
          .toList();
      if (list.isNotEmpty) {
        // print(">>>File download link Index ${list.first['Fileurl']} title ${e.title}");
        String txt = "${list.first.fileurl}";
        setState(() {
          contentText = txt;
        });
      }
    } catch (e) {
      printOnlyDebug("readContentFile $e");
    }
  }

  @override
  void dispose() {
    // don't forget to close the store
    super.dispose();
  }
}
