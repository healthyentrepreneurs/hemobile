import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:flutter_html/flutter_html.dart';
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

import 'image_display_widget.dart';

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
      child: bookHtmlPagerUi(),
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

  Widget bookHtmlPagerUi() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Page ${widget.coursePage!.index} -  ${widget.coursePage!.title}",
            style: TextStyle(color: Colors.white),
          ),
          contentText != null
              ? Html(
                  data: contentText,
                  customRender: {
                    "video": (context, child) {
                      var baseFilePath = "contentObj.href";
                      var videoAttr = context.tree.element!
                          .getElementsByTagName('source')
                          .first
                          .attributes;
                      String videoSourceUrl =
                          Uri.decodeFull(videoAttr['src'].toString());
                      // print("videoSrc attr " + videoSourceUrl);
//                      print("videoSrc attr decode " + Uri.decodeFull(videoSourceUrl));
                      var content = findSingleFileContent(videoSourceUrl);

//                      print("attr " + attributes.toString());
//                      print("Base file path " + baseFilePath);

                      baseFilePath = baseFilePath.substring(
                          0, baseFilePath.lastIndexOf("/") + 1);
//                      print("added file path " + baseFilePath);

                      //return _htmlVideoCard(Uri.decodeFull(imageCoverUrl), Uri.decodeFull(videoUrl));
                      if (content != null)
                        return _htmlVideoCardFromOnline(
                            "${content['Fileurl']}", "${content['Fileurl']}");
                      else
                        return SizedBox(height: 1.0);
                    },
                    "img": (context, child) {
                      String videoSourceUrl = Uri.decodeFull(
                          context.tree.element!.attributes['src'].toString());
                      var content = findSingleFileContent(videoSourceUrl);
                      if (content != null) {
                        var s = "${content['Fileurl']}";
                        return FileImageDisplay(s);
                      } else
                        return SizedBox(height: 1.0);
                    }
                  },
                )
              : Text('Loading'),
        ],
      ),
    );
  }


  Future<Widget> displayFSImage(String imageUrl) async {
    var file = await getFirebaseFile("$imageUrl");
    print("${file.path}");
    if (file != null)
      return Image.file(
        file,
        height: 50.0,
        width: 240,
        fit: BoxFit.cover,
      );
    else
      return Container(
        height: 240,
        color: Colors.grey.shade100,
      );
  }

  Widget _displayImage(ModuleContent content, String imageUrl) {
    getFirebaseFile("$imageUrl");
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
