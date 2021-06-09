import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/chapterDetails/chapterDetails.dart';
import 'package:nl_health_app/screens/forum/home_screen.dart';
import 'package:nl_health_app/screens/quiz/quiz_page.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesSubPage extends StatefulWidget {
  final Course course;
  final SubCourse subCourse;

  CoursesSubPage({this.subCourse, this.course});

  @override
  _CoursesSubPageState createState() => _CoursesSubPageState();
}

class _CoursesSubPageState extends State<CoursesSubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolsUtilities.mainBgColor,
      appBar: AppBar(
        title: Text(
          widget.subCourse.name,
          style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 30.0),
                        Text(widget.subCourse.name,
                            style: TextStyle(
                                color: ToolsUtilities.mainPrimaryColor,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 15.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(widget.subCourse.summary,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ],
                    ),
                  ],
                )),
              ),
              SizedBox(height: 30.0),
              Container(
                child: SingleChildScrollView(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: widget.subCourse == null
                          ? 0
                          : widget.subCourse.modules.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var module_ = widget.subCourse.modules[index];
                        print('************${widget.subCourse.modules.length}');
                        return new GestureDetector(
                          child: _courseModuleCard(module_),
                          onTap: () {
                            //check the module type first here
                            print('module_.modname ${module_.modname}');
                            if (module_.modname == 'quiz') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuizPage(module: module_)));
                            }
                            if (module_.modname == 'forum') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForumHomePage()));
                            } else if (module_.modname == 'book') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChapterDetails(
                                            fileSystemUtil:
                                                new FileSystemUtil(),
                                            courseModule: module_,
                                            course: widget.course,
                                          )));
                            }
                          },
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseModuleCard(CourseModule courseModule, [Function onPressed]) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.21,
            width: MediaQuery.of(context).size.width * 0.43,
            decoration: BoxDecoration(
                color: ToolsUtilities.mainPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Text("calling $offline"),
                offline == "off"
                    ?
                    //Text("$offline")
                    CircleAvatar(
                        radius: 35.0,
                        backgroundImage: NetworkImage(courseModule.modicon),
                      )
                    : FutureBuilder(
                        future: _getLocalFile(courseModule.modicon),
                        builder: (BuildContext context,
                            AsyncSnapshot<File> snapshot) {
                          return snapshot.data != null
                              ? new Image.file(
                                  snapshot.data,
                                  height: 50.0,
                                  width: 50.0,
                                )
                              : new Container();
                        }),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0, left: 5.0, right: 5.0),
                  child: Text(
                    "${courseModule.name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<File> _getLocalFile(String filename) async {
    String dir = await FileSystemUtil().extDownloadsPath + "/HE Health";
    File f = new File('$dir$filename');
    return f;
  }

  Widget _courseCard(SubCourse course, [Function onPressed]) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.21,
            width: MediaQuery.of(context).size.width * 0.43,
            decoration: BoxDecoration(
                color: ToolsUtilities.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 35.0,
                  backgroundImage:
                      NetworkImage('https://picsum.photos/100/100'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0, left: 5.0, right: 5.0),
                  child: Text(
                    "${course.name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ToolsUtilities.mainPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    //_loadCourseData();
    initApp();
  }

  void initApp() async {
    await _getPref();
    if (offline == "on") {
      //_loadCourseDataOffline();
    } else {
      //this._loadCourseData();
    }
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

  List<SubCourse> _subCourseList;
}
