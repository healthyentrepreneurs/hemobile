import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/survey/survey_js_page_loader_browser.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/screens/utilits/utils.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'package:permission_handler/permission_handler.dart';

class SurveyMainPage extends StatefulWidget {
  final Course course;

  // https://surveyjs.io/Documentation/Library?id=Getting-Started-The-Very-Basics
  // https://surveyjs.io/Documentation/Library?id=Getting-Started-The-Very-Basics#Define-survey-content-through-JSON
  SurveyMainPage({required this.course});

  @override
  _SurveyMainPageState createState() => _SurveyMainPageState();
}

class _SurveyMainPageState extends State<SurveyMainPage> {
  dynamic surveyData;
  late String surveyDataString;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
        backgroundColor: ToolsUtilities.mainBgColor,
        appBar: AppBar(
          title: Text(
            "" + widget.course.fullName,
            style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
        ),
        body: (surveyData != null)
            ? SurveyJsPageLoaderBrowser(
                jsonData: this.surveyData,
                jsonDataStr: this.surveyDataString,
                course: widget.course)
            : Text(''));
  }

  @override
  void initState() {
    super.initState();
    loadPerms();
    initApp();
    initSurveyDataHomePage();
  }

  Stream<DocumentSnapshot>? _surveyStream;

  Future<void> initSurveyDataHomePage() async {
    _surveyStream = FirebaseFirestore.instance
        .collection('survey')
        .doc("${widget.course.id}")
        .snapshots();

    var d = await _surveyStream!.first;
    var data = d.data() as Map<String, dynamic>;
    _processJson("${data['SURVEYJSON']}");
  }

  void initApp() async {
    await _getPref();
    //if (widget.surveyJson != null) _processJson(widget.surveyJson!);
  }

  String? firstName;
  String? offline;

  _getPref() async {
    User? user = (await preferenceUtil.getUser());
    // firstNameLocal
    String? offlineLocal = (await preferenceUtil.getOnline());
    setState(() {
      if (user != null) {
        firstName = user.firstname;
      }
      offline = offlineLocal;
    });
    await switchMode(offlineLocal);
  }

  _processJson(String body) {
    try {
      setState(() {
        surveyDataString = body;
      });
      print(body);
      var json = jsonDecode(body);
      if (json != null) {
        setState(() {
          surveyData = json;
        });
      } else {
        showAlertDialog(context, "Quiz Loading Error!", "Failed to load quiz");
        return null;
      }
    } catch (e) {
      print('json error $e');
    }
  }

  Future<void> loadPerms() async {
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus == PermissionStatus.denied)
      await requestPermission(Permission.storage);

    var permissionStatus2 = await Permission.camera.status;
    if (permissionStatus2 == PermissionStatus.denied)
      await requestPermission(Permission.camera);
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }
//---

}
