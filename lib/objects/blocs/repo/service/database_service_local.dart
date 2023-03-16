import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:permission_handler/permission_handler.dart';

import '../fofiperm_repo.dart';

class DatabaseServiceLocal {
  final _mainOfflinePath = FileSystemUtil().extDownloadsPath;
  final FoFiRepository _foFiRepository = FoFiRepository();
  Stream<Either<Failure, List<Subscription?>>>
      retrieveSubscriptionDataLocalStream() async* {
    // add permission check here if not already granted ask for permission
    if (await Permission.storage.request().isGranted) {
      // if permission is granted
      // read the file
      try {
        String heDirectory = "${await _mainOfflinePath}/HE_Health/";
        final file = File("${heDirectory}get_moodle_courses.json");
        debugPrint(
            'DatabaseServiceLocal@retrieveSubscriptionDataLocalStream ${file.path} and Absolute ${file.absolute.toString()}');
        String contents = await file.readAsString();
        var courseJsonList = jsonDecode(contents) as List;
        List<Subscription>? listSubscription = courseJsonList
            .map((tagJson) => Subscription.fromJson(tagJson))
            .toList();
        yield Right(listSubscription);
      } catch (e) {
        debugPrint("@DatabaseServiceLocal Database Offline Error: $e");
        yield Left(RepositoryFailure(e.toString()));
      }
    } else {
      debugPrint("DatabaseServiceLocal@TOBECONTINUED");
      await requestPermission(Permission.storage);
    }
  }

  Future<Either<Failure, List<Subscription?>>>
      retrieveSubscriptionDataLocal() async {
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

  // retrieveBookSectionLocal(String courseid) async {
  //   try {
  //     final file = _foFiRepository
  //         .getLocalFileHe("/next_link/get_details_percourse/2.json");
  //     String contents = await file.readAsString();
  //     var sectionJson = jsonDecode(contents);
  //     var sectionJsonList = sectionJson['data'] as List;
  //     debugPrint('Tatiana ${sectionJsonList.toString()}');
  //     List<Section>? listSection =
  //     sectionJsonList.map((tagJson) => Section.fromJson(tagJson)).toList();
  //   } catch (e) {
  //     debugPrint("@retrieveBookSectionLocal Database Offline Error: $e");
  //   }
  // }
  Stream<Either<Failure, List<Section?>>> retrieveBookSectionLocal(
      String courseid) async* {
    try {
      final file = _foFiRepository
          .getLocalFileHe("/next_link/get_details_percourse/$courseid.json");
      String contents = await file.readAsString();
      var sectionJson = jsonDecode(contents);
      var sectionJsonList = sectionJson['data'] as List;
      // debugPrint('Tatiana ${sectionJsonList.toString()}');
      List<Section>? listSection =
          sectionJsonList.map((tagJson) => Section.fromJson(tagJson)).toList();
      yield Right(listSection);
    } catch (e) {
      debugPrint("@retrieveBookSectionLocal Database Offline Error: $e");
      yield Left(RepositoryFailure(e.toString()));
    }
  }

  Stream<Either<Failure, String>> retrieveBookSurveyLocal(
      String courseid) async* {
    try {
      final file =
          _foFiRepository.getLocalFileHe("/next_link/survey/$courseid.json");
      String contents = await file.readAsString();
      if (contents.isEmpty) {
        debugPrint('retrieveBookSurveyLocal No Surveys Data');
        yield Left(RepositoryFailure('No Surveys Data'));
      }
      // debugPrint('Tatiana $contents');
      yield Right(contents);
    } catch (e) {
      debugPrint("@retrieveBookSurveyLocal Database Offline Error: $e");
      yield Left(RepositoryFailure(e.toString()));
    }
  }

  Stream<Either<Failure, List<BookQuiz?>>> retrieveBookQuizLocal(
      String courseId, String section) async* {
    try {
      final file = _foFiRepository
          .getLocalFileHe("/next_link/get_details_percourse/$courseId.json");
      String contents = await file.readAsString();
      var sectionJson = jsonDecode(contents);
      var bookquizJsonList =
          sectionJson['data'][int.parse(section)]['modules'] as List;
      // debugPrint('Jeje Tatiana ${bookquizJsonList.toString()}');
      List<BookQuiz>? listbookQuiz = bookquizJsonList
          .map((tagJson) => BookQuiz.fromJson(tagJson))
          .toList();
      yield Right(listbookQuiz);
    } catch (e) {
      debugPrint("retrieveBookQuizLocal We Have Errors Here");
      yield Left(RepositoryFailure(e.toString()));
    }
  }

  Stream<Either<Failure, List<BookContent>>> retrieveBookChapterLocal(
      String courseId,
      String section,
      int bookContextId,
      int bookIndex) async* {
    try {
      debugPrint(
          "NJOVU courseId $courseId and section $section then $bookIndex");
      final file = _foFiRepository
          .getLocalFileHe("/next_link/get_details_percourse/$courseId.json");
      String contents = await file.readAsString();
      var sectionJson = jsonDecode(contents);
      var bookquizJsonList =
          sectionJson['data'][int.parse(section)]['modules'] as List;
      var bookContentJsonList =
          bookquizJsonList.elementAt(bookIndex)['contents'] as List;
      // List<BookContent> bookContentList = bookContentJsonList
      //     .map((json) => BookContent.fromJson(json as Map<String, dynamic>))
      //     .toList();
      List<BookContent> bookContentList = bookContentJsonList
          .map((json) => BookContent.fromJson(json as Map<String, dynamic>, readUrlFlag: false))
          .toList();
      debugPrint('Offline Tatiana ${bookContentList.toString()}');
      yield Right(bookContentList);
    } catch (e) {
      debugPrint(
          "retrieveBookChapterLocal We Have Errors Here ${e.toString()}");
      yield Left(RepositoryFailure("$e FuckOfMADOKO"));
    }
  }
}
