import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:http/http.dart' as http;

/// Switch the Firestore network mode
Future<void> switchMode(String offlineLocal) async {
  try {
    //if there is no network set off
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await FirebaseFirestore.instance.disableNetwork();
      toast_("No internet, we running in offline mode");
      return;
    }
    if (offlineLocal == 'on') {
      await FirebaseFirestore.instance.disableNetwork();
    } else {
      await FirebaseFirestore.instance.enableNetwork();
    }
  } catch (e) {}
}

///Get bundles
Future<void> downloadBundle(String url, String collectionName) async {
  try {
    //if there is no network set off
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await FirebaseFirestore.instance.disableNetwork();
      toast_("No internet, we running in offline mode");
      return;
    }

    //https://he-test-server.uc.r.appspot.com/downloaduser/72
    // Use a package like 'http' to retrieve bundle.
    final response = await http.get(Uri.parse(
        "https://databundles-dot-he-test-server.uc.r.appspot.com/bundleone/$url"));
    // Convert the 'bundle.txt' string in the response to an Uint8List instance.
    Uint8List buffer = Uint8List.fromList(response.body.codeUnits);
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
      toast_("Got ${snapshot.size} $collectionName bundles");
      snapshot.docs.forEach((e) {
        print(">> --- ${e.data()}");
      });
    } else {
      toast_("No data sets from bundle");
    }
  } catch (e) {
    print(e);
  }
}


String JoelPaths(String stringurl, String userid ,String courseid){
  //Phase 1
  var courseResource = stringurl.contains('courseresource');
  var f1 = stringurl.contains('f1');
  var f2 = stringurl.contains('f2');
  //Phase 2
  var course = stringurl.contains('course');
  //Phase 3
  var surveyicon =stringurl.contains('surveyicon');
  //Phase 4
  var bookresource =stringurl.contains('bookresource');
  if (courseResource && f1){
    return "/images/" + userid + "big_loginimage.png";
  }
  if (courseResource && f2){
    return "/images/" + userid + "small_loginimage.png";
  }
  //course
  if (courseResource && course) {
    var s=stringurl.split("/");
    var purevalue = s[s.length-1];
    return "/images/course/" + userid + purevalue;
  }
  //survey
  if (surveyicon) {
    var s=stringurl.split("/");
    var purevalue = s[s.length-1];
    return "/images/survey/" + userid + purevalue;
  }
  //Book Resource
  if (bookresource) {
    var mod_book =stringurl.contains('app.healthyentrepreneurs.nl');
    var defauticontheme =stringurl.contains('theme');
    if (defauticontheme && mod_book) {
      var s=stringurl.split("/");
      var purevalue = s[s.length-1];
      return "/images/course/modicon/" + purevalue;
    }
    if (mod_book) {
      var s=stringurl.split("pluginfile.php");
      return "/next_link/get_details_percourse/" + courseid + s[1];
    }
    var uploadicons = stringurl.contains('helper.healthyentrepreneurs.nl');
    if (uploadicons) {
      var s=stringurl.split("/");
      var purevalue = s[s.length-1];
      return "/images/course/modicon" + purevalue;
    }

  }
  return "none";
}
