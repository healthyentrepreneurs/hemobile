import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coursesSubPage.dart';

class CoursesPage extends StatefulWidget {
  final Course course;

  CoursesPage({this.course});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolsUtilities.whiteColor,
      appBar: AppBar(
        title: Text(
          widget.course.fullName,
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
                        Text(widget.course.fullName,
                            style: TextStyle(
                                color: ToolsUtilities.mainPrimaryColor,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 15.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(widget.course.summaryCustom,
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
                      itemCount:
                          _subCourseList == null ? 0 : _subCourseList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var subCourse = this._subCourseList[index];

                        return new GestureDetector(
                          child: _courseCard(subCourse),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CoursesSubPage(
                                        subCourse: subCourse,
                                        course: widget.course)));
                          },
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      //endDrawer: CustomDrawer(),
    );
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
              color: ToolsUtilities.mainPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                offline=="off"?
                CircleAvatar(
                  radius: 35.0,
                  backgroundImage: NetworkImage(widget.course.imageUrlSmall),
                ):
                FutureBuilder(
                    future: _getLocalFile(widget.course.imageUrlSmall),
                    builder: (BuildContext context,
                        AsyncSnapshot<File> snapshot) {
                      return snapshot.data != null
                          ? new Image.file(snapshot.data,
                        height: 50.0,width: 50.0,
                      )
                          : new Container();
                    })
                ,
                Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0, left: 5.0, right: 5.0),
                  child: Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ToolsUtilities.mainBgColor,
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

  @override
  void initState() {
    initApp();
  }

  void initApp() async {
    await _getPref();
    if (offline == "on") {
      _loadCourseDataOffline();
    } else {
      this._loadCourseData();
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

  String mainOfflinePath;
  Future<String> _loadCourseDataOffline() async {
    mainOfflinePath = await FileSystemUtil().extDownloadsPath + "/HE Health";
    String p = await FileSystemUtil().extDownloadsPath + "/HE Health/";
    try {
      final file = File("$mainOfflinePath${widget.course.nextLink}");
      print("Next link od course ${widget.course.nextLink}");

      // Read the file.
      String contents = await file.readAsString();
      _processJson(contents);
      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  ///Load courses data list and encode it to
  _loadCourseData() {
    print(widget.course.nextLink);
    OpenApi()
        .listSubCourses(widget.course.nextLink)
        .then((data) => {
              //close the dialoge
              print(">> " + data?.body),
              _processJson(data?.body)
            })
        .catchError((err) => {print("Error -- " + err.toString())});
  }

  List<SubCourse> _subCourseList;

  _processJson(String body) {
    //print(body);
    var json = jsonDecode(body);
    var courseJsonList = json['data'] as List;
    List<SubCourse> coursesObjs =
        courseJsonList.map((tagJson) => SubCourse.fromJson(tagJson)).toList();

    if (coursesObjs != null) {
      print("Got Sub courses -->${coursesObjs.length}");
      setState(() {
        _subCourseList = coursesObjs;
      });
      return coursesObjs;
    } else {
      showAlertDialog(
          context, "Courses Loading Error!", "Failed to load courses");
      return null;
    }
  }
}
