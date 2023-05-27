import 'dart:async';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'package:he/service/work_manager_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'app/app.dart';
import 'injection.dart';

// https://github.com/pichillilorenzo/flutter_inappwebview/issues/748
// chrome://inspect/#devices
// https://github.com/pichillilorenzo/flutter_browser_app/blob/master/lib/custom_image.dart
WebStorageManager webStorageManager = WebStorageManager.instance();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.microphone.request();
  await AndroidAlarmManager.initialize();
  await configureDependencies();
  await configureInjections(getIt);
  final workManagerService = GetIt.I<WorkManagerService>();
  workManagerService.initialize();
// workManagerService.cleanUploadedDataTaskFunc();
// workManagerService.generateBookDataTaskFunc();
  Bloc.observer = AppBlocObserver();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    await webStorageManager.deleteAllData();
  }
  final themeLocaleIntRepository = ThemeLocaleIntRepository();
  runApp(App(
    themeLocaleIntRepository: themeLocaleIntRepository,
  ));
}
