import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/screens/utilits/utils.dart';
import 'package:path/path.dart';

Future<File> getFirebaseFileX(String url, [String courseid = "0"]) async {
  try {
    var file = await FirebaseCacheManager().getSingleFile(url);
    return file;
  } catch (e) {
    var file = await FirebaseCacheManager().getSingleFile(
        "/bookresource/app.healthyentrepreneurs.nl/theme/image.php/_s/academi/book/1631050397/placeholderimage.png");
    return file;
  }
}

Future<File> getFirebaseFile(String url, [String courseId = "0"]) async {
  try {
    var cachedFile = await FirebaseCacheManager().getFileFromCache(url);
    if (cachedFile != null) {
      if (cachedFile.validTill.isBefore(DateTime.now())) {
        var f = await addFileToFirebaseCache(url, courseId);
        return f!;
      } else {
        return cachedFile.file;
      }
    } else {
      //print("> Download from the net --> $url");
      var f = await addFileToFirebaseCache(url, courseId);
      if (f == null) {
        var file = await FirebaseCacheManager().getSingleFile(url);
        addFilePathToFirebaseCache("$url", file);
        return file;
      } else {
        return f;
      }
    }
  } catch (e) {
    print(e);
    var file = await FirebaseCacheManager().getSingleFile(
        "/bookresource/app.healthyentrepreneurs.nl/theme/image.php/_s/academi/book/1631050397/placeholderimage.png");
    return file;
  }
}

Future<File?> addFileToFirebaseCache(String url, String courseId) async {
  try {
    User? user = (await preferenceUtil.getUser());
    //get the local file path
    var fileLocalPath = joelPaths(url, "${user!.id}", courseId);

    //read the local file - Like /images/$userId"+"small_loginimage.png"
    var file = await FileSystemUtil().getLocalFile(fileLocalPath);
    if (!file.existsSync()) {
      //print("The file $fileLocalPath does not exist.");
      return null;
    }
    String fileName = basename(file.path);
    var uint8list = file.readAsBytesSync();
    //print("Got The file $fileLocalPath going to add it");
    //add bytes to the catch
    var f = await FirebaseCacheManager().putFile(url, uint8list,
        eTag: "${fileName.split(".").first}",
        maxAge: Duration(days: 60),
        fileExtension: "${fileName.split(".").last}");
    return f;
  } catch (e) {
    print("Failed to add $url to firebase cache");
    return null;
  }
}


Future<File?> addFilePathToFirebaseCache(String url, File file) async {
  try {
    //read the local file - Like /images/$userId"+"small_loginimage.png"
    String fileName = basename(file.path);
    var uint8list = file.readAsBytesSync();
    //print("Got The file $fileLocalPath going to add it");
    //add bytes to the catch
    var f = await FirebaseCacheManager().putFile(url, uint8list,
        eTag: "${fileName.split(".").first}",
        maxAge: Duration(days: 60),
        fileExtension: "${fileName.split(".").last}");
    return f;
  } catch (e) {
    print("Failed to add $url to firebase cache");
    return null;
  }
}



const color1 = Color(0xff349141);
