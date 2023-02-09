import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';

class DatabaseServiceLocal {

  final _mainOfflinePath = FileSystemUtil().extDownloadsPath;
  // Future<List<Subscription>?> retrieveSubscriptionDataLocal() async {
  //   String heDirectory = "${await _mainOfflinePath}/HE_Health/";
  //   final file = File("${heDirectory}get_moodle_courses.json");
  //   String contents = await file.readAsString();
  //   var courseJsonList = jsonDecode(contents) as List;
  //   List<Subscription>? listSubscription = courseJsonList
  //       .map((tagJson) => Subscription.fromJson(tagJson))
  //       .toList();
  //   return listSubscription;
  // }

   Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionDataLocal() async {
    try {

      String heDirectory = "${await _mainOfflinePath}/HE_Health/";
      final file = File("${heDirectory}get_moodle_courses.json");
      String contents = await file.readAsString();
      var courseJsonList = jsonDecode(contents) as List;
      List<Subscription>? listSubscription = courseJsonList
          .map((tagJson) => Subscription.fromJson(tagJson))
          .toList();
      return Right(listSubscription);
    } catch (e) {
      debugPrint("@DatabaseServiceLocal Database Offline Error: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }
}
