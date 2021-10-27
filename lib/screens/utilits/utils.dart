import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:http/http.dart' as http;

import 'file_system_utill.dart';
import 'models/user_model.dart';

/// Switch the Firestore network mode
Future<void> switchMode(String offlineLocal) async {
  try {
    //if there is no network set off
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await FirebaseFirestore.instance.disableNetwork();
       return;
    }
    if (offlineLocal == 'on') {
      await FirebaseFirestore.instance.disableNetwork();
    } else {
      await FirebaseFirestore.instance.enableNetwork();
    }
  } catch (e) {}
}

///Read the firebase bundle from unzipped file
Future<Uint8List?> getBundleFromZipFile(String collectionName) async {
  try {
    User? user = (await preferenceUtil.getUser());
    if (user == null) return null;
    var fileLocalPath = "${user.id}bundle.json";
    var file = await FileSystemUtil().getLocalFile(fileLocalPath);
    if (!file.existsSync()) {
      print("The file $fileLocalPath does not exist.");
      return null;
    }
    var uint8list = file.readAsBytesSync();
    return uint8list;
  } catch (e) {
    return null;
  }
}

///Download bundles from the internet
Future<void> downloadBundle(String userId, String collectionName) async {
  try {
    //if there is no network set off
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await FirebaseFirestore.instance.disableNetwork();
       return;
    }

    if (connectivityResult == ConnectivityResult.none) {
      Uint8List? buffer = await getBundleFromZipFile(collectionName);
      if (buffer != null) {
        await cacheLoadedBundle(buffer, collectionName);
      }
    }
    else {
      //download from online
      //https://he-test-server.uc.r.appspot.com/downloaduser/72
      // Use a package like 'http' to retrieve bundle.
      final response = await http.get(Uri.parse(
          "https://databundles-dot-he-test-server.uc.r.appspot.com/bundleone/$userId"));
      // Convert the 'bundle.txt' string in the response to an Uint8List instance.
      Uint8List buffer = Uint8List.fromList(response.body.codeUnits);
      // Load bundle into cache.
      await cacheLoadedBundle(buffer, collectionName);
    }
  } catch (e) {
    print(e);
  }
}

///Save bundles bytes to cache
Future<void> cacheLoadedBundle(Uint8List buffer, String collectionName) async {
  try {
    // Load bundle into cache.
    LoadBundleTask task = FirebaseFirestore.instance.loadBundle(buffer);
    // Use .stream API to expose a stream which listens for LoadBundleTaskSnapshot events.
    task.stream.listen((taskStateProgress) {
      // if(taskStateProgress.taskState == LoadBundleTaskState.success){
      //bundle is loaded into app cache!
      // }
    });

    // If you do not wish to .listen() to the stream, but simply want to know when the bundle has been loaded. Use .last API:
    await task.stream.last;
    // Once bundle is loaded into cache, you may query for data by using the GetOptions()
    // to specify data retrieval from cache.
    QuerySnapshot<Map<String, Object?>> snapshot = await FirebaseFirestore
        .instance
        .collection(collectionName)
        .get(const GetOptions(source: Source.cache));

    if (snapshot.size >= 1) {
       snapshot.docs.forEach((e) {
        print(">> --- ${e.data()}");
      });
    } else {
     }
  } catch (e) {
    print(e);
  }
}

///Convert firebase paths to local unzipped cache folder
String joelPaths(String stringUrl, String userid, String courseId) {
  //Phase 1
  var courseResource = stringUrl.contains('courseresource');
  var f1 = stringUrl.contains('f1');
  var f2 = stringUrl.contains('f2');
  //Phase 2
  var course = stringUrl.contains('course');
  //Phase 3
  var surveyicon = stringUrl.contains('surveyicon');
  //Phase 4
  var bookResource = stringUrl.contains('bookresource');
  if (courseResource && f1) {
    return "/images/" + userid + "big_loginimage.png";
  }
  if (courseResource && f2) {
    return "/images/" + userid + "small_loginimage.png";
  }
  //course
  if (courseResource && course) {
    var s = stringUrl.split("/");
    var purevalue = s[s.length - 1];
    return "/images/course/" + userid + purevalue;
  }
  //survey
  if (surveyicon) {
    var s = stringUrl.split("/");
    var purevalue = s[s.length - 1];
    return "/images/survey/" + userid + purevalue;
  }
  //Book Resource
  if (bookResource) {
    var mod_book = stringUrl.contains('app.healthyentrepreneurs.nl');
    var defauticontheme = stringUrl.contains('theme');
    if (defauticontheme && mod_book) {
      var s = stringUrl.split("/");
      var purevalue = s[s.length - 1];
      return "/images/course/modicon/" + purevalue;
    }
    if (mod_book) {
      var s = stringUrl.split("pluginfile.php");
      return "/next_link/get_details_percourse/" + courseId + s[1];
    }
    var uploadicons = stringUrl.contains('helper.healthyentrepreneurs.nl');
    if (uploadicons) {
      var s = stringUrl.split("/");
      var purevalue = s[s.length - 1];
      return "/images/course/modicon" + purevalue;
    }
  }
  return "none";
}
