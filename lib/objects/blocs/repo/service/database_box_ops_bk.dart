import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:he/objectbox.g.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:objectbox/objectbox.dart';

// https://docs.objectbox.io/entity-annotations
class DatabaseBoxOperationsXX {
  final Store _store;
  final FirebaseFirestore _firestore;
  DatabaseBoxOperationsXX({
    required FirebaseFirestore firestore,
    required Store store,
  })  : _store = store,
        _firestore = firestore;
  Box<SurveyDataModel> get _surveyBox => _store.box<SurveyDataModel>();
  Box<BookDataModel> get _bookBox => _store.box<BookDataModel>();
  Box<BackupStateDataModel> get _backupBox =>
      _store.box<BackupStateDataModel>();

// BOOK LOCAL OPERATIONS
  Future<Either<Failure, int>> saveBookData({
    required String bookId,
    required String chapterId,
    required String courseId,
    required String userId,
    required bool isPending,
  }) async {
// final bookDataBox = _store.box<BookDataModel>();
    try {
      final bookDataModel = BookDataModel(
        bookId: bookId,
        chapterId: chapterId,
        courseId: courseId,
        userId: userId,
        isPending: isPending,
      );
      return Future.value(
          Right(_bookBox.put(bookDataModel))); // Return success value
    } catch (e) {
      debugPrint("Error saving saveBookData response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

// SURVEY-LOCAL OPERATIONS

// Add a new SurveyDataModel
  Future<int> addSurvey(SurveyDataModel survey) async {
    return _surveyBox.put(survey);
  }

// Get all surveys
  Future<List<SurveyDataModel>> getAllSurveys() async {
    return _surveyBox.getAll();
  }

// Get a specific survey by its id
  Future<SurveyDataModel?> getSurveyById(int id) async {
    return _surveyBox.get(id);
  }

// Update a survey
  Future<void> updateSurvey(SurveyDataModel survey) async {
    _surveyBox.put(survey);
  }

// Delete a survey
  Future<void> deleteSurvey(int id) async {
    _surveyBox.remove(id);
  }

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
// final surveyDataBox = _store.box<SurveyDataModel>();
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
          Right(_surveyBox.put(surveyDataModel))); // Return success value
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
// final box = Box<SurveyDataModel>(_store);
      final count = _surveyBox
          .query(SurveyDataModel_.isPending.equals(true))
          .build()
          .count();
      return Right(count);
    } catch (error) {
      return Left(RepositoryFailure(error.toString()));
    }
  }

// Query surveys by a specific field, e.g., isPending
  Future<List<SurveyDataModel>> getSurveysByPendingStatus(
      bool isPending) async {
    final query =
        _surveyBox.query(SurveyDataModel_.isPending.equals(isPending)).build();
    final surveys = query.find();
    query.close();
    return surveys;
  }

// Query surveys by a specific field, e.g., isPending, with a dateCreated limit set to the current time
  Future<List<SurveyDataModel>> getSurveysByPendingStatusWithCurrentTimeLimit(
      bool isPending) async {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final query = _surveyBox
        .query(SurveyDataModel_.isPending
            .equals(isPending)
            .and(SurveyDataModel_.dateCreated.lessOrEqual(currentTimeMillis)))
        .build();
    final surveys = query.find();
    query.close();
    return surveys;
  }

  Future<Map<String, int>>
      savePendingSurveysToFirestoreAndSetNotPending() async {
    int totalPendingSurveys = 0;
    int uploadedSurveys = 0;

    List<SurveyDataModel> pendingSurveys =
        await getSurveysByPendingStatusWithCurrentTimeLimit(true);
    totalPendingSurveys = pendingSurveys.length;

    for (SurveyDataModel survey in pendingSurveys) {
      Either<Failure, void> result = await saveSurveysfireStore(
        surveyId: survey.surveyId,
        country: survey.country,
        userId: survey.userId,
        surveyJson: survey.surveyObject,
        surveyVersion: survey.surveyVersion,
      );

      result.fold(
        (failure) {
          debugPrint("Failed to upload survey: $failure");
        },
        (_) async {
          // Update the isPending flag to false
          survey.isPending = false;
          await updateSurvey(survey);
          uploadedSurveys++;
        },
      );
    }

    return {'total': totalPendingSurveys, 'uploaded': uploadedSurveys};
  }

  List<SurveyDataModel> generateDummySurveysWithFaker() {
    const int numOfSurveys = 100;
    final faker = Faker();

    List<SurveyDataModel> dummySurveys = [];
    for (int i = 0; i < numOfSurveys; i++) {
      var namu = SurveyDataModel(
        userId: faker.guid.guid(),
        surveyVersion: faker.randomGenerator.decimal(min: 1).toString(),
        surveyObject:
            '{"question1": "${faker.lorem.word()}", "question2": "${faker.lorem.word()}"}',
        surveyId: faker.guid.guid(),
        isPending: faker.randomGenerator.boolean(),
        courseId: faker.guid.guid(),
        country: faker.address.country(),
      );
      addSurvey(namu);
      dummySurveys.add(namu);
    }

    return dummySurveys;
  }

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
        await Future.delayed(const Duration(milliseconds: 200));
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
    } else {
      // Set isUploadingData to true when the upload starts
      isUploadingData = true;

      // Call the savePendingSurveysToFirestoreAndSetNotPending method
      Map<String, int> uploadResult =
          await savePendingSurveysToFirestoreAndSetNotPending();

      // Calculate the upload progress
      if (uploadResult['total']! > 0) {
        uploadProgress = uploadResult['uploaded']! / uploadResult['total']!;
      } else {
        uploadProgress = 1.0;
      }

      onUploadStateChanged(isUploadingData, uploadProgress);

      // Set isUploadingData to false when the upload is complete
      isUploadingData = false;
      uploadProgress = 0.0;
      onUploadStateChanged(isUploadingData, uploadProgress);
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
    generateDummySurveysWithFaker();
    final data = _backupBox.query().build().findFirst();
    return data?.toJson();
  }

  Future<void> saveState({
    bool? isUploadingData,
    double? uploadProgress,
    bool? backupAnimation,
    bool? surveyAnimation,
    bool? booksAnimation,
  }) async {
// final box = Box<BackupStateDataModel>(_store);
    final results = _backupBox.query().build().find();
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
      _backupBox.put(data);
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
      _backupBox.put(updatedData);
    }
  }

//FIREBASE MIRROR OPERATIONS
  Future<Either<Failure, void>> saveSurveysfireStore({
    required String surveyId,
    required String country,
    required String userId,
    required String surveyJson,
    required String surveyVersion,
  }) async {
    try {
      await _firestore
          .collection('surveyposts')
          .doc(country)
          .collection(surveyId)
          .add({
        'userId': userId,
        'surveyVersion': surveyVersion,
        'surveyobject': surveyJson,
        'surveyId': surveyId,
      });
      return Future.value(const Right(null)); // Return success value
    } catch (e) {
      debugPrint("Error saving survey response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

// ... other methods ...
}
