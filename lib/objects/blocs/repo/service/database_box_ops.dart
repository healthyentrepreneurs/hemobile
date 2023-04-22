import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objectbox.g.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:objectbox/objectbox.dart';

// https://docs.objectbox.io/entity-annotations
class DatabaseBoxOperations {
  final Store _store;
  DatabaseBoxOperations({
    required Store store,
  }) : _store = store;

  // BOOK LOCAL SAVING
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

  //BACKUP STATUS LOCAL
  Future<void> uploadDataOps({
    required bool isUploadingData,
    required double uploadProgress,
    bool simulateUpload = true,
    required Function(bool, double) onUploadStateChanged,
  }) async {
    debugPrint("DatabaseBoxOperations@uploadDataOps $isUploadingData");
    if (simulateUpload) {
      // Set isUploadingData to true when the upload starts
      isUploadingData = true;
      // Resume data upload from the last saved progress (use your own upload logic here)
      for (int i = (uploadProgress * 100).toInt(); i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 30));
        uploadProgress = i / 100;
        onUploadStateChanged(isUploadingData, uploadProgress);
      }
      // Set isUploadingData to false when the upload is complete
      isUploadingData = false;
      uploadProgress = 0.0;
      debugPrint(
          "BEFORE DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
      onUploadStateChanged(isUploadingData, uploadProgress);
      debugPrint(
          "AFTER DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
    }

    saveState(
      isUploadingData: false,
      uploadProgress: 0.0,
      backupAnimation: false,
      surveyAnimation: false,
      booksAnimation: false,
    );
  }

  Future<Map<String, dynamic>?> loadState() async {
    final box = Box<BackupStateDataModel>(_store);
    final data = box.query().build().findFirst();
    return data?.toJson();
  }

  Future<void> saveState({
    bool? isUploadingData,
    double? uploadProgress,
    bool? backupAnimation,
    bool? surveyAnimation,
    bool? booksAnimation,
  }) async {
    final box = Box<BackupStateDataModel>(_store);
    final results = box.query().build().find();
    if (results.isEmpty) {
      debugPrint(
          "isEmpty DatabaseBoxOperations@saveState $isUploadingData and $uploadProgress \n");
      final data = BackupStateDataModel(
        isUploadingData: isUploadingData ?? false,
        uploadProgress: uploadProgress ?? 0.0,
        backupAnimation: backupAnimation ?? false,
        surveyAnimation: surveyAnimation ?? false,
        booksAnimation: booksAnimation ?? false,
      );
      box.put(data);
    } else {
      final existingData = results.first;
      final updatedData = BackupStateDataModel(
        id: existingData.id, // Ensure to keep the existing ID for update
        isUploadingData: isUploadingData ?? existingData.isUploadingData,
        uploadProgress: uploadProgress ?? existingData.uploadProgress,
        backupAnimation: backupAnimation ?? existingData.backupAnimation,
        surveyAnimation: surveyAnimation ?? existingData.surveyAnimation,
        booksAnimation: booksAnimation ?? existingData.booksAnimation,
      );
      debugPrint(
          "Updating DatabaseBoxOperations@saveState $isUploadingData and $uploadProgress \n");
      box.put(updatedData);
    }
  }
}
