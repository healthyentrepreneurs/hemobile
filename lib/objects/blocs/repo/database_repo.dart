import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:he/service/objectbox_service.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helper/file_system_util.dart';
import 'impl/idatabase_repo.dart';
import 'impl/repo_failure.dart';

@LazySingleton(as: IDatabaseRepository)
class DatabaseRepository implements IDatabaseRepository {
  final FirebaseFirestore _firestore;
  final ObjectBoxService _objectbox;
  DatabaseRepository(this._firestore, this._objectbox);
  final BehaviorSubject<HenetworkStatus> _henetworkStatusSubject =
      BehaviorSubject<HenetworkStatus>.seeded(HenetworkStatus.loading);

  DatabaseService _service() => DatabaseService(firestore: _firestore);
  final DatabaseServiceLocal _serviceLocal = DatabaseServiceLocal();

  DatabaseBoxOperations _boxOperations() =>
      DatabaseBoxOperations(store: _objectbox.store);

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
  Future<Either<Failure, int>> saveSurveys({
    required String surveyId,
    required String country,
    required String userId,
    required String courseId,
    required String surveyJson,
    required String surveyVersion,
    required bool isPending,
  }) {
    debugPrint('DatabaseRepository@saveSurveys Nodata');
    return _boxOperations().saveSurveyData(
        surveyId: surveyId,
        country: country,
        userId: userId,
        surveyJson: surveyJson,
        isPending: isPending,
        courseId: courseId,
        surveyVersion: surveyVersion,
        surveyObject: surveyJson);
  }

  @override
  Future<Either<Failure, int>> saveBookChapters(
      {required String bookId,
      required String chapterId,
      required String courseId,
      required String userId,
      required bool isPending}) {
    debugPrint('DatabaseRepository@saveBookData Nodata');
    return _boxOperations().saveBookData(
        bookId: bookId,
        chapterId: chapterId,
        courseId: courseId,
        userId: userId,
        isPending: isPending);
  }

  @override
  Stream<Either<Failure, int>> totalSavedSurvey() {
    return _boxOperations().totalSavedSurveyData;
  }

  // Add these methods to call uploadData, loadState, and saveState
  Future<void> uploadData({
    required bool isUploadingData,
    required double uploadProgress,
    bool simulateUpload = true,
    required Function(bool, double) onUploadStateChanged,
  }) async {
    debugPrint("DatabaseRepository@uploadData  isUploadingData $isUploadingData "
        "uploadProgress $uploadProgress onUploadStateChanged onUploadStateChanged ${onUploadStateChanged.toString()} \n");
    return _boxOperations().uploadDataOps(
      isUploadingData: isUploadingData,
      uploadProgress: uploadProgress,
      simulateUpload: simulateUpload,
      onUploadStateChanged: onUploadStateChanged,
    );
  }

  Future<Map<String, dynamic>?> loadState() async {
    return await _boxOperations().loadState();
  }

  Future<void> saveState({
    required bool? isUploadingData,
    required double? uploadProgress,
    required bool? backupAnimation,
    required bool? surveyAnimation,
    required bool? booksAnimation,
  }) async {
    return _boxOperations().saveState(
      isUploadingData: isUploadingData,
      uploadProgress: uploadProgress,
      backupAnimation: backupAnimation,
      surveyAnimation: surveyAnimation,
      booksAnimation: booksAnimation,
    );
  }
}
