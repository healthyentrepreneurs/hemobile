import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectsubscription.dart';
import 'package:he/survey/widgets/progresswidget.dart';
import 'package:he/survey/widgets/survey_js_page_loader_browser.dart';
import 'package:permission_handler/permission_handler.dart';

class SurveyPage extends StatefulWidget {
  final ObjectSubscription course;
  const SurveyPage({Key? key, required this.course}) : super(key: key);
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
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
        backgroundColor: ToolUtils.mainBgColor,
        appBar: AppBar(
          title: Text(
            "" + widget.course.fullname!,
            style: const TextStyle(color: ToolUtils.mainPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
        ),
        body: (surveyData != null)
            ? SurveyJsPageLoaderBrowser(
                jsonData: surveyData,
                jsonDataStr: surveyDataString,
                course: widget.course)
            : const Text('XXXX'));
  }

  @override
  void initState() {
    super.initState();
    loadPerms();
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
    _processJson("${data['surveyjson']}");
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

  showAlertDialog(BuildContext context, String title, String msg,
      [Function? _onPressed]) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
            // https://stackoverflow.com/questions/64278595/null-check-operator-used-on-a-null-value
            if (_onPressed != null) {
              _onPressed();
            }
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> loadPerms() async {
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus == PermissionStatus.denied) {
      await requestPermission(Permission.storage);
    }

    var permissionStatus2 = await Permission.camera.status;
    if (permissionStatus2 == PermissionStatus.denied) {
      await requestPermission(Permission.camera);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }
}
