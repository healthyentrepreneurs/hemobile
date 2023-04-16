import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
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
      // return _service().retrieveBookSection(courseid);
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
    // return _service().saveSurveys(
    //     surveyId: surveyId,
    //     surveyVersion: surveyVersion,
    //     surveyJson: surveyJson,
    //     country: country,
    //     email: email,
    //     userId: userId);
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
  Future<Either<Failure, int>> saveBookData(
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
}
