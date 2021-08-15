import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/survey/survey_js_page_loader_browser.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
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
    User? user = (await preferenceUtil.getUser());
    // firstNameLocal
    String? offlineLocal = (await preferenceUtil.getOnline());
    setState(() {
      if (user != null) {
        firstName = user.firstname;
      }
      offline = offlineLocal;
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
    User user = (await preferenceUtil.getUser())!;
    String token = user.token;
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
