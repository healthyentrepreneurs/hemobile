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

  void initStore() async {
    var path = await FileSystemUtil().localDocumentsPath;
    //print("Paths --- $path  ---- xxdir $path'/objectbox'");
    if (_store == null) _store = Store(getObjectBoxModel(), directory: path);
    loadLocalDataSets();
    loadStatsDataSets();
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
                Text("Other Data Sets $countDataSet",
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
                          borderRadius: BorderRadius.circular(10.0),
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

  Future<void> loadLocalDataSets() async {
    try {
      final box = _store.box<SurveyDataModel>();

      final c = box.count();
      final notesWithNullText =
          box.getAll(); // executes the query, returns List<Note>

      //var list = await LocalSurvey().select().toList();
      setState(() {
        dataSets = notesWithNullText;
        count = c;
      });
      await readSurveyUpload();
      // for (var l in notesWithNullText) {
      //   print("--- ${l.id} - ${l.text}");
      //   //box.remove(l.id);
      // }
    } catch (e) {
      // print("NjovuXX -->" + e.toString());
    }
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
      await uploadLocalDataSets().then((value) => {
            setState(() {
              countSurveyLoads = value;
            })
          });
      await uploadLocalDataSetsViewsDataModel().then((valueBook) => {
            setState(() {
              countBookLoad = valueBook;
            })
          });
      int countCheck = countSurveyLoads + countBookLoad;
      if (countCheck <= 0) {
        toast_("No data sets to upload!");
        setState(() {
          isLoading = false;
        });
      } else {
        await Future.delayed(Duration(seconds: 4));
        setState(() {
          showAlert = true;
          reportMessage = "Done posting results!";
          status = true;
          isLoading = false;
        });
      }
      // print("What Do You have ? surveys"+countSurveyLoads.toString()+" books"+countBookLoad.toString());
      // setState(() {
      //   isLoading = false;
      // });
      initStore();
    } catch (e) {
      print("Njovuxx " + e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<int> uploadLocalDataSets() async {
    if (dataSets.length < 1) {
      //toast_("No data sets to upload!");
      return 0;
    }
    for (var l in dataSets) {
//      Map<String, dynamic> map = l.toMap();
//       print("Delete this id: ${l.id}");
      //print("Delete this surveyId: ${map['dateCreated']}");
      //print("Delete this data: ${map['data']}");
      // setState(() {
      //   isLoading = true;
      // });
      // print("Upload this data: ${l.text}");
      await postJsonDataOnline(l.text, l.name, l.id);
    }
    saveUploadDatesPref();
    return 1;
  }

  Future<void> deleteLocalSurveyById(int id) async {
    final box = _store.box<SurveyDataModel>();
    //var x = box.get(id);
    var removed = box.remove(id);
    print("Deleted status $removed");
    loadLocalDataSets();
  }

  bool isLoading = false;
  int countSurveyLoads = 0;
  int countBookLoad = 0;
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

  Future<void> postJsonDataOnline(
      String body, dynamic surveyId, int localId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("id");
    Map<String, dynamic> j = new Map();
    j["userId"] = userId;
    j["surveyId"] = surveyId;
    print(">> surveyId " + surveyId);

    Map<String, dynamic> j2 = jsonDecode(body);
    if (j2.containsKey("image-upload")) {
      print("Jiamy Lanister B");
      var imageObject = j2["image-upload"].elementAt(0);
      // print(image_object.runtimeType);
      String imageName = imageObject["name"];
      String cleanerImage = imageObject["content"]
          .replaceAll(RegExp('data:image/jpeg;base64,'), '');
      final decodedBytes = base64Decode(cleanerImage);
      OpenApi()
          .imageBytePost(decodedBytes, imageName, userId.toString(), surveyId)
          .then((data) {
      }).catchError((err) => {print("Uploading Image -- " + err.toString())});
      j2["image-upload"]=imageName;
    }
    j["jsondata"] = jsonEncode(j2);
    String b = jsonEncode(j);
    setState(() {
      reportMessage = "";
    });
    OpenApi().postSurveyJsonData(b, userId).then((data) {
      //Delete the id
      print(">> Results log --" + data?.body);
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
      print("Error -- " + err.toString());
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
  Future<int> uploadLocalDataSetsViewsDataModel() async {
    var path = await FileSystemUtil().localDocumentsPath;
    print("Paths --- $path  ---- xxdir $path'/objectbox'");
    Store _store = Store(getObjectBoxModel(), directory: path);
    final box = _store.box<ViewsDataModel>();
    final c = box.count();
    final dataSets = box.getAll();

    //print("--> $dataSets");
    //---
    if (c < 1) {
      // toast_("No data sets to upload!");
      return 0;
    }
    for (var l in dataSets) {
      print(
          "--> ${l.bookId}, ${l.chapterId}, ${l.id}, ${l.courseId}, ${l.dateTimeStr}");
      if (isLoading == false) {
        setState(() {
          isLoading = true;
        });
      }
      await submitOnlineStat(
          l.bookId, l.chapterId, l.id, l.courseId, l.dateTimeStr, box);
    }
    if (c >= 1) saveUploadDatesPref();
    return 1;
    // _store.close();
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
        // print("Updated stats");
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
