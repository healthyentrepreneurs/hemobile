import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objectbox.g.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';

class DatabaseBoxOperations {
  final Store _store;
  final FirebaseFirestore _firestore;
  DatabaseBoxOperations({
    required FirebaseFirestore firestore,
    required Store store,
  })  : _store = store,
        _firestore = firestore;

  Box<SurveyDataModel> get _surveyBox => _store.box<SurveyDataModel>();
  Box<BookDataModel> get _bookDataBox => _store.box<BookDataModel>();

  // BOOK LOCAL SAVING
  Future<Either<Failure, int>> saveBookData({
    required String bookId,
    required String chapterId,
    required String courseId,
    required String userId,
    required bool isPending,
  }) async {
    return _handleBookDataModel(BookDataModel(
      bookId: bookId,
      chapterId: chapterId,
      courseId: courseId,
      userId: userId,
      isPending: isPending,
    ));
  }

  Future<Either<Failure, int>> _handleBookDataModel(
      BookDataModel bookDataModel) async {
    try {
      return Future.value(
          Right(_bookDataBox.put(bookDataModel))); // Return success value
    } catch (e) {
      debugPrint("Error saving saveBookData response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  // SURVEY LOCAL SAVING

  Future<int> addSurvey(SurveyDataModel survey) async {
    return _surveyBox.put(survey);
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
    final surveyDataModel = SurveyDataModel(
      userId: userId,
      surveyVersion: surveyVersion,
      courseId: courseId,
      surveyId: surveyId,
      isPending: isPending,
      country: country,
      surveyObject: surveyObject,
    );
    return _handleSurveyDataModel(surveyDataModel);
  }

  Future<Either<Failure, int>> _handleSurveyDataModel(
      SurveyDataModel surveyDataModel) async {
    try {
      return Future.value(
          Right(_surveyBox.put(surveyDataModel))); // Return success value
    } catch (e) {
      debugPrint("Error saving saveSurveyData response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  // BACKUP STATUS LOCAL

  Box<BackupStateDataModel> _getBackupStateBox() =>
      _store.box<BackupStateDataModel>();

  Future<Map<String, dynamic>?> loadState() async {
    // generateDummySurveysWithFaker();
    final box = _getBackupStateBox();
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
    final box = _getBackupStateBox();
    final results = box.query().build().find();
    final BackupStateDataModel updatedData = _handleBackupState(
      results,
      isUploadingData: isUploadingData,
      uploadProgress: uploadProgress,
      backupAnimation: backupAnimation,
      surveyAnimation: surveyAnimation,
      booksAnimation: booksAnimation,
    );
    box.put(updatedData);
  }

  BackupStateDataModel _handleBackupState(
    List<BackupStateDataModel> results, {
    bool? isUploadingData,
    double? uploadProgress,
    bool? backupAnimation,
    bool? surveyAnimation,
    bool? booksAnimation,
  }) {
    if (results.isEmpty) {
      debugPrint(
          "isEmpty DatabaseBoxOperations@saveState $isUploadingData and $uploadProgress \n");
      return BackupStateDataModel(
        isUploadingData: isUploadingData ?? false,
        uploadProgress: uploadProgress ?? 0.0,
        backupAnimation: backupAnimation ?? false,
        surveyAnimation: surveyAnimation ?? false,
        booksAnimation: booksAnimation ?? false,
      );
    } else {
      final existingData = results.first;
      return BackupStateDataModel(
        id: existingData.id, // Ensure to keep the existing ID for update
        isUploadingData: isUploadingData ?? existingData.isUploadingData,
        uploadProgress: uploadProgress ?? existingData.uploadProgress,
        backupAnimation: backupAnimation ?? existingData.backupAnimation,
        surveyAnimation: surveyAnimation ?? existingData.surveyAnimation,
        booksAnimation: booksAnimation ?? existingData.booksAnimation,
      );
    }
  }

  //FIRESTORE-LOCAL MIRROR

  Future<Either<Failure, void>> saveSurveysFireStore({
    required String surveyId,
    required String country,
    required String userId,
    required String surveyJson,
    required String surveyVersion,
  }) async {
    try {
      await _saveSurveyToFirestore(
        surveyId: surveyId,
        country: country,
        userId: userId,
        surveyJson: surveyJson,
        surveyVersion: surveyVersion,
      );
      return Future.value(const Right(null)); // Return success value
    } catch (e) {
      debugPrint("Error saving survey response: ${e.toString()}");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Future<void> _saveSurveyToFirestore({
    required String surveyId,
    required String country,
    required String userId,
    required String surveyJson,
    required String surveyVersion,
  }) async {
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
  }

  Future<void> removeSurvey(SurveyDataModel survey) async {
    try {
      // Delete the survey from the ObjectBox store
      _surveyBox.remove(survey.id);
    } catch (e) {
      // Handle any error that might occur during the deletion process
      debugPrint("removeSurvey@Error removing survey: $e");
    }
  }
}
