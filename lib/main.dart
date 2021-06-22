import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/login/loginPage.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db2/survey_nosql_model.dart';
import 'objectbox.g.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'dart:isolate';


// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
void backgroundFetchHeadlessTask() async {
  // print('Alarm ID Headless event received.');
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // print("No internet, please connect and try again.");
    return;
  }
  // Do your work here...
  uploadLocalDataSets();
  uploadLocalDataSetsViewsDataModel();
}

Future<void> main() async {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(child: MyApp()));
  await AndroidAlarmManager.initialize();
  final int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 15), helloAlarmID, backgroundFetchHeadlessTask);
}

Future<void> uploadLocalDataSets() async {
  var path = await FileSystemUtil().localDocumentsPath;
  print("Paths --- $path  ---- xxdir $path'/objectbox'");
  Store _store = Store(getObjectBoxModel(), directory: path);
  final box = _store.box<SurveyDataModel>();
  final c = box.count();
  final dataSets = box.getAll();

  //print("--> $dataSets");
  //---
  if (c < 1) {
//    toast_("No data sets to upload!");
    return;
  }
  for (var l in dataSets) {
    //print("Delete this id: ${map['id']}");
//    print("Delete this surveyId: ${map['dateCreated']}");
    //print("Delete this data: ${map['data']}");
    await Isolate.spawn(sendSurveyFromLocal, [l.text, l.name, l.id, box]);
    // postJsonDataOnline(l.text, l.name, l.id, box);
  }
  if (c >= 1) saveUploadDatesPref();
  _store.close();
}

Future<void> sendSurveyFromLocal(List<Object> arguments) async {
  postJsonDataOnline(arguments[0], arguments[1], arguments[2], arguments[3]);
}

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
    // toast_("No data sets to upload!");
    return;
  }
  for (var l in dataSets) {
    print(
        "--> ${l.bookId}, ${l.chapterId}, ${l.id}, ${l.courseId}, ${l.dateTimeStr}");
//102, null, 1, null, null
    submitOnlineStat(
        l.bookId, l.chapterId, l.id, l.courseId, l.dateTimeStr, box);
//     await Isolate.spawn(sendBookFromLocal,
//         [l.bookId, l.chapterId, l.id, l.courseId, l.dateTimeStr, box]);
  }
  if (c >= 1) saveUploadDatesPref();
  _store.close();
}

void sendBookFromLocal(List<Object> arguments) {
  submitOnlineStat(arguments[0], arguments[1], arguments[2], arguments[3],
      arguments[4], arguments[5]);
}

Future<void> submitOnlineStat(dynamic instance, dynamic chapterId, int localId,
    dynamic courseId, dynamic dateTimeStr, Box box) async {
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
    } else {
      print("No value as got ....");
    }
  } catch (e) {
    print("Error uploading stats $e");
  }
}

Future<void> postJsonDataOnline(
    String body, dynamic surveyId, int localId, Box box) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int userId = preferences.getInt("id");

  Map<String, dynamic> j = new Map();
  j["userId"] = userId;
  j["surveyId"] = surveyId;
  print(">> surveyId " + surveyId);
  Map<String, dynamic> j2 = jsonDecode(body);
  if (j2.containsKey("image-upload")) {
    var imageObject = j2["image-upload"].elementAt(0);
    // print(image_object.runtimeType);
    String imageName = imageObject["name"];
    String cleanerImage = imageObject["content"]
        .replaceAll(RegExp('data:image/jpeg;base64,'), '');
    final decodedBytes = base64Decode(cleanerImage);
    OpenApi()
        .imageBytePost(decodedBytes, imageName, userId.toString(), surveyId.toString())
        .then((data) {
      // print("Njovu >> " + data?.body);
    }).catchError((err) => {print("Uploading Image -- " + err.toString())});
    j2["image-upload"]=imageName;
  }
  // Replicated Code
  // End Replica
  j["jsondata"] = jsonEncode(j2);
  String b = jsonEncode(j);
  OpenApi().postSurveyJsonData(b, userId).then((data) {
    //Delete the id
    print(">> Results log --" + data?.body);
    Map<String, dynamic> x = jsonDecode(data?.body);
    if (x["code"] == 200) {
      print(">> Success upload to upload --");
      //deleteLocalSurveyById(localId);
      box.remove(localId);
    } else {
      print(">> Failed to upload --" + x["code"]);
    }
  }).catchError((err) => {print("Error -- " + err.toString())});
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HE Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff349141),
        accentColor: Colors.green,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: Homepage(),
      home: LoginPage(),
      //home: OnBoarding(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
