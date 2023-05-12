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

  DatabaseBoxOperations({
    required FirebaseFirestore firestore,
    required ObjectBoxService objectService,
  })  : _objectService = objectService,
        _firestore = firestore {
    debugPrint("Updated-BackupStateDataModel: ");
  }

  Box<SurveyDataModel> get _surveyBox =>
      _objectService.store.box<SurveyDataModel>();
  Box<BackupStateDataModel> get backupBox =>
      _objectService.store.box<BackupStateDataModel>();
  // ## BOOK LOCAL SAVING

  // ## SURVEY LOCAL SAVING

  Future<void> removeSurvey(SurveyDataModel survey) async {
    try {
      // Delete the survey from the ObjectBox store
      _surveyBox.remove(survey.id);
    } catch (e) {
      // Handle any error that might occur during the deletion process
      debugPrint("removeSurvey@Error removing survey: $e");
    }
  }

  Future<Either<Failure, int>> saveSurveyOps(
      {required SurveyDataModel surveydata}) {
    try {
      return Future.value(
          Right(_surveyBox.put(surveydata))); // Return success value
    } catch (e) {
      debugPrint("Error saving saveSurveyData response: $e");
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Future<Either<Failure, int>> saveBookChapterOps(
      {required BookDataModel bookdata}) async {
    try {
      _objectService.saveBook(bookdata, updateIfExists: false);
      return Right(bookdata.id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  // ## BACKUP STATUS LOCAL
  Future<void> uploadDataOps() async {
    BackupStateDataModel currentBackupState =
        BackupStateDataModel.defaultInstance();
    final newState = currentBackupState.copyWith(
      isUploadingData: true,
      backupAnimation: true,
      surveyAnimation: true,
      booksAnimation: false,
    );
    _objectService.saveBackupState(backupdatamodel: newState);
    await savePendingItemsToFirestoreAndSetNotPending();
  }

  Future<void> savePendingItemsToFirestoreAndSetNotPending() async {
    bool hasFailure = false;
    List<SurveyDataModel> pendingSurveys =
        await _objectService.getSurveysPendingStatusCTimeLimit(true);
    List<BookDataModel> pendingBookViews =
        await _objectService.getBookViewsPendingStatusCTimeLimit(true);

    int totalPendingSurveys = pendingSurveys.length;
    int totalPendingBookViews = pendingBookViews.length;
    int totalPendingItems = totalPendingSurveys + totalPendingBookViews;

    int countingTract = 0;
    int? uploadedSurveys;
    int? uploadedBookViews;
    BackupStateDataModel currentBackupState = _objectService.backupBox.get(1) ??
        BackupStateDataModel.defaultInstance();

    // Initialize WriteBatch instance
    final batch = _firestore.batch();

    // Save surveys in a batch
    for (SurveyDataModel survey in pendingSurveys) {
      try {
        _saveSurveyToFirestore(survey: survey, batch: batch);
        survey.isPending = false;
        _objectService.saveSurvey(survey, updateIfExists: true);
        uploadedSurveys = --totalPendingSurveys;
        countingTract++;
      } catch (e) {
        hasFailure = true;
        final failState = currentBackupState.copyWith(
          isUploadingData: false,
          booksAnimation: false,
        );
        _objectService.saveBackupState(backupdatamodel: failState);
        debugPrint("Failed to add survey to batch: ${e.toString()}");
        break;
      }
    }

    if (!hasFailure) {
      // Save book views in a batch
      for (BookDataModel bookview in pendingBookViews) {
        try {
          _saveBookViewsToFirestore(bookviews: bookview, batch: batch);
          bookview.isPending = false;
          _objectService.saveBook(bookview, updateIfExists: true);
          countingTract++;
          uploadedBookViews = --totalPendingBookViews;
        } catch (e) {
          hasFailure = true;
          final failState = currentBackupState.copyWith(
            isUploadingData: false,
            surveyAnimation: false,
          );
          _objectService.saveBackupState(backupdatamodel: failState);
          debugPrint("Failed to add book view to batch: ${e.toString()}");
          break;
        }
      }
    }

    if (!hasFailure) {
      try {
        await batch.commit();
        debugPrint("Batch write successful");
      } catch (e) {
        hasFailure = true;
        debugPrint("Batch write failed: ${e.toString()}");
      }
    }

    updateProgress(uploadedSurveys, uploadedBookViews, countingTract,
        totalPendingItems, currentBackupState);

    if (!hasFailure) {
      _objectService.saveBackupState(
          backupdatamodel: BackupStateDataModel.defaultInstance());
    }
  }

  void updateProgress(
      int? uploadedSurveys,
      int? uploadedBookViews,
      int countingTract,
      int totalPendingItems,
      BackupStateDataModel currentBackupState) {
    double progress = countingTract / totalPendingItems.toDouble();
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
    debugPrint('@startpampwa ${updatedBackupState.toJson()}');
    _objectService.saveBackupState(backupdatamodel: updatedBackupState);
    debugPrint('@endpampwa ${updatedBackupState.toJson()}');
  }

  Future<Map<String, dynamic>?> loadState() async {
    final data = backupBox.query().build().findFirst();
    var nana =
        data?.toJson() ?? BackupStateDataModel.defaultInstance().toJson();
    debugPrint('@loadState $nana');
    // return BackupStateDataModel.defaultInstance().toJson();
    return nana;
  }

  Future<List<BookDataModel>> _generateDummyBooksWithFaker() async {
    const int numOfBooks = 500;
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
      dummyBooks.add(book);
    }

    // Run the putMany operation inside a transaction
    _objectService.store.runInTransaction(TxMode.write, () {
      _objectService.bookBox.putMany(
          dummyBooks); // using putMany instead of saveBook as it's not async
    });

    return dummyBooks;
  }

  Future<void> generateTestingData() async {
    const int numOfRecords = 20;
    final faker = Faker();
    int totalCounter = 0;

    // Generate SurveyDataModel records
    for (int i = 0; i < numOfRecords; i++) {
      var survey = SurveyDataModel(
        userId: faker.guid.guid(),
        surveyVersion: faker.randomGenerator.decimal(min: 1).toString(),
        surveyObject:
            '{"question1": "${faker.lorem.word()}", "question2": "${faker.lorem.word()}"}',
        surveyId: faker.guid.guid(),
        isPending: true,
        courseId: faker.guid.guid(),
        country: faker.address.country(),
      );
      _objectService.saveSurveyPutQueued(survey);
      totalCounter++;
    }
    // Ensure all SurveyDataModel records have been put into the box
    _objectService.store.awaitQueueSubmitted();

    // Generate BookDataModel records
    for (int i = 0; i < numOfRecords; i++) {
      var book = BookDataModel(
        bookId: faker.guid.guid(),
        chapterId: faker.guid.guid(),
        courseId: faker.guid.guid(),
        userId: faker.guid.guid(),
        isPending: true,
      );
      _objectService.saveBookPutQueued(book);
      totalCounter++;
    }

    // Ensure all BookDataModel records have been put into the box
    _objectService.store.awaitQueueSubmitted();

    print('Total records added: $totalCounter');
  }

  //
  Future<void> generateDummyDataWithFaker() async {
    List<SurveyDataModel> dummySurveys = await _generateDummySurveysWithFaker();
    debugPrint('DummySurveys generation completed.');

    List<BookDataModel> dummyBooks = await _generateDummyBooksWithFaker();
    debugPrint('DummyBooks generation completed.');

    debugPrint('Dummy Data generation completed.');
  }

  Future<List<SurveyDataModel>> _generateDummySurveysWithFaker() async {
    const int numOfSurveys = 400;
    final faker = Faker();

    List<SurveyDataModel> dummySurveys = [];
    for (int i = 0; i < numOfSurveys; i++) {
      var namu = SurveyDataModel(
        userId: faker.guid.guid(),
        surveyVersion: faker.randomGenerator.decimal(min: 1).toString(),
        surveyObject:
            '{"question1": "${faker.lorem.word()}", "question2": "${faker.lorem.word()}"}',
        surveyId: faker.guid.guid(),
        isPending: true,
        courseId: faker.guid.guid(),
        country: faker.address.country(),
      );
      dummySurveys.add(namu);
    }
    _objectService.store.runInTransaction(TxMode.write, () {
      _objectService.surveyBox.putMany(dummySurveys);
    });

    return dummySurveys;
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

  Future<void> deleteBooksAndSurveys() async {
    // Run both deletion operations concurrently
    await Future.wait([
      _objectService.deleteBook(),
      _objectService.deleteSurvey(),
    ]);
    debugPrint('All books and surveys deletion completed.');
  }

  Future<void> _saveSurveyToFirestore({
    required SurveyDataModel survey,
    required WriteBatch batch,
  }) async {
    final docRef = _firestore
        .collection('surveyposts')
        .doc(survey.country)
        .collection(survey.surveyId)
        .doc(survey.userId);

    batch.set(
      docRef,
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
    required WriteBatch batch,
  }) async {
    final createdAt = bookviews.dateCreated;
    final dateWithoutSeconds =
        createdAt.toIso8601String().split(':').sublist(0, 2).join(':');
    final docId =
        '${bookviews.userId}_$dateWithoutSeconds:${createdAt.minute.toString().padLeft(2, '0')}';
    final docRef = _firestore
        .collection('bookviews')
        .doc(bookviews.courseId)
        .collection(bookviews.bookId)
        .doc(bookviews.chapterId)
        .collection('views')
        .doc(docId);

    batch.set(
      docRef,
      {
        'userId': bookviews.userId,
        'viewTime': createdAt.toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }

  void _sampleTrials() {
    // _objectService.surveyBox.putQueued(object);
    // _objectService.store.awaitQueueCompletion();
    // _objectService.store.awaitQueueSubmitted();
  }
}
