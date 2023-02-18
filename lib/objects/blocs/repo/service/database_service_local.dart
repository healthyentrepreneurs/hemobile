import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:async_zip/async_zip.dart';

class DatabaseServiceLocal {
  final _mainOfflinePath = FileSystemUtil().extDownloadsPath;

  Stream<Either<Failure, List<Subscription?>>>
      retrieveSubscriptionDataLocalStream() async* {
    try {
      String heDirectory = "${await _mainOfflinePath}/HE_Health/";
      final file = File("${heDirectory}get_moodle_courses.json");
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
  }

  Stream<Either<Failure, List<Subscription?>>>
      retrieveSubscriptionDataLocalStream2() async* {
    final reader = ZipFileReaderAsync();
    try {
      String heDirectory = "${await _mainOfflinePath}/2644HE_Health.zip";
      reader.open(File(heDirectory));
      // final data =await reader.readToFile('get_moodle_courses.json', File('get_moodle_courses.json'));
      final data = await reader.read('get_moodle_courses.json');
      // convert the data to a string
      final String contents = String.fromCharCodes(data);
      var courseJsonList = jsonDecode(contents) as List;
      List<Subscription>? listSubscription = courseJsonList
          .map((tagJson) => Subscription.fromJson(tagJson))
          .toList();
      yield Right(listSubscription);
    } on ZipException catch (ex) {
      // print('Could not read Zip file: ${ex.message}');
      debugPrint("@DatabaseServiceLocal222 Database Offline Error: $ex");
      yield Left(RepositoryFailure(ex.message));
    } finally {
      await reader.close();
      // debugPrint("@DatabaseServiceLocal222X Database Offline Error:");
      // yield Left(RepositoryFailure('Can Not Open File'));
    }
  }

  Stream<Either<Failure, List<Subscription?>>>
  retrieveSubscriptionDataLocalStream3() async* {
    // final pathToZipFile = 'path/to/zip/file.zip';
    // final fileName = 'file/to/read.txt';
    try {
      String pathToZipFile = "${await _mainOfflinePath}/2644HE_Health.zip";
      const fileName = 'get_moodle_courses.json';
      final fileContents = await readZipFile(pathToZipFile, fileName);
      // convert the data to a string
      final String contents = String.fromCharCodes(fileContents);
      var courseJsonList = jsonDecode(contents) as List;
      List<Subscription>? listSubscription = courseJsonList
          .map((tagJson) => Subscription.fromJson(tagJson))
          .toList();
      yield Right(listSubscription);
    } on Exception catch (ex) {
      debugPrint("@DatabaseServiceLocal333 Database Offline Error: $ex");
      yield Left(RepositoryFailure(ex.toString()));
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

  Future<List<int>> readZipFile(String pathToZipFile, String fileName) async {
    final bytes = await File(pathToZipFile).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    // create a List<int> variable to store the file content
    List<int> file = [];
    for (final _file in archive) {
      if (_file.name == fileName) {
        file = _file.content as List<int>;
        break;
      }
    }
    return file;
  }
}
