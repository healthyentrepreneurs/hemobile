import 'dart:io';

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/db2/survey_nosql_model.dart';
import 'package:nl_health_app/models/utils.dart';
import 'package:nl_health_app/screens/chapterDetails/video_widget.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/home_helper.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/services/service_locator.dart';

class CourseElementDisplay extends StatefulWidget {
  final dynamic courseModule;
  final ContentStructure? coursePage;
  final Course? course;
  final List<dynamic>? courseContents;

  const CourseElementDisplay(
      {Key? key,
      this.coursePage,
      this.courseContents,
      this.courseModule,
      this.course})
      : super(key: key);

  @override
  _CourseElementDisplayState createState() => _CourseElementDisplayState();
}

class _CourseElementDisplayState extends State<CourseElementDisplay> {
  final storeHelper = getIt<HomeHelper>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Widget>(
          future: bookHtmlPagerUi(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) return snapshot.data!;
            return Container(child: CircularProgressIndicator());
            // return snapshot.data != null ? snapshot.data! : new Container();
          }),
    );
  }

  String? contentText;
  String? _storageDir;

  bool downloading = false;
  var progress = "";
  var path = "No Data";
  String? privateToken;
  String? token;

  dynamic findSingleFileContent(String fileName) {
    try {
      var courseContents = widget.courseContents;
      var list = courseContents!
          .where(
              (c) => "${c['Filename']}".toLowerCase() == fileName.toLowerCase())
          .toList();
      // ignore: unnecessary_null_comparison
      if (list != null)
        return list.first;
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  // https://flutterappworld.com/flutter-widget-from-html/
  Future<Widget> bookHtmlPagerUi() async {
    // print(contentText);
    return SingleChildScrollView(
        child: Column(children: [
      // Text(
      //   "Page ${widget.coursePage!.index} -  ${widget.coursePage!.title}",
      //   style: TextStyle(color: Colors.redAccent),
      // ),
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
                    var videoAttr =
                        element.getElementsByTagName('source').first.attributes;
                    String videoSourceUrl =
                        Uri.decodeFull(videoAttr['src'].toString());
                    var content = findSingleFileContent(videoSourceUrl);
                    if (content != null)
                      return _htmlVideoCardFromOnline(
                          "${content['Fileurl']}", "${content['Fileurl']}");
                    else
                      return SizedBox(height: 1.0);
                  }
                  if (element.localName == 'img') {
                    String videoSourceUrl =
                        Uri.decodeFull(element.attributes['src'].toString());
                    var content = findSingleFileContent(videoSourceUrl);
                    // String keyvalue = "${content['Fileurl']}";
                    if (content != null)
                      return _displayFSImage(content, "${content['Fileurl']}");
                    else
                      return Image.asset('assets/images/grid.png');
                  }
                  return null;
                },
                textStyle: TextStyle(color: Colors.black54),
              ),
            )
          : Text('Loading')
    ]));
  }

  Widget _displayFSImagenn(dynamic content, String imageUrl) {
    print("FS image path >>+$imageUrl");
    return Image(
      image: FirebaseImage(
          'gs://he-test-server.appspot.com/bookresource/app.healthyentrepreneurs.nl/webservice/pluginfile.php/148/mod_book/chapter/10/HIV1.png',
          shouldCache: true, // The image should be cached (default: True)
          maxSizeBytes: 6000 * 1000, // 3MB max file size (default: 2.5MB)
          cacheRefreshStrategy: CacheRefreshStrategy
              .BY_METADATA_DATE // Switch off update checking
          ),
      fit: BoxFit.cover,
    );
  }

  Widget _displayFSImage(dynamic content, String imageUrl) {
    //print("FS image path >>+$imageUrl");
    return FutureBuilder(
        future: getFirebaseFile("$imageUrl"),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          return snapshot.data != null
              ? new Image.file(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  // height: 100.0,
                  // width: 200.0,
                )
              : new Image.asset('assets/images/grid.png');
          ;
        });
  }

  Widget _displayImage(ModuleContent content, String imageUrl) {
    if (offline == "on") {
      print("offline image path >>+$mainOfflinePath$imageUrl");
      return Image.file(new File("$mainOfflinePath$imageUrl"));
    } else {
      return Image.network(imageUrl);
    }
  }

  Widget _htmlVideoCardFromOnline(String imageUrl, String videoUrl) {
    // print("Online video display ... $videoUrl");
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 6.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChewieVideoViewOnline(videoUrl: videoUrl)));
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width * .90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white38),
                  child: Image.asset(
                    "assets/images/grid.png",
                    width: MediaQuery.of(context).size.width * .90,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChewieVideoViewOnline(videoUrl: videoUrl)));
                  },
                  icon: Icon(
                    FontAwesomeIcons.playCircle,
                    color: ToolsUtilities.redColor,
                    size: 50,
                  ),
                  label: Text(''))
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
    var connected = await isConnected();
    if (offline == "on" && !connected) {
      this.submitOfflineStat();
    } else {
//      this.submitOfflineStat();
      this.submitOnlineStat();
    }
  }

  void initApp() async {
    await loadLocalFilePath();
    await _getPref();
    this.readContentFile();

    addViewStat();
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

  Future<String?> readContentFileOffline() async {
    mainOfflinePath = await FileSystemUtil().extDownloadsPath + "/HE Health";
    try {
      var e = widget.coursePage;
      final fileUrl = e!.filefullpath;
      print(">>> Read local html file $fileUrl");
      final file = File("$mainOfflinePath$fileUrl");
      String contents = await file.readAsString();

      setState(() {
        contentText = contents;
      });
      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  Future<void> readContentFile() async {
    try {
      User? user = (await preferenceUtil.getUser());
      privateToken = user?.privatetoken;
      token = user?.token;
      var e = widget.coursePage;
      final chapterId = e!.chapterId;
      final chapterIdPath = "/$chapterId/";
      // print(">> $chapterIdPath $chapterId}");
      //Filepath
      //Fileurl
      //Type == file

      var courseContents = widget.courseContents;
      var list = courseContents!
          .where((c) =>
              "${c['Filepath']}".toLowerCase() == chapterIdPath.toLowerCase())
          .toList();
      if (list.length > 0) {
        // print(">>>File download link Index ${list.first['Fileurl']} title ${e.title}");
        String txt = "${list.first['Fileurl']}";
        setState(() {
          contentText = txt;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> OreadContentFile() async {
    FileSystemUtil fileSystemUtil = new FileSystemUtil();
    try {
      User? user = (await preferenceUtil.getUser());
      privateToken = user?.privatetoken;
      token = user?.token;
      var e = widget.coursePage;
      final fileUrl = e!.filefullpath;
      print(">>>File download link Index ${e.index} title ${e.title}");
      String txt = await fileSystemUtil.readFileContentLink(fileUrl);

      setState(() {
        contentText = txt;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // don't forget to close the store
    super.dispose();
  }

  void submitOfflineStat() {
    try {
      // ViewsDataModel bookDataModel = ViewsDataModel(
      //     bookId: widget.courseModule!.instance.toString(),
      //     courseId: widget.course!.id.toString(),
      //     dateTimeStr: DateTime.now().toIso8601String(),
      //     chapterId: widget.coursePage!.chapterId.toString());
      ViewsDataModel bookDataModel = ViewsDataModel()
        ..bookId = widget.courseModule!.instance.toString()
        ..courseId = widget.course!.id.toString()
        ..dateTimeStr = DateTime.now().toIso8601String()
        ..chapterId = widget.coursePage!.chapterId.toString();
      final id = storeHelper.saveBookLocal(bookDataModel);
      print("Saved no_sql chapter id ${bookDataModel.chapterId}");
      print("Saved no_sql $id");
    } catch (e) {
      print("CourseElementDisplay " + e.toString());
    }
  }

  Future<void> submitOnlineStat() async {
    //user/viwedbook/{instanceid}/{path}/{token}
    User? user = (await preferenceUtil.getUser());
    String? userToken = user?.token;
    String? username = user?.username;
    var dateTime = DateTime.now().toIso8601String();

    /*OpenApi()
        .postStats(userToken!, widget.courseModule!.instance,
            widget.coursePage!.chapterId, username, widget.course!.id, dateTime)
        .then((value) {})
        .catchError((e) {
      print("Error uploading stats $e");
    });*/
  }
}
