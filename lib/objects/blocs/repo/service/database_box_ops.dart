import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objectbox.g.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:objectbox/objectbox.dart';

// https://docs.objectbox.io/entity-annotations
// https://dev.to/theimpulson/persistent-local-database-with-objectbox-on-flutter-k5g
class DatabaseBoxOperations {
  final Store _store;
  DatabaseBoxOperations({
    required Store store,
  }) : _store = store;

  Future<Either<Failure, int>> saveBookData({
    required String bookId,
    required String chapterId,
    required String courseId,
    required String userId,
    required bool isPending,
  }) async {
    final bookDataBox = _store.box<BookDataModel>();
    try {
      final bookDataModel = BookDataModel(
        bookId: bookId,
        chapterId: chapterId,
        courseId: courseId,
        userId: userId,
        isPending: isPending,
      );
      return Future.value(
          Right(bookDataBox.put(bookDataModel))); // Return success value
    } catch (e) {
      debugPrint("Error saving saveBookData response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

// SURVEY LOCAL SAVING

  Future<Either<Failure, int>> saveSurveyData({
    required String surveyId,
    required String country,
    required String userId,
    required String surveyVersion,
    required String surveyJson,
    required bool isPending,
    required String courseId,
    required String surveyObject,
  }) {
    final surveyDataBox = _store.box<SurveyDataModel>();
    try {
      final surveyDataModel = SurveyDataModel(
          userId: userId,
          surveyVersion: surveyVersion,
          courseId: courseId,
          surveyId: surveyId,
          isPending: isPending,
          country: country,
          surveyObject: surveyObject);
      return Future.value(
          Right(surveyDataBox.put(surveyDataModel))); // Return success value
    } catch (e) {
      debugPrint("Error saving saveBookData response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Stream<Either<Failure, int>> get totalSavedSurveyData {
    return Stream.fromFuture(_countPendingSurveys());
  }

  //Survey Helper Classes
  Future<Either<Failure, int>> _countPendingSurveys() async {
    try {
      final box = Box<SurveyDataModel>(_store);
      final count =
          box.query(SurveyDataModel_.isPending.equals(true)).build().count();
      return Right(count);
    } catch (error) {
      return Left(RepositoryFailure(error.toString()));
    }
  }
}
