import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:nl_health_app/models/utils.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/screens/utilits/utils.dart';
import 'coursesSubPage.dart';

class CoursesPage extends StatefulWidget {
  final Course course;

  CoursesPage({required this.course});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  Stream<DocumentSnapshot>? _booksStream;
  dynamic dataX;

  Future<void> initSurveyDataHomePage() async {
    _booksStream = FirebaseFirestore.instance
        .collection('books')
        .doc("${widget.course.id}")
        .snapshots();

    var d = await _booksStream!.first;
    var data = d.data() as Map<String, dynamic>;
    setState(() {
      dataX = data['Data'] as List<dynamic>;
    });
    //_processJson(data['Data']);
  }

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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // SizedBox(height: 30.0),
                          Text(widget.course.summaryCustom,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
              // SizedBox(height: 30.0),

              Container(
                child: SingleChildScrollView(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: dataX == null ? 0 : dataX?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var subCourse = this.dataX[index];
                        if (subCourse != null) {
                          return new GestureDetector(
                            child: _courseCard(subCourse!),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CoursesSubPage(
                                          subCourse: subCourse,
                                          course: widget.course)));
                            },
                          );
                        } else {
                          return SizedBox(height: 10);
                        }

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

  Widget _courseCard(dynamic course, [Function? onPressed]) {
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
                FutureBuilder(
                    future: getFirebaseFile(widget.course.imageUrlSmall),
                    builder:
                        (BuildContext context, AsyncSnapshot<File> snapshot) {
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
                    "${course['Name']}",
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

  @override
  void initState() {
    initApp();
    super.initState();
  }

  void initApp() async {
    await _getPref();
    await initSurveyDataHomePage();
  }

  late String firstName;
  late String offline;

  _getPref() async {
    String? firstNameLocal = (await preferenceUtil.getUser())?.firstname;
    String? offlineLocal = await preferenceUtil.getOnline();

    setState(() {
      if (firstNameLocal != null) {
        firstName = firstNameLocal;
      }
      offline = offlineLocal;
    });
    await switchMode(offlineLocal);
  }

  late String mainOfflinePath;
}
