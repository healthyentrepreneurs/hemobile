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
  // late final Stream<Query<SurveyDataModel>> surveyBroadcastStream;
  // late final ReplaySubject<Query<BackupStateDataModel>> backupBroadcastStream;
  static ObjectBoxService? _instance;

  // Stream<BackupStateDataModel> get onSave => _saveController.stream;

  ObjectBoxService._create(this.store) {
    backupBox = Box<BackupStateDataModel>(store);
    surveyBox = Box<SurveyDataModel>(store);
    bookBox = Box<BookDataModel>(store);
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

  Future<void> saveBackupState({BackupStateDataModel? backupdatamodel}) async {
    final query = backupBox.query().build();
    final results = query.find();
    if (results.isEmpty) {
      // Add default BackupStateDataModel if query is empty
      final savedData = await backupBox
          .putAndGetAsync(BackupStateDataModel.defaultInstance());
      // _saveController.add(savedData);
    } else {
      final existingData = results.first;
      debugPrint("PHILA ${results.toString()} \n");
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
      final savedData = await backupBox.putAndGetAsync(existingData);
      // _saveController.add(savedData);
    }

    // Close the query builder
    // query.close();
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
    return queryBuilder.watch(triggerImmediately: true).map(
        (query) => query.findFirst() ?? BackupStateDataModel.defaultInstance());
  }
}
