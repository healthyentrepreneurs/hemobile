import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:nl_health_app/db2/survey_nosql_model.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../objectbox.g.dart';
// https://medium.com/flutter-community/how-to-show-download-progress-in-a-flutter-app-8810e294acbd

class SurveySyncViewModel extends ChangeNotifier {
  Store _store;
  SurveySyncViewModel() {
    initStore();
  }
  void initStore() async {
    var path = await FileSystemUtil().localDocumentsPath;
    //print("Paths --- $path  ---- xxdir $path'/objectbox'");
    if (_store == null) _store = Store(getObjectBoxModel(), directory: path);
    loadLocalDataSets();
    loadStatsDataSets();
  }

  int _counter = 0;
  int get counter => _counter;

  String reportMessage = "";
  bool isLoading = false;
  int countSurveyLoads = 0;
  int countBookLoad = 0;
  bool showAlert = false;
  bool status = false;
  String surveyUploadDate;
  List<SurveyDataModel> dataSets = [];
  int count = 0;
  int countDataSet = 0;

  void increment() {
    _counter++;
    notifyListeners(); // <-- notify listeners
  }

  Future<void> loadLocalDataSets() async {
    try {
      final box = _store.box<SurveyDataModel>();
      final c = box.count();
      final notesWithNullText =
          box.getAll(); // executes the query, returns List<Note>
      dataSets = notesWithNullText;
      count = c;
      await readSurveyUpload();
    } catch (e) {}
  }

  Future<void> loadStatsDataSets() async {
    try {
      final box = _store.box<ViewsDataModel>();
      //box.removeAll();
      final c = box.count();
      countDataSet = c;
    } catch (e) {}
  }

  Future<void> readSurveyUpload() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    surveyUploadDate = preferences.getString("survey_upload_date");
  }

  void pushAllDataSetsNow() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return;
      }
      // Do your work here...
      isLoading = true;
      await uploadLocalDataSets().then((value) => {countSurveyLoads = value});
      await uploadLocalDataSetsViewsDataModel()
          .then((valueBook) => {countBookLoad = valueBook});
      int countCheck = countSurveyLoads + countBookLoad;
      if (countCheck <= 0) {
        isLoading = false;
      } else {
        await Future.delayed(Duration(seconds: 4));
        showAlert = true;
        reportMessage = "Done posting results!";
        status = true;
        isLoading = false;
      }
      initStore();
    } catch (e) {
      isLoading = false;
    }
  }

  Future<int> uploadLocalDataSets() async {
    if (dataSets.length < 1) {
      //toast_("No data sets to upload!");
      return 0;
    }

    for (var l in dataSets) {
      await postJsonDataOnline(l.text, l.name, l.id);
    }
    saveUploadDatesPref();
    return 1;
  }

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
        isLoading = true;
      }
      submitOnlineStat(
          l.bookId, l.chapterId, l.id, l.courseId, l.dateTimeStr, box).asStream().listen((event) {

      });
    }
    if (c >= 1) saveUploadDatesPref();
    return 1;
    // _store.close();
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
    j["jsondata"] = jsonEncode(j2);
    String b = jsonEncode(j);
    reportMessage = "";
    OpenApi().postSurveyJsonData(b, userId).then((data) {
      //Delete the id
      print(">> Results log --" + data?.body);
      Map<String, dynamic> x = jsonDecode(data?.body);
      if (x["code"] == 200) {
        deleteLocalSurveyById(localId);
      } else {
        showAlert = true;
        reportMessage = "Failed to post survey data! - ${x["msg"]}";
        status = false;
      }
    }).catchError((err) {
      showAlert = true;
      isLoading = false;
      reportMessage = "Error occurred while posting data!";
      status = false;
    });
  }

  Future<void> deleteLocalSurveyById(int id) async {
    final box = _store.box<SurveyDataModel>();
    //var x = box.get(id);
    var removed = box.remove(id);
    print("Deleted status $removed");
    loadLocalDataSets();
  }

  Future<void> submitOnlineStat(dynamic instance, dynamic chapterId,
      int localId, dynamic courseId, dynamic dateTimeStr, Box box) async {
    try {
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
