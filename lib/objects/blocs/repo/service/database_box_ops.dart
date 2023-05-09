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
  }

  Box<SurveyDataModel> get _surveyBox =>
      _objectService.store.box<SurveyDataModel>();
  Box<BookDataModel> get _bookDataBox =>
      _objectService.store.box<BookDataModel>();
  Box<BackupStateDataModel> get backupBox =>
      _objectService.store.box<BackupStateDataModel>();
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

  Future<List<BookDataModel>> getBookViewsPendingStatusCTimeLimit(
      bool isPending) async {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final query = _bookDataBox
        .query(BookDataModel_.isPending
            .equals(isPending)
            .and(BookDataModel_.dateCreated.lessOrEqual(currentTimeMillis)))
        .build();
    final bookviews = query.find();
    query.close();
    return bookviews;
  }

  // ## BACKUP STATUS LOCAL
  Future<void> uploadDataOps() async {
    BackupStateDataModel currentBackupState =
        BackupStateDataModel.defaultInstance();
    final newState = currentBackupState.copyWith(
      isUploadingData: true,
      backupAnimation: true,
      surveyAnimation: true,
      booksAnimation: true,
    );
    await _objectService.saveBackupState(backupdatamodel: newState);
    await savePendingItemsToFirestoreAndSetNotPending();
  }

  Future<void> savePendingItemsToFirestoreAndSetNotPending() async {
    bool hasFailure = false;
    List<SurveyDataModel> pendingSurveys =
        await getSurveysPendingStatusCTimeLimit(true);
    List<BookDataModel> pendingBookViews =
        await getBookViewsPendingStatusCTimeLimit(true);

    int totalPendingSurveys = pendingSurveys.length;
    int totalPendingBookViews = pendingBookViews.length;
    int totalPendingItems = totalPendingSurveys + totalPendingBookViews;

    int countingTract = 0;
    int? uploadedSurveys;
    int? uploadedBookViews;
    BackupStateDataModel currentBackupState = _objectService.backupBox.get(1) ??
        BackupStateDataModel.defaultInstance();

    for (SurveyDataModel survey in pendingSurveys) {
      Either<Failure, void> result = await saveSurveysFireStore(survey: survey);
      result.fold(
        (failure) {
          final failState = currentBackupState.copyWith(
            isUploadingData: false,
            booksAnimation: false,
          );
          _objectService.saveBackupState(backupdatamodel: failState);
          hasFailure = true;
          debugPrint("Failed to upload survey: $failure");
        },
        (_) async {
          survey.isPending = false;
          uploadedSurveys = --totalPendingSurveys;
          countingTract++;
          await updateProgress(uploadedSurveys, uploadedBookViews,
              countingTract, totalPendingItems, currentBackupState);
        },
      );
      if (hasFailure) {
        break;
      }
    }
    debugPrint("Total uploaded surveys simulated: $uploadedSurveys");
    hasFailure = false;
    for (BookDataModel bookview in pendingBookViews) {
      Either<Failure, void> result =
          await saveBookViewsFireStore(bookview: bookview);
      // Force a failure
      // Failure forcedFailure = RepositoryFailure("Forced failure for testing");
      // result = Left(forcedFailure);
      result.fold(
        (failure) {
          final failState = currentBackupState.copyWith(
            isUploadingData: false,
            surveyAnimation: false,
          );
          _objectService.saveBackupState(backupdatamodel: failState);
          hasFailure = true;
          debugPrint("Failed to upload book view: $failure");
        },
        (_) async {
          bookview.isPending = false;
          countingTract++;
          uploadedBookViews = --totalPendingBookViews;
          await updateProgress(uploadedSurveys, uploadedBookViews,
              countingTract, totalPendingItems, currentBackupState);
        },
      );
      if (hasFailure) {
        break;
      }
    }
    debugPrint("Total uploaded BookViews simulated: $uploadedBookViews");
  }

  Future<void> updateProgress(
      int? uploadedSurveys,
      int? uploadedBookViews,
      int countingTract,
      int totalPendingItems,
      BackupStateDataModel currentBackupState) async {
    double progress = countingTract / totalPendingItems;
    bool _isUploading = true;
    bool _backupAnimation = true;
    bool _surveyAnimation = !(uploadedSurveys == null || uploadedSurveys == 0);
    bool _booksAnimation =
        !(uploadedBookViews == null || uploadedBookViews == 0);

    if (progress >= 1) {
      progress = 0.0;
      _isUploading = false;
      _backupAnimation = false;
    }
    var updatedBackupState = currentBackupState.copyWith(
        isUploadingData: _isUploading,
        uploadProgress: progress,
        backupAnimation: _backupAnimation,
        surveyAnimation: _surveyAnimation,
        booksAnimation: _booksAnimation,
        dateCreated: DateTime.now());

    await _objectService.saveBackupState(backupdatamodel: updatedBackupState);
  }

  Future<Map<String, dynamic>?> loadState() async {
    // generateDummySurveysWithFaker();
    debugPrint("MEHME");
    final completer = Completer<Map<String, dynamic>?>();
    StreamSubscription? subscription;
    subscription = _objectService.backupBroadcastStream.listen((query) {
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

  List<BookDataModel> generateDummyBooksWithFaker() {
    const int numOfBooks = 100;
    final faker = Faker();

    List<BookDataModel> dummyBooks = [];
    for (int i = 0; i < numOfBooks; i++) {
      var book = BookDataModel(
          bookId: faker.guid.guid(),
          chapterId: faker.guid.guid(),
          courseId: faker.guid.guid(),
          userId: faker.guid.guid(),
          isPending: true //faker.randomGenerator.boolean(),
          );
      saveBookData(
          bookId: book.id.toString(),
          chapterId: book.chapterId,
          courseId: book.courseId,
          userId: book.userId,
          isPending: book.isPending); // Assuming you have an addBook() function
      dummyBooks.add(book);
    }

    return dummyBooks;
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
    required SurveyDataModel survey,
  }) async {
    try {
      await _saveSurveyToFirestore(survey: survey);
      return Future.value(const Right(null)); // Return success value
    } catch (e) {
      debugPrint("Error saving survey response: ${e.toString()}");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Future<Either<Failure, void>> saveBookViewsFireStore({
    required BookDataModel bookview,
  }) async {
    try {
      await _saveBookViewsToFirestore(bookviews: bookview);
      return Future.value(const Right(null)); // Return success value
    } catch (e) {
      debugPrint("Error saving bookviews response: ${e.toString()}");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Future<void> _saveSurveyToFirestore({
    required SurveyDataModel survey,
  }) async {
    await _firestore
        .collection('surveyposts')
        .doc(survey.country)
        .collection(survey.surveyId)
        .doc(survey
            .userId) // Assuming that each user has a unique survey in the collection
        .set(
      {
        'userId': survey.userId,
        'surveyVersion': survey.surveyVersion,
        'surveyobject': survey.surveyObject,
        'surveyId': survey.surveyId,
        'dateCreated': survey.dateCreated.toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> _saveBookViewsToFirestore({
    required BookDataModel bookviews,
  }) async {
    final createdAt = bookviews.dateCreated;
    // final timeInMinutes = (createdAt.hour * 60) + createdAt.minute;
    final dateWithoutSeconds =
        createdAt.toIso8601String().split(':').sublist(0, 2).join(':');
    final docId =
        '${bookviews.userId}_$dateWithoutSeconds:${createdAt.minute.toString().padLeft(2, '0')}';
    await _firestore
        .collection('bookviews')
        .doc(bookviews.courseId)
        .collection(bookviews.bookId)
        .doc(bookviews.chapterId)
        .collection('views')
        .doc(docId)
        .set({
      'userId': bookviews.userId,
      'viewTime': createdAt.toIso8601String(),
    }, SetOptions(merge: true));
  }
}
