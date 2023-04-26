import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:workmanager/workmanager.dart';

import 'objectbox_service.dart';

class WorkManagerService {
  static const workManagerTask = "workManagerTask";
  static const loadDataTask = "loadDataTask";
  static const cleanUploadedSurveysTask = "cleanUploadedSurveysTask";
  static final WorkManagerService _singleton = WorkManagerService._internal();
  factory WorkManagerService() {
    return _singleton;
  }
  WorkManagerService._internal();
  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    print("Workmanager initialized");
  }

  Future<void> startPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      "1",
      workManagerTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    print("Periodic task registered");
  }

  Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
    print("Cancelled all tasks");
  }

  Future<void> registerOneOffTask() async {
    await Workmanager().registerOneOffTask('2', cleanUploadedSurveysTask,
        inputData: <String, dynamic>{},
        initialDelay: const Duration(seconds: 10),
        tag: "registerOneOffTaskNjovu");
    print("registerOneOffTask task registered");
  }

  Future<void> _runCleanUploadedSurveys() async {
    await WorkManagerService._cleanUploadedSurveys();
  }

  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  static Future<void> _cleanUploadedSurveys() async {
    // Initialize FirebaseFirestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Initialize ObjectBoxService
    ObjectBoxService objectbox = await ObjectBoxService.create();

    final DatabaseRepository databaseRepository =
        DatabaseRepository(firestore, objectbox.store);
    await databaseRepository.cleanUploadedSurveys();
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await WorkManagerService._initializeFirebase();
    switch (task) {
      case WorkManagerService.cleanUploadedSurveysTask:
        print("Executing cleanUploadedSurveys task");
        await WorkManagerService._cleanUploadedSurveys();
        break;
      case WorkManagerService.workManagerTask:
        print("Executing cleanUploadedSurveys task");
        // await WorkManagerService.startPeriodicTask();
        break;
      default:
        print("Unknown task executed");
    }
    return Future.value(true);
  });
}
