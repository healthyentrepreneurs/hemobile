import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/survey/survey_js_page_loader_browser.dart';
import 'package:nl_health_app/screens/utilits/PreferenceUtils.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'package:permission_handler/permission_handler.dart';

class SurveyMainPage extends StatefulWidget {
  final Course course;

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

    /*body: (surveyData != null)
            ? SurveyJsPageLoader(
                jsonData: this.surveyData, jsonDataStr: this.surveyDataString)
            : Text(''));*/
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ToolsUtilities.mainBgColor,
        appBar: AppBar(
          title: Text(
            ""+widget.course.fullName,
            style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
        ),
        body: (surveyData != null)
            ? SurveyPageLoader(pages: this.surveyData)
            : Text(''));
  }*/

  @override
  void initState() {
    super.initState();
    //this.loadJsonText();
    loadPerms();
    initApp();
  }


  void initApp() async {
    await _getPref();
    if (offline == "on") {
      _loadOfflineQuizItemsData();
    } else {
      this.loadQuizItemsData();
    }
  }
  String? firstName;
  String? offline;

  _getPref() async {
    setState(() {
      offline = PreferenceUtils.getOnline();
      firstName = PreferenceUtils.getUser().firstname;
    });
  }

  /// Load the json data
  Future<void> loadJsonText() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/survey_form.json");
    final jsonResult = json.decode(data);
    print(data);
    setState(() {
      surveyData = jsonResult;
    });
  }

  //---
  void loadQuizItemsData() async {
    var token = PreferenceUtils.getUser().token;
    print('Token-->$token');
    setState(() {
      isLoading = true;
    });
    //https://helper.healthyentrepreneurs.nl/quiz/get_quiz_em/3/0/de81bb4eb4e8303a15b00a5c61554e2a
    OpenApi().listSubCourses(widget.course.nextLink).then((t) {
      setState(() {
        isLoading = false;
      });
      print(t.request!.url.toString());
      _processJson(t.body);
    }).catchError((e) {
      print("Error ${e.toString()}");
      setState(() {
        isLoading = false;
      });
    });
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


  late String mainOfflinePath;
  Future<String?> _loadOfflineQuizItemsData() async {
    mainOfflinePath = await FileSystemUtil().extDownloadsPath + "/HE Health";
    String p = await FileSystemUtil().extDownloadsPath + "/HE Health/";
    try {
      final file = File("$mainOfflinePath${widget.course.nextLink}");
      // Read the file.
      String contents = await file.readAsString();
      isLoading = false;
      //print(">> " + data?.body),
      _processJson(contents);
      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }
//---

}
