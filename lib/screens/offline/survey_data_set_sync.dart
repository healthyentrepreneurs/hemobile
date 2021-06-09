// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

//part of 'survey_data_set_model.dart';

import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nl_health_app/db2/survey_nosql_model.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../objectbox.g.dart';
import 'dart:isolate';

class LocalSurveySyncPage extends StatefulWidget {
  LocalSurveySyncPage();

  @override
  State<StatefulWidget> createState() => LocalSurveySyncPageState();
}

class LocalSurveySyncPageState extends State {
  LocalSurveySyncPageState();

  Store _store;

  @override
  void initState() {
    super.initState();
    initStore();
  }

  @override
  void dispose() {
    // setState?.dispose();
    super.dispose();
  }

  void initStore() async {
    var path = await FileSystemUtil().localDocumentsPath;
    //print("Paths --- $path  ---- xxdir $path'/objectbox'");
    if (_store == null) _store = Store(getObjectBoxModel(), directory: path);
    await loadLocalDataSets();
    await loadStatsDataSets();
  }

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
        appBar: AppBar(title: Text("Sync Data Sets")),
        body: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 50.0),
                Text("$reportMessage",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.orange)),
                SizedBox(height: 50.0),
                Text("Total Survey Data Sets $count",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 20.0),
                Text("Book Data Sets $countDataSet",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 10.0),
                surveyUploadDate != null
                    ? Text("Last Update date $surveyUploadDate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))
                    : Text(""),
                SizedBox(height: 10.0),
                Text(
                    "You can upload the local data sets when you get online by tapping the below button.",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 17)),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: RaisedButton(
                      onPressed: () {
                        //call syc method here...
                        pushAllDataSetsNow();
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      child: Text(
                        'Upload Survey Data',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
                showAlert
                    ? alertCardPopup('Sync Info',
                        "Failed to submit data You can upload the local data sets when")
                    : Text('')
              ],
            ),
          ),
        ));
  }

  List<SurveyDataModel> dataSets = [];
  int count = 0;
  int countDataSet = 0;

  Future<void> loadStatsDataSets() async {
    try {
      final box = _store.box<ViewsDataModel>();
      //box.removeAll();
      final c = box.count();
      //var list = await LocalSurvey().select().toList();
      setState(() {
        countDataSet = c;
      });
    } catch (e) {}
  }

  Future<int> loadLocalDataSets() async {
    int surveyNumber = 0;
    try {
      final box = _store.box<SurveyDataModel>();
      final c = box.count();
      if (c > 0) {
        final notesWithNullText = box.getAll();
        int patchCount = c - 1;
        setState(() {
          dataSets = notesWithNullText;
          count = patchCount;
        });
      }
      surveyNumber = c;
      print("Davos " + surveyNumber.toString());
      await readSurveyUpload();
      // _store.close();
    } on ObjectBoxException catch (f) {
      print("JoshuaX -->" + dataSets.length.toString());
    } catch (e) {
      print("NjovuX Error - ${e.toString()}");
      // box.store.isClosed
    } finally {
      surveyNumber = dataSets.length;
      print("Powa -->" + dataSets.length.toString());
    }
    return surveyNumber;
  }

  void pushAllDataSetsNow() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        toast_("No internet, please connect and try again.");
        return;
      }
      // Do your work here...
      setState(() {
        isLoading = true;
      });
      await uploadLocalDataSets();
      await uploadLocalDataSetsViewsDataModel();
      setState(() {
        isLoading = false;
        showAlert = true;
        reportMessage = "Done posting survey!";
        status = true;
      });
      initStore();
    } catch (e) {
      // print("Njovu Joshua");
      // if (!mounted) return;
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  Future<void> uploadLocalDataSets() async {
    if (dataSets.length < 1) {
      toast_("No data sets to upload!");
      return;
    }
    for (var l in dataSets) {
//      Map<String, dynamic> map = l.toMap();
//       print("Delete this id: ${l.id}");
      //print("Delete this surveyId: ${map['dateCreated']}");
      //print("Delete this data: ${map['data']}");
      // if (c < 1) {
      setState(() {
        isLoading = true;
      });
      // }
      postJsonDataOnline(l.text, l.name, l.id);
      // await Isolate.spawn(sendSurveyFromLocal, [l.text, l.name, l.id]);
    }
    saveUploadDatesPref();
  }

  Future<int> deleteLocalSurveyById(int id) async {
    final box = _store.box<SurveyDataModel>();
    //var x = box.get(id);
    var removed = box.remove(id);
    print("Deleted status $removed");
    return loadLocalDataSets();
  }

  bool isLoading = false;
  bool showAlert = false;
  bool status = false;
  String reportMessage = "";
  String surveyUploadDate;

  Future<void> readSurveyUpload() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      surveyUploadDate = preferences.getString("survey_upload_date");
    });
  }

  Future<void> sendSurveyFromLocal(List<Object> arguments) async {
    postJsonDataOnline(arguments[0], arguments[1], arguments[2]);
  }

  Future<void> postJsonDataOnline(
      String body, dynamic surveyId, int localId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("id");
    String surveyUploadDate = preferences.getString("survey_upload_date");

    Map<String, dynamic> j = new Map();
    j["userId"] = userId;
    j["surveyId"] = surveyId;
    print(">> surveyId " + surveyId);

    Map<String, dynamic> j2 = jsonDecode(body);
    j["jsondata"] = jsonEncode(j2);
    String b = jsonEncode(j);
    setState(() {
      reportMessage = "";
    });

    OpenApi().postSurveyJsonData(b, userId).then((data) {
      setState(() {
        isLoading = false;
      });
      //Delete the id

      // print(">> Results log --" + data?.body);
      Map<String, dynamic> x = jsonDecode(data?.body);
      if (x["code"] == 200) {
        deleteLocalSurveyById(localId);
      } else {
        print(">> Failed to upload --" + x["code"]);
        setState(() {
          showAlert = true;
          reportMessage = "Failed to post survey data! - ${x["msg"]}";
          status = false;
        });
      }
    }).catchError((err) {
      setState(() {
        showAlert = true;
        isLoading = false;
        reportMessage = "Error occurred while posting data!";
        status = false;
      });
      print("Serrugo Errors? -- " + err.toString());
    });
  }

  Widget alertCardPopup(String title, String text) {
    return Card(
      color: status ? Colors.green : Colors.red,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.sync_rounded, color: Colors.white),
            title: Text(title, style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              reportMessage,
              style: TextStyle(color: Colors.white),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: !status
                ? [
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        // uploadLocalDataSets();
                        pushAllDataSetsNow();
                      },
                      child: const Text('TRY AGAIN'),
                    ),
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        setState(() {
                          showAlert = false;
                        });
                      },
                      child: const Text('SEND LATER'),
                    ),
                  ]
                : [
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        Phoenix.rebirth(context);
                        setState(() {
                          showAlert = false;
                        });
                      },
                      child: const Text('CLOSE'),
                    ),
                  ],
          ),
        ],
      ),
    );
  }

  //---
  Future<void> uploadLocalDataSetsViewsDataModel() async {
    var path = await FileSystemUtil().localDocumentsPath;
    print("Paths --- $path  ---- xxdir $path'/objectbox'");
    Store _store = Store(getObjectBoxModel(), directory: path);
    final box = _store.box<ViewsDataModel>();
    final c = box.count();
    final dataSets = box.getAll();

    //print("--> $dataSets");
    //---
    if (c < 1) {
      toast_("No data sets to upload!");
      return;
    }
    for (var l in dataSets) {
      // print(
      //     "--> ${l.bookId}, ${l.chapterId}, ${l.id}, ${l.courseId}, ${l.dateTimeStr}");
      setState(() {
        isLoading = true;
      });
      await submitOnlineStat(
          l.bookId, l.chapterId, l.id, l.courseId, l.dateTimeStr, box);
    }
    if (c >= 1) saveUploadDatesPref();
    _store.close();
  }

  Future<void> submitOnlineStat(dynamic instance, dynamic chapterId,
      int localId, dynamic courseId, dynamic dateTimeStr, Box box) async {
    try {
      //user/viwedbook/{instanceid}/{path}/{token}
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userToken = preferences.getString("token");
      String username = preferences.getString("username");

      var value = await OpenApi().postStats(
          userToken, instance, chapterId, username, courseId, dateTimeStr);
      if (value != null) {
        print("Updated stats");
        box.remove(localId);
        loadStatsDataSets();
      } else {
        print("No value as got ....");
      }
    } catch (e) {
      print("Error uploading stats $e");
    }
  }
}
