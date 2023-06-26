import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:workmanager/workmanager.dart';
import 'appmodule_imp.dart';
import 'objectbox_service.dart';

class WorkManagerService {
  static const uploadDataTask = "uploadDataTask";
  static const cleanUploadedDataTask = "cleanUploadedDataTask";
  static const cancelUploadDataTask = "cancelUploadDataTask";
  static const generateSampleDataTask = "generateSampleDataTask";
  static const String uploadDataTaskId = 'registerUploadDataTaskUnique';
  static const String cleanUploadedDataTaskId =
      'registerCleanUploadedDataTaskUnique';
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
      uploadDataTaskId, // uniqueName
      uploadDataTask,
      inputData: <String, dynamic>{},
      initialDelay: Duration.zero,
      existingWorkPolicy: ExistingWorkPolicy.replace, // added this
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      tag: "registerUploadDataTask@Njovu",
    );
    debugPrint("registerUploadDataTask task registered");
  }

  Future<void> cancelUploadDataTaskFunc() async {
    await Workmanager().cancelByTag("registerUploadDataTask@Njovu");
    debugPrint("registerUploadDataTask task cancelled");
  }

  // Future<void> cleanUploadedDataTaskFunc() async {
  //   await Workmanager().registerOneOffTask('2', cleanUploadedDataTask,
  //       inputData: <String, dynamic>{},
  //       initialDelay: const Duration(seconds: 10),
  //       tag: "registerCleanUploadedDataTask");
  //   debugPrint("cleanUploadedDataTaskFunc task registered");
  // }

  Future<void> cleanUploadedDataTaskFunc() async {
    await Workmanager().registerPeriodicTask(
      cleanUploadedDataTaskId, // task id
      cleanUploadedDataTask, // task name
      inputData: <String, dynamic>{},
      frequency:
          const Duration(hours: 17), // set the frequency of the periodic task
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: true,
      ),
      tag: "registerCleanUploadedDataTask",
    );
    debugPrint("cleanUploadedDataTaskFunc task registered");
  }

  Future<void> generateBookDataTaskFunc() async {
    await Workmanager().registerOneOffTask('10', generateSampleDataTask,
        inputData: <String, dynamic>{},
        initialDelay: const Duration(seconds: 3),
        tag: "generateBookDataTaskFunc");
    debugPrint("generateBookDataTaskFunc task registered");
  }

  static final injectableModule = AppModuleImp();

  Future<void> _uploadData() async {
    final ObjectBoxService _objectservice = await objectbox;
    final DatabaseRepository databaseRepository =
        DatabaseRepository(injectableModule.firestore, _objectservice);
    await databaseRepository.uploadData();
  }

  Future<void> _generateSampleDataTask() async {
    final ObjectBoxService _objectservice = await objectbox;
    final DatabaseRepository databaseRepository =
        DatabaseRepository(injectableModule.firestore, _objectservice);
    await databaseRepository.createDummyData();
  }

  Future<void> _cleanUploadedData() async {
    final DatabaseRepository databaseRepository =
        DatabaseRepository(injectableModule.firestore, await objectbox);
    await databaseRepository.cleanUploadedData();
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
      case WorkManagerService.cleanUploadedDataTask:
        debugPrint("Executing cleanUploadedSurveys task");
        await workManagerService._cleanUploadedData();
        await workManagerService.showNotification(
            'Cleared Synced', 'Syncronised Data Has Been Cleaned');
        break;
      case WorkManagerService.uploadDataTask:
        debugPrint("Executing uploadData task");
        await workManagerService._uploadData();
        await workManagerService.showNotification(
            'Data Sync Completed', 'Previous Data Have been Synced');
        break;
      case WorkManagerService.generateSampleDataTask:
        await workManagerService._generateSampleDataTask();
        await workManagerService.showNotification(
            'Fake Completed', 'Generated');
        break;
      default:
        debugPrint("Unknown task executed");
    }
    return Future.value(true);
  });
}
