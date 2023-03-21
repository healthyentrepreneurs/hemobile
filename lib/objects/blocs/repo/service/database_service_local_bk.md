import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:permission_handler/permission_handler.dart';

import '../fofiperm_repo.dart';

class DatabaseServiceLocal {
final FoFiRepository _foFiRepository = FoFiRepository();

dynamic courseJsonListFunc(String filePath) {
final file = _foFiRepository.getLocalFileHe(filePath);
debugPrint(
'DatabaseServiceLocal@retrieveSubscriptionDataLocalStream ${file.path} and Absolute ${file.absolute.toString()}');
String contents = file.readAsStringSync();
var courseJsonList = jsonDecode(contents);
return courseJsonList;
}

Stream<Either<Failure, List<Subscription?>>>
retrieveSubscriptionDataLocalStream() async* {
// add permission check here if not already granted ask for permission
if (await Permission.storage.request().isGranted) {
// if permission is granted
// read the file
try {
var courseJsonList =
courseJsonListFunc('/get_moodle_courses.json') as List;
List<Subscription>? listSubscription = courseJsonList
.map((tagJson) => Subscription.fromJson(tagJson))
.toList();
yield Right(listSubscription);
} catch (e) {
debugPrint(
"@DatabaseServiceLocal Database Offline Error: ${e.toString()}");
yield Left(RepositoryFailure(e.toString()));
}
} else {
debugPrint("DatabaseServiceLocal@TOBECONTINUED");
await requestPermission(Permission.storage);
}
}

Stream<Either<Failure, List<Section?>>> retrieveBookSectionLocal(
String courseId) async* {
try {
var sectionJson =
courseJsonListFunc('/next_link/get_details_percourse/$courseId.json')
as Map<String, dynamic>;
var sectionJsonList = sectionJson['data'] as List;
List<Section>? listSection =
sectionJsonList.map((tagJson) => Section.fromJson(tagJson)).toList();
yield Right(listSection);
} catch (e) {
debugPrint(
"@retrieveBookSectionLocal Database Offline Error: ${e.toString()}");
yield Left(RepositoryFailure(e.toString()));
}
}

Stream<Either<Failure, String>> retrieveBookSurveyLocal(
String courseId) async* {
try {
final file =
_foFiRepository.getLocalFileHe("/next_link/survey/$courseId.json");
String contents = file.readAsStringSync();
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
var sectionJson =
courseJsonListFunc('/next_link/get_details_percourse/$courseId.json')
as Map<String, dynamic>;
var bookquizJsonList =
sectionJson['data'][int.parse(section)]['modules'] as List;
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
var sectionJson =
courseJsonListFunc('/next_link/get_details_percourse/$courseId.json')
as Map<String, dynamic>;
var bookquizJsonList = sectionJson['data'][int.parse(section)]['modules']
[bookIndex]['contents'] as List;
List<BookContent> bookContentList = bookquizJsonList
.map((json) => BookContent.fromJson(json as Map<String, dynamic>,
readUrlFlag: false))
.toList();
debugPrint('Offline Tatiana ${bookContentList.toString()}');
yield Right(bookContentList);
} catch (e) {
debugPrint(
"retrieveBookChapterLocal We Have Errors Here ${e.toString()}");
yield Left(
RepositoryFailure("retrieveBookChapterLocalErrors ${e.toString()}"));
}
}
}
