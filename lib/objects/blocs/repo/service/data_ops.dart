import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:he/service/service.dart';
import 'package:he/objectbox.g.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';

class DatabaseBoxOperations {
  // final Store _store;
  final FirebaseFirestore _firestore;
  final ObjectBoxService _objectService;
  // DatabaseBoxOperations({
  //   required FirebaseFirestore firestore,
  //   required ObjectBoxService objectService,
  // })  : _objectService = objectService,
  //       _firestore = firestore;

  DatabaseBoxOperations({
    required FirebaseFirestore firestore,
    required ObjectBoxService objectService,
  })  : _objectService = objectService,
        _firestore = firestore {
    debugPrint("Updated-BackupStateDataModel: ");
    // _objectService.onSave.listen((BackupStateDataModel backupState) {
    //   // Handle the updated backup state data here
    //   // For example, you can print it:
    //   debugPrint("Updated-BackupStateDataModel: ${backupState.toJson()}");
    // });
  }

  Box<SurveyDataModel> get _surveyBox =>
      _objectService.store.box<SurveyDataModel>();
  Box<BookDataModel> get _bookDataBox =>
      _objectService.store.box<BookDataModel>();
  Box<BackupStateDataModel> get backupBox =>
      _objectService.store.box<BackupStateDataModel>();
  StreamSubscription<BackupStateDataModel>? _backupStateSubscription;
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

  // ## BACKUP STATUS LOCAL
  Future<void> uploadDataOps() async {
    BackupStateDataModel currentBackupState = _objectService.backupBox.get(1) ??
        BackupStateDataModel.defaultInstance();
    final newState = currentBackupState.copyWith(
      isUploadingData: true,
      backupAnimation: true,
    );
    debugPrint(
        "WALAHWA DatabaseBoxOperations@onUploadStateChanged OLD ${currentBackupState.toJson()} \n NEW ${newState.toJson()}");
    // await _objectService.save(backupdatamodel: newState);
    await savePendingSurveysToFirestoreAndSetNotPending();
    await _objectService.save(
        backupdatamodel: currentBackupState.copyWith(
            isUploadingData: false,
            backupAnimation: false,
            uploadProgress: 0.0));
  }

  Future<void> savePendingSurveysToFirestoreAndSetNotPending() async {
    List<SurveyDataModel> pendingSurveys =
    await getSurveysPendingStatusCTimeLimit(true);

    int totalPendingSurveys = pendingSurveys.length;
    int uploadedSurveys = 0;
    for (SurveyDataModel survey in pendingSurveys) {
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
          bool _isUploading = true;
          bool _backupAnimation = true;
          bool _surveyAnimation = true;
          // await updateSurvey(survey);
          uploadedSurveys++;
          // Update the upload progress
          double progress = uploadedSurveys / totalPendingSurveys;
          debugPrint(
              "SHOW ME progress $progress _isUploading $_isUploading $_backupAnimation");
          if (progress >= 1) {
            progress = 0.0;
            _isUploading = false;
            _backupAnimation = false;
            _surveyAnimation = false;
          }
          BackupStateDataModel currentBackupState =
              _objectService.backupBox.get(1) ??
                  BackupStateDataModel.defaultInstance();
          debugPrint(
              "PREVIOUSCOPYME WORK PREVIOUS ${currentBackupState.toJson()}");

          currentBackupState = currentBackupState.copyWith(
              isUploadingData: _isUploading,
              uploadProgress: progress,
              backupAnimation: _backupAnimation,
              surveyAnimation: _surveyAnimation,
              booksAnimation: false,
              dateCreated: DateTime.now());
          debugPrint(
              "CURRENTCOPYME WORK PREVIOUS ${currentBackupState.toJson()}");

          _objectService.store.runInTransaction(TxMode.write, () {
            _objectService.save(backupdatamodel: currentBackupState);
          });
        },
      );
    }
    debugPrint("Total uploaded surveys simulated: $uploadedSurveys");
    _backupStateSubscription?.cancel();
  }

  // Future<Map<String, dynamic>?> loadState() async {
  //   // generateDummySurveysWithFaker();
  //
  //   final data = backupBox.query().build().findFirst();
  //   return data.toJson() ?? defaultNaUpdate.toJson();
  //   return defaultNaUpdate?.toJson();
  // }

  Future<Map<String, dynamic>?> loadState() async {
    // generateDummySurveysWithFaker();
    debugPrint("MEHME");
    final completer = Completer<Map<String, dynamic>?>();
    StreamSubscription? subscription;
    subscription = _objectService.tasksBroadcastStream.listen((query) {
      final data = query.findFirst();
      if (!completer.isCompleted) {
        completer.complete(
            data?.toJson() ?? BackupStateDataModel.defaultInstance().toJson());
        subscription?.cancel();
      }
    }, cancelOnError: true);

    return completer.future;
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

  List<BackupStateDataModel> generateDummyBackupStatesWithFaker() {
    const int numOfBackupStates = 100;
    final faker = Faker();

    List<BackupStateDataModel> dummyBackupStates = [];
    for (int i = 0; i < numOfBackupStates; i++) {
      var backupState = BackupStateDataModel(
        id: 1,
        uploadProgress: faker.randomGenerator.decimal(min: 2),
        isUploadingData: faker.randomGenerator.boolean(),
        backupAnimation: faker.randomGenerator.boolean(),
        surveyAnimation: faker.randomGenerator.boolean(),
        booksAnimation: faker.randomGenerator.boolean(),
        dateCreated: faker.date.dateTime(minYear: 2020, maxYear: 2023),
      );
      // addBackupState(backupState); // If you have a function to add the backup state to the database or collection, uncomment this line.
      dummyBackupStates.add(backupState);
    }

    return dummyBackupStates;
  }

  Future<List<BackupStateDataModel>> deleteRecordsWithIdNotOne() async {
    final query =
    backupBox.query(BackupStateDataModel_.id.notEquals(100)).build();
    final backupStates = query.find();
    query.close();
    return backupStates;
  }

  Future<void> removeBackupState(BackupStateDataModel backup) async {
    try {
      // Delete the survey from the ObjectBox store
      backupBox.remove(backup.id);
    } catch (e) {
      // Handle any error that might occur during the deletion process
      debugPrint("removeSurvey@Error removing survey: $e");
    }
  }

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
