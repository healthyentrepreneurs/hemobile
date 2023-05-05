import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:workmanager/workmanager.dart';
import 'appmodule_imp.dart';
import 'objectbox_service.dart';

class WorkManagerService{
  static const uploadDataTask = "uploadDataTask";
  static const cleanUploadedSurveysTask = "cleanUploadedSurveysTask";
  static final WorkManagerService _singleton = WorkManagerService._internal();

  factory WorkManagerService() {
    return _singleton;
  }

  WorkManagerService._internal() : objectbox = ObjectBoxService.create();

  final Future<ObjectBoxService> objectbox;

  Future<void> initialize() async {
    await _initializeNotifications();
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    debugPrint("Workmanager initialized");
  }

  Future<void> registerUploadDataTask() async {
    await Workmanager().registerOneOffTask(
      '4',
      uploadDataTask,
      inputData: <String, dynamic>{},
      initialDelay: Duration.zero,
      tag: "registerUploadDataTask@Njovu",
    );
    debugPrint("registerUploadDataTask task registered");
  }

  Future<void> cleanUploadedSurveysTaskM() async {
    await Workmanager().registerOneOffTask('2', cleanUploadedSurveysTask,
        inputData: <String, dynamic>{},
        initialDelay: const Duration(seconds: 10),
        tag: "registerOneOffTaskNjovu");
    debugPrint("registerOneOffTask task registered");
  }

  static final injectableModule = AppModuleImp();

  Future<void> _uploadData() async {
    final ObjectBoxService _objectservice = await objectbox;
    final DatabaseRepository databaseRepository =
        DatabaseRepository(injectableModule.firestore, _objectservice);
    await databaseRepository.uploadData();
  }

  Future<void> _cleanUploadedSurveys() async {
    final DatabaseRepository databaseRepository =
        DatabaseRepository(injectableModule.firestore, await objectbox);
    await databaseRepository.cleanUploadedSurveys();
  }

  static Future<void> _initializeFirebase() async {
    await injectableModule.fireService;
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

  Future<void> showNotification(String title, String body) async {
    // Define the duration for the notification to be displayed
    // final durationInMilliseconds = Duration(hours: 2).inMilliseconds;
    const displayDelay = Duration(minutes: 1);
    final timeoutDuration = const Duration(minutes: 2).inMilliseconds;
    await Future.delayed(displayDelay);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'task_notification_channel', 'Task Notification',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        timeoutAfter: timeoutDuration); // Add the timeoutAfter property

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
    final workManagerService = WorkManagerService();

    switch (task) {
      case WorkManagerService.cleanUploadedSurveysTask:
        debugPrint("Executing cleanUploadedSurveys task");
        await workManagerService._cleanUploadedSurveys();
        await workManagerService.showNotification(
            'Task Completed', 'Your background task has been completed.');
        break;
      case WorkManagerService.uploadDataTask:
        debugPrint("Executing uploadData task");
        await workManagerService._uploadData();
        await workManagerService.showNotification(
            'Data Sync Completed', 'Previous Data Have been Synced');
        break;
      default:
        debugPrint("Unknown task executed");
    }
    return Future.value(true);
  });
}
