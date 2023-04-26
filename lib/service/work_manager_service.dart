import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    await _initializeNotifications();
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    print("Workmanager initialized");
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

//Methods For Background
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

  Future<void> showNotification(String title, String body) async {
    // Define the duration for the notification to be displayed
    // final durationInMilliseconds = Duration(hours: 2).inMilliseconds;
    final durationInMilliseconds = const Duration(minutes: 2).inMilliseconds;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'task_notification_channel', 'Task Notification',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        timeoutAfter: durationInMilliseconds); // Add the timeoutAfter property

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await WorkManagerService._initializeFirebase();
    switch (task) {
      case WorkManagerService.cleanUploadedSurveysTask:
        print("Executing cleanUploadedSurveys task");
        await WorkManagerService._cleanUploadedSurveys();
        final workManagerService = WorkManagerService();
        await workManagerService.showNotification('Task Completed', 'Your background task has been completed.');
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
