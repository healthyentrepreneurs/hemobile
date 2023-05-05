import 'dart:async';

import 'package:flutter/material.dart';
import 'package:he/objects/db_local/backupstate_datamodel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import '../objectbox.g.dart';

// https://github.com/objectbox/objectbox-dart/issues/436
class ObjectBoxService {
  late final Store store;
  late final Box<BackupStateDataModel> backupBox;
  final StreamController<BackupStateDataModel> _saveController =
      StreamController<BackupStateDataModel>.broadcast();
  late final Stream<Query<BackupStateDataModel>> tasksStream;
  // late final Stream<Query<BackupStateDataModel>> tasksBroadcastStream;
  late final ReplaySubject<Query<BackupStateDataModel>> tasksBroadcastStream;
  static ObjectBoxService? _instance;
  Stream<BackupStateDataModel> get onSave => _saveController.stream;

  // Future<void> save(BackupStateDataMod el data) async {
  //   // await backupBox.putAsync(data);
  //   // _saveController.add(data);
  //   final savedData = await backupBox.putAndGetAsync(data);
  //   _saveController.add(savedData);
  //
  // }
  // BackupStateDataModel? data

  ObjectBoxService._create(this.store) {
    backupBox = Box<BackupStateDataModel>(store);
    final qBuilder = backupBox.query()
      ..order(BackupStateDataModel_.uploadProgress);
    tasksStream = qBuilder.watch(triggerImmediately: true);
    // tasksBroadcastStream = tasksStream.asBroadcastStream();
    // tasksBroadcastStream = tasksStream
    //     .debounceTime(const Duration(milliseconds: 300))
    //     .asBroadcastStream();
    tasksBroadcastStream = ReplaySubject<Query<BackupStateDataModel>>();
    tasksStream.listen((query) {
      tasksBroadcastStream.add(query);
    });
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

  Future<void> save({BackupStateDataModel? backupdatamodel}) async {
    final query = backupBox.query().build();
    final results = query.find();
    if (results.isEmpty) {
      // Add default BackupStateDataModel if query is empty
      final savedData = await backupBox
          .putAndGetAsync(BackupStateDataModel.defaultInstance());
      _saveController.add(savedData);
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
      // Add the saved data to the saveController stream
      debugPrint(
          "UpdatingBefore DatabaseBoxOperations@saveState ${savedData.toJson()} \n");
      _saveController.add(savedData);
      debugPrint(
          "UpdatingAfter DatabaseBoxOperations@saveState ${savedData.toJson()} \n");
    }

    // Close the query builder
    // query.close();
  }

  void dispose() {
    _saveController.close();
    tasksBroadcastStream.close();
    // Close the store if needed
  }
}
