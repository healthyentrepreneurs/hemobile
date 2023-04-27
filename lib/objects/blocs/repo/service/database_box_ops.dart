import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/src/native/query/query.dart' as boxquery;
import 'package:he/objectbox.g.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:rxdart/rxdart.dart';

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
  Box<BackupStateDataModel> get _backupBox =>
      _store.box<BackupStateDataModel>();

  final BehaviorSubject<double> _uploadProgressSubject =
      BehaviorSubject.seeded(0.0);
  final BehaviorSubject<bool> _isUploadingDataSubject =
      BehaviorSubject.seeded(false);

  Stream<double> get uploadProgressStream => _uploadProgressSubject.stream;
  Stream<bool> get isUploadingDataStream => _isUploadingDataSubject.stream;

  // ## BOOK LOCAL SAVING

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

  // ## SURVEY LOCAL SAVING

  Future<int> addSurvey(SurveyDataModel survey) async {
    return _surveyBox.put(survey);
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

  Future<Either<Failure, int>> saveSurveyData(
      {required SurveyDataModel surveydata}) {
    try {
      return Future.value(
          Right(_surveyBox.put(surveydata))); // Return success value
    } catch (e) {
      debugPrint("Error saving saveSurveyData response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Future<List<SurveyDataModel>> getSurveysByPendingStatus(
      bool isPending) async {
    final query =
        _surveyBox.query(SurveyDataModel_.isPending.equals(isPending)).build();
    final surveys = query.find();
    query.close();
    return surveys;
  }

  Stream<Either<Failure, int>> get totalSavedSurveyData {
    return Stream.fromFuture(_countPendingSurveys());
  }

  //Survey Helper Classes
  Future<Either<Failure, int>> _countPendingSurveys() async {
    try {
      final listSurveys = await getSurveysByPendingStatus(true);
      return Right(listSurveys.length);
    } catch (error) {
      return Left(RepositoryFailure(error.toString()));
    }
  }

  Future<List<SurveyDataModel>> getSurveysPendingStatusCTimeLimit(
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

  Future<void> savePendingSurveysToFirestoreAndSetNotPending({
    required Function(double) onUploadProgressChanged,
  }) async {
    List<SurveyDataModel> pendingSurveys =
        await getSurveysPendingStatusCTimeLimit(true);

    int totalPendingSurveys = pendingSurveys.length;
    int uploadedSurveys = 0;

    for (SurveyDataModel survey in pendingSurveys) {
      // await Future.delayed(const Duration(milliseconds: 500));
      Either<Failure, void> result = await saveSurveysFireStore(
        surveyId: survey.surveyId,
        country: survey.country,
        userId: survey.userId,
        surveyJson: survey.surveyObject,
        surveyVersion: survey.surveyVersion,
      );
      result.fold(
        (failure) {
          debugPrint("SALOME Failed to upload survey: $failure");
        },
        (_) async {
          // Update the isPending flag to false
          survey.isPending = false;
          // await updateSurvey(survey);
          uploadedSurveys++;
          // Update the upload progress
          double progress = uploadedSurveys / totalPendingSurveys;
          onUploadProgressChanged(progress);
        },
      );
    }
    debugPrint("Total uploaded surveys simulated: $uploadedSurveys");
  }

  Future<void> savePendingSurveysToFirestoreAndSetNotPendingSimulated({
    required Function(double) onUploadProgressChanged,
  }) async {
    int totalSteps = 100;
    int uploadedSurveysSimulated = 0;

    for (int i = 1; i <= totalSteps; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      double progress = i / totalSteps;
      onUploadProgressChanged(progress);
      uploadedSurveysSimulated++;
    }
    debugPrint("Total uploaded surveys simulated: $uploadedSurveysSimulated");
  }

  // ## BACKUP STATUS LOCAL

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
      onUploadStateChanged(isUploadingData, uploadProgress);
      await savePendingSurveysToFirestoreAndSetNotPendingSimulated(
        onUploadProgressChanged: (progress) {
          uploadProgress = progress;
          debugPrint(
              "WALAH DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
          onUploadStateChanged(isUploadingData, uploadProgress);
        },
      );
      // Set isUploadingData to false when the upload is complete
      isUploadingData = false;
      uploadProgress = 0.0;
      onUploadStateChanged(isUploadingData, uploadProgress);
      debugPrint(
          "AFTER DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
    } else {
      // Set isUploadingData to true when the upload starts
      isUploadingData = true;
      onUploadStateChanged(isUploadingData, uploadProgress);
      debugPrint(
          "CHECHE DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
      // Call the savePendingSurveysToFirestoreAndSetNotPending method with the progress update callback
      await savePendingSurveysToFirestoreAndSetNotPending(
        onUploadProgressChanged: (progress) {
          uploadProgress = progress;
          debugPrint(
              "WALAH DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
          onUploadStateChanged(isUploadingData, uploadProgress);
        },
      );
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
    // generateDummySurveysWithFaker();
    final data = _backupBox.query().build().findFirst();
    return data?.toJson();
  }

  Future<List<BackupStateDataModel>> deleteRecordsWithIdNotOne() async {
    final query =
        _backupBox.query(BackupStateDataModel_.id.notEquals(100)).build();
    final backupStates = query.find();
    query.close();
    return backupStates;
  }

  Future<void> removeBackupState(BackupStateDataModel backup) async {
    try {
      // Delete the survey from the ObjectBox store
      _backupBox.remove(backup.id);
    } catch (e) {
      // Handle any error that might occur during the deletion process
      debugPrint("removeSurvey@Error removing survey: $e");
    }
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
      debugPrint("DatabaseBoxOperations@saveState@else ${results.toString()}");
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

  // ## FIRESTORE-LOCAL MIRROR

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
}
