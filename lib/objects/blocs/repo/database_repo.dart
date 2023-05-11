import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objectbox.g.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:he/service/objectbox_service.dart';
import 'package:he_storage/he_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'impl/idatabase_repo.dart';
import 'impl/repo_failure.dart';

@LazySingleton(as: IDatabaseRepository)
class DatabaseRepository implements IDatabaseRepository {
  final FirebaseFirestore _firestore;
  final ObjectBoxService _objectService;

  DatabaseRepository(this._firestore, this._objectService);

  DatabaseService _service() => DatabaseService(firestore: _firestore);
  final DatabaseServiceLocal _serviceLocal = DatabaseServiceLocal();

  DatabaseBoxOperations _boxOperations() => DatabaseBoxOperations(
      objectService: _objectService, firestore: _firestore);

  final BehaviorSubject<HenetworkStatus> _henetworkStatusSubject =
      BehaviorSubject<HenetworkStatus>.seeded(HenetworkStatus.loading);

  @override
  Stream<Either<Failure, List<Subscription?>>> retrieveSubscriptionDataStream(
      String userid) {
    final checkValue = _henetworkStatusSubject.valueOrNull;
    // checkValue != null &&
    if (checkValue == HenetworkStatus.wifiNetwork) {
      debugPrint('DatabaseRepository@retrieveSubscriptionDataStream connected');
      return _service().retrieveSubscriptionDataStream(userid);
    } else {
      debugPrint(
          'DatabaseRepository@retrieveSubscriptionDataStream not connected');
      return _serviceLocal.retrieveSubscriptionDataLocalStream();
    }
  }

  @override
  Future<void> addHenetworkStatus(HenetworkStatus status) async {
    _henetworkStatusSubject.add(status);
  }

  @override
  Stream<Either<Failure, List<Section?>>> retrieveBookSectionData(
      String courseid) {
    final checkValue = _henetworkStatusSubject.valueOrNull;
    // debugPrint('DatabaseRepository@retrieveBookSectionData $checkValue');
    if (checkValue == HenetworkStatus.wifiNetwork) {
      debugPrint('DatabaseRepository@retrieveBookSection Network $checkValue');
      return _service().retrieveBookSection(courseid);
    } else {
      debugPrint('DatabaseRepository@retrieveBookSection Nodata $checkValue');
      return _serviceLocal.retrieveBookSectionLocal(courseid);
    }
  }

  @override
  Stream<Either<Failure, String>> retrieveSurveyStream(String courseid) {
    final checkValue = _henetworkStatusSubject.valueOrNull;
    // debugPrint('DatabaseRepository@retrieveSurveyStream $checkValue');
    if (checkValue == HenetworkStatus.wifiNetwork) {
      debugPrint('DatabaseRepository@retrieveSurvey Network $checkValue');
      return _service().retrieveSurvey(courseid);
    } else {
      debugPrint(
          'DatabaseRepository@retrieveBookSurveyLocal Nodata $checkValue');
      return _serviceLocal.retrieveBookSurveyLocal(courseid);
    }
  }

  @override
  Stream<Either<Failure, List<BookQuiz?>>> retrieveBookQuiz(
      String courseId, String section) {
    final checkValue = _henetworkStatusSubject.valueOrNull;
    if (checkValue == HenetworkStatus.wifiNetwork) {
      debugPrint('DatabaseRepository@retrieveBookQuiz Network $checkValue');
      return _service().retrieveBookQuiz(courseId, section);
    } else {
      debugPrint('DatabaseRepository@retrieveBookQuizLocal Nodata $checkValue');
      return _serviceLocal.retrieveBookQuizLocal(courseId, section);
    }
  }

  @override
  Stream<Either<Failure, List<BookContent>>> retrieveBookChapter(
      String courseId, String section, String bookcontextid, int bookIndex) {
    debugPrint("WHERE ARE WE JACK");
    final checkValue = _henetworkStatusSubject.valueOrNull;
    if (checkValue == HenetworkStatus.wifiNetwork) {
      debugPrint('DatabaseRepository@retrieveBookChapter Network $checkValue');
      return _service().retrieveBookChapter(courseId, section, bookcontextid);
    } else {
      debugPrint(
          'DatabaseRepository@retrieveBookChapterLocal Nodata $checkValue');
      return _serviceLocal.retrieveBookChapterLocal(
          courseId, section, int.parse(bookcontextid), bookIndex);
    }
  }

  @override
  Future<Either<Failure, int>> saveSurveys(
      {required SurveyDataModel surveyData}) {
    debugPrint('DatabaseRepository@saveSurveys Nodata');
    return _boxOperations().saveSurveyOps(surveydata: surveyData);
  }

  @override
  Future<Either<Failure, int>> saveBookChapters({
    required String bookId,
    required String chapterId,
    required String courseId,
    required String userId,
    required bool isPending,
  }) async {
    debugPrint('DatabaseRepository@saveBookData Nodata');
    var book = BookDataModel(
      bookId: bookId,
      chapterId: chapterId,
      courseId: courseId,
      userId: userId,
      isPending: isPending,
    );
    return _boxOperations().saveBookChapterOps(bookdata: book);
  }

  // Add these methods to call uploadData, loadState, and saveState
  Future<void> uploadData() async {
    debugPrint("DatabaseRepository@uploadData  isUploadingData \n");
    await _boxOperations().uploadDataOps();
  }

  Future<Map<String, dynamic>?> loadState() async {
    return await _boxOperations().loadState();
  }

  Future<void> cleanUploadedData() async {
    await _boxOperations().deleteBooksAndSurveys();
  }

  Future<void> createDummyData() async {
    await _boxOperations().generateDummyDataWithFaker();
    // await _boxOperations().generateDummySurveysWithFaker();
  }

  Stream<BackupStateDataModel> getBackupStateDataModelStream() {
    return _objectService.backupUpdateStream();
  }

  Stream<List<SurveyDataModel>> getSurveysByPendingStatus(
      {required bool isPending}) {
    return _objectService.surveysByPendingStatus(isPending);
  }

  Stream<List<BookDataModel>> getBookChaptersByPendingStatus(
      {required bool isPending}) {
    return _objectService.booksByPendingStatus(isPending);
  }

  void dispose() {
    _henetworkStatusSubject.close();
    // _saveController.close();
    // tasksBroadcastStream.close();
  }
}
