import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'package:workmanager/workmanager.dart';
import 'app/app.dart';
import 'injection.dart';
import 'objects/blocs/repo/repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await configureInjections(getIt);
  Workmanager().initialize(
    topLevelCallbackDispatcher,
    isInDebugMode: true, // Set to false for production
  );
  Bloc.observer = AppBlocObserver();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  final themeLocaleIntRepository = ThemeLocaleIntRepository();
  // Workmanager().registerPeriodicTask(
  //     "1", // This is a unique identifier for the task
  //     "deleteCompletedSurveys",
  //     frequency: const Duration(minutes: 15),
  //     tag: "registerOneOffTaskJoash" // Adjust the frequency as needed
  //     );
  Workmanager().registerOneOffTask('2', 'deleteCompletedSurveys',
      inputData: <String, dynamic>{},
      initialDelay: const Duration(seconds: 10),
      tag: "registerOneOffTaskNjovu");
  runApp(App(
    themeLocaleIntRepository: themeLocaleIntRepository,
  ));
}

void topLevelCallbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies().then((_) async {
    await configureInjections(getIt);
    Workmanager().executeTask((task, inputData) async {
      print("Executing task: $task");
      final databaseRepository = getIt<DatabaseRepository>();
      final result =
          await databaseRepository.callbackDispatcher(task, inputData);
      print("Task result: $result");
      return Future.value(result);
    });
  });
}

// void topLevelCallbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("Executing task: $task");
//     final databaseRepository = getIt<DatabaseRepository>();
//     final result = await databaseRepository.callbackDispatcher(task, inputData);
//     print("Task result: $result");
//     return Future.value(result);
//   });
// }

// void topLevelCallbackDispatcher() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Workmanager().executeTask((task, inputData) async {
//     print("Executing task: $task");
//     final databaseRepository = getIt<DatabaseRepository>();
//     final result = await databaseRepository.callbackDispatcher(task, inputData);
//     print("Task result: $result");
//     return Future.value(result);
//   });
// }

// void topLevelCallbackDispatcher() {
//   WidgetsFlutterBinding.ensureInitialized();
//   final databaseRepository = getIt<DatabaseRepository>();
//   databaseRepository.callbackDispatcher();
// }
