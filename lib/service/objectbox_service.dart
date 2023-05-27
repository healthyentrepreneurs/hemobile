import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';
import '../objects/db_local/db_local.dart';

// https://github.com/objectbox/objectbox-dart/issues/436

class ObjectBoxService {
  late final Store store;
  late final Box<BackupStateDataModel> backupBox;
  late final Box<BookDataModel> bookBox;
  late final Box<SurveyDataModel> surveyBox;

  // late final Stream<Query<BackupStateDataModel>> backupStream;
  // late final ReplaySubject<Query<BackupStateDataModel>> backupBroadcastStream;
  static ObjectBoxService? _instance;
  ObjectBoxService._create(this.store) {
    backupBox = Box<BackupStateDataModel>(store);
    surveyBox = Box<SurveyDataModel>(store);
    bookBox = Box<BookDataModel>(store);
    // final qBuilderBackupDataModel = backupBox.query()
    //   ..order(BackupStateDataModel_.uploadProgress);
    // backupStream = qBuilderBackupDataModel.watch(triggerImmediately: true);
    // backupBroadcastStream = ReplaySubject<Query<BackupStateDataModel>>();
    // backupStream.listen((query) {
    //   backupBroadcastStream.add(query);
    // });
  }

  static Future<ObjectBoxService> create() async {
    if (_instance != null) {
      return _instance!;
    } else {
      final docsDir = await getApplicationDocumentsDirectory();
      final storePath = p.join(docsDir.path, "hestatistics");

      // Check if the store is already open
      if (Store.isOpen(storePath)) {
        // Attach to the already opened store
        final store = Store.attach(getObjectBoxModel(), storePath);
        _instance = ObjectBoxService._create(store);
      } else {
        // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
        final store = await openStore(directory: storePath);
        _instance = ObjectBoxService._create(store);
      }
      return _instance!;
    }
  }

  Future<void> saveBackupStateAsync(
      {BackupStateDataModel? backupdatamodel}) async {
    final query = backupBox.query().build();
    final results = query.find();
    if (results.isEmpty) {
      // Add default BackupStateDataModel if query is empty
      await backupBox.putAndGetAsync(BackupStateDataModel.defaultInstance());
      // _saveController.add(savedData);
    } else {
      final existingData = results.first;
      // debugPrint("PHILA ${results.toString()} \n");
      // Update fields with new values if provided (not null)
      existingData.isUploadingData =
          backupdatamodel?.isUploadingData ?? existingData.isUploadingData;
      existingData.uploadProgress =
          backupdatamodel?.uploadProgress ?? existingData.uploadProgress;
      existingData.backupAnimation =
          backupdatamodel?.backupAnimation ?? existingData.backupAnimation;
      existingData.surveyAnimation =
          backupdatamodel?.surveyAnimation ?? existingData.surveyAnimation;
      existingData.booksAnimation =
          backupdatamodel?.booksAnimation ?? existingData.booksAnimation;
      existingData.dateCreated = backupdatamodel!.dateCreated;
      // Save the updated data
      await backupBox.putAndGetAsync(existingData);
      debugPrint(
          "PHILA OLD ${results.toString()} NEW ${existingData.toJson()}\n");
      // _saveController.add(savedData);
    }

    // Close the query builder
    // query.close();
  }

  void saveBackupState({BackupStateDataModel? backupdatamodel}) {
    final query = backupBox.query().build();
    final results = query.find();
    if (results.isEmpty) {
      // Add default BackupStateDataModel if query is empty
      backupBox.put(BackupStateDataModel.defaultInstance());
    } else {
      final existingData = results.first;
      // Update fields with new values if provided (not null)
      existingData.isUploadingData =
          backupdatamodel?.isUploadingData ?? existingData.isUploadingData;
      existingData.uploadProgress =
          backupdatamodel?.uploadProgress ?? existingData.uploadProgress;
      existingData.backupAnimation =
          backupdatamodel?.backupAnimation ?? existingData.backupAnimation;
      existingData.surveyAnimation =
          backupdatamodel?.surveyAnimation ?? existingData.surveyAnimation;
      existingData.booksAnimation =
          backupdatamodel?.booksAnimation ?? existingData.booksAnimation;
      existingData.dateCreated = backupdatamodel!.dateCreated;
      // Save the updated data
      backupBox.put(existingData);
    }
  }

  void saveBackupStatePutQueued({BackupStateDataModel? backupdatamodel}) {
    final query = backupBox.query().build();
    final results = query.find();
    if (results.isEmpty) {
      // Add default BackupStateDataModel if query is empty
      backupBox.putQueued(BackupStateDataModel.defaultInstance());
    } else {
      final existingData = results.first;
      // Update fields with new values if provided (not null)
      existingData.isUploadingData =
          backupdatamodel?.isUploadingData ?? existingData.isUploadingData;
      existingData.uploadProgress =
          backupdatamodel?.uploadProgress ?? existingData.uploadProgress;
      existingData.backupAnimation =
          backupdatamodel?.backupAnimation ?? existingData.backupAnimation;
      existingData.surveyAnimation =
          backupdatamodel?.surveyAnimation ?? existingData.surveyAnimation;
      existingData.booksAnimation =
          backupdatamodel?.booksAnimation ?? existingData.booksAnimation;
      existingData.dateCreated = backupdatamodel!.dateCreated;
      // Save the updated data
      backupBox.putQueued(existingData);
    }
  }

  // Future<void> saveSurvey(SurveyDataModel surveyDataModel,
  //     {bool updateIfExists = false}) async {
  //   if (updateIfExists && surveyDataModel.id != 0) {
  //     // Check if the record with the given id exists in the box
  //     final existingSurvey = await surveyBox.getAsync(surveyDataModel.id);
  //     if (existingSurvey != null) {
  //       // Update the existing record with the new data
  //       await surveyBox.putAsync(surveyDataModel);
  //     }
  //   } else if (!updateIfExists) {
  //     // If updateIfExists is false, create a new record
  //     await surveyBox.putAsync(surveyDataModel);
  //   }
  // }

  void saveSurvey(SurveyDataModel surveyDataModel,
      {bool updateIfExists = false}) {
    if (updateIfExists && surveyDataModel.id != 0) {
      // Check if the record with the given id exists in the box
      final existingSurvey = surveyBox.get(surveyDataModel.id);
      if (existingSurvey != null) {
        // Update the existing record with the new data
        surveyBox.put(surveyDataModel);
      }
    } else if (!updateIfExists) {
      // If updateIfExists is false, create a new record
      surveyBox.put(surveyDataModel);
    }
  }

  Future<void> saveSurveyAsync(SurveyDataModel surveyDataModel,
      {bool updateIfExists = false}) async {
    if (updateIfExists && surveyDataModel.id != 0) {
      // Check if the record with the given id exists in the box
      final existingSurvey = await surveyBox.getAsync(surveyDataModel.id);
      if (existingSurvey != null) {
        // Update the existing record with the new data
        await surveyBox.putAsync(surveyDataModel);
      }
    } else if (!updateIfExists) {
      // If updateIfExists is false, create a new record
      await surveyBox.putAsync(surveyDataModel);
    }
  }

  void saveSurveyPutQueued(SurveyDataModel surveyDataModel,
      {bool updateIfExists = false}) {
    if (updateIfExists && surveyDataModel.id != 0) {
      // Check if the record with the given id exists in the box
      final existingSurvey = surveyBox.get(surveyDataModel.id);
      if (existingSurvey != null) {
        // Update the existing record with the new data
        surveyBox.putQueued(surveyDataModel);
      }
    } else if (!updateIfExists) {
      // If updateIfExists is false, create a new record
      surveyBox.putQueued(surveyDataModel);
    }
  }

  void saveBook(BookDataModel bookDataModel, {bool updateIfExists = false}) {
    if (updateIfExists && bookDataModel.id != 0) {
      // Check if the record with the given id exists in the box
      final existingBook = bookBox.get(bookDataModel.id);
      if (existingBook != null) {
        // Update the existing record with the new data
        bookBox.put(bookDataModel);
      }
    } else if (!updateIfExists) {
      // If updateIfExists is false, create a new record
      bookBox.put(bookDataModel);
    }
  }

  Future<void> saveBookAsync(BookDataModel bookDataModel,
      {bool updateIfExists = false}) async {
    if (updateIfExists && bookDataModel.id != 0) {
      // Check if the record with the given id exists in the box
      final existingBook = await bookBox.getAsync(bookDataModel.id);
      if (existingBook != null) {
        // Update the existing record with the new data
        await bookBox.putAsync(bookDataModel);
      }
    } else if (!updateIfExists) {
      // If updateIfExists is false, create a new record
      await bookBox.putAsync(bookDataModel);
    }
  }

  void saveBookPutQueued(BookDataModel bookDataModel,
      {bool updateIfExists = false}) {
    if (updateIfExists && bookDataModel.id != 0) {
      // Check if the record with the given id exists in the box
      final existingBook = bookBox.get(bookDataModel.id);
      if (existingBook != null) {
        // Update the existing record with the new data
        bookBox.putQueued(bookDataModel);
      }
    } else if (!updateIfExists) {
      // If updateIfExists is false, create a new record
      bookBox.putQueued(bookDataModel);
    }
  }

  Stream<List<SurveyDataModel>> surveysByPendingStatus(bool isPending) {
    final queryBuilder =
        surveyBox.query(SurveyDataModel_.isPending.equals(isPending));
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<List<BookDataModel>> booksByPendingStatus(bool isPending) {
    final queryBuilder =
        bookBox.query(BookDataModel_.isPending.equals(isPending));
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<BackupStateDataModel> backupUpdateStream() {
    final queryBuilder = backupBox.query()
      ..order(BackupStateDataModel_.uploadProgress);
    debugPrint('@diamond');
    return queryBuilder.watch(triggerImmediately: true).map(
        (query) => query.findFirst() ?? BackupStateDataModel.defaultInstance());
  }

  Future<void> deleteBook() async {
    final booksToDelete =
        bookBox.query(BookDataModel_.isPending.equals(false)).build().find();

    List<int> idsToDelete = booksToDelete.map((book) => book.id).toList();
    bookBox.removeMany(idsToDelete);

    debugPrint('Deleted Books: $idsToDelete');
  }

  Future<void> deleteSurvey() async {
    final surveysToDelete = surveyBox
        .query(SurveyDataModel_.isPending.equals(false))
        .build()
        .find();

    List<int> idsToDelete = surveysToDelete.map((survey) => survey.id).toList();
    surveyBox.removeMany(idsToDelete);

    debugPrint('Deleted Surveys: $idsToDelete');
  }

  Future<List<SurveyDataModel>> getSurveysPendingStatusCTimeLimit(
      bool isPending) async {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final query = surveyBox
        .query(SurveyDataModel_.isPending
            .equals(isPending)
            .and(SurveyDataModel_.dateCreated.lessOrEqual(currentTimeMillis)))
        .build();
    final surveys = query.find();
    return surveys;
  }

  Future<List<BookDataModel>> getBookViewsPendingStatusCTimeLimit(
      bool isPending) async {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final query = bookBox
        .query(BookDataModel_.isPending
            .equals(isPending)
            .and(BookDataModel_.dateCreated.lessOrEqual(currentTimeMillis)))
        .build();
    final bookviews = query.find();
    // query.close();
    return bookviews;
  }

// Future<void> deleteBookAndSurvey() async {
  //   await store.runInTransaction(
  //       TxMode.write,
  //       (tx) async {
  //         // Delete books with isPending set to true
  //         final booksToDelete = bookBox
  //             .query(BookDataModel_.isPending.equals(true))
  //             .build()
  //             .find();
  //         for (var book in booksToDelete) {
  //           bookBox.remove(book.id);
  //         }
  //
  //         // Delete surveys with isPending set to true
  //         final surveysToDelete = surveyBox
  //             .query(SurveyDataModel_.isPending.equals(true))
  //             .build()
  //             .find();
  //         for (var survey in surveysToDelete) {
  //           surveyBox.remove(survey.id);
  //         }
  //       } as Function());
  // }
  void dispose() {
    // _saveController.close();
    // backupBroadcastStream.close();
    // Close the store if needed
  }
}
