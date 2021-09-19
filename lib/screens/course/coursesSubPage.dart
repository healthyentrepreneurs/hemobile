import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/models/utils.dart';
import 'package:nl_health_app/screens/chapterDetails/chapterDetails.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';

class CoursesSubPage extends StatefulWidget {
  final Course course;
  SubCourse? subCoursex;
  final dynamic subCourse;

  CoursesSubPage({required this.subCourse, required this.course});

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
          widget.subCourse["Name"]!,
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
              SizedBox(height: 30.0),
              Container(
                child: SingleChildScrollView(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      // ignore: unnecessary_null_comparison
                      itemCount: widget.subCourse == null
                          ? 0
                          : widget.subCourse['Modules']?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var module_ = widget.subCourse['Modules'][index];
                        //print('************${widget.subCourse['Modules'].length}');
                        return new GestureDetector(
                          child: _courseModuleCard(module_),
                          onTap: () {
                            //check the module type first here
                            print('module_.modname $module_');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChapterDetails(
                                            fileSystemUtil: new FileSystemUtil(),
                                            courseModule: module_,
                                            course: widget.course,
                                          )));

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

  Widget _courseModuleCard(Map<String,dynamic> courseModule, [Function? onPressed]) {
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
                FutureBuilder(
                        future: getFirebaseFile("${courseModule['Modicon']}"),
                        builder: (BuildContext context,
                            AsyncSnapshot<File> snapshot) {
                          return snapshot.data != null
                              ? new Image.file(
                                  snapshot.data!,
                                  height: 50.0,
                                  width: 50.0,
                                )
                              : new Container();
                        }),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0, left: 5.0, right: 5.0),
                  child: Text(
                    "${courseModule['Name']}",
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

  Widget _courseCard(SubCourse course, [Function? onPressed]) {
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
    super.initState();
    loadModulesData();
    initApp();
  }

  void loadModulesData() async {
    print("<<UUU>> ${widget.subCourse['Modules']} --  ${widget.course.imageUrlSmall}");

  }
  void initApp() async {
    await _getPref();
    if (offline == "on") {
      //_loadCourseDataOffline();
    } else {
      //this._loadCourseData();
    }
  }

  String? firstName;
  String? offline;
  _getPref() async {
    String? firstNameLocal = (await preferenceUtil.getUser())?.firstname;
    offline = await preferenceUtil.getOnline();
    firstNameLocal != null
        ? setState(() {
            firstName = firstNameLocal;
          })
        : null;
  }
}
