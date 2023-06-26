import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'package:he/service/service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'app/app.dart';
import 'injection.dart';

// https://github.com/pichillilorenzo/flutter_inappwebview/issues/748
// chrome://inspect/#devices
// https://github.com/pichillilorenzo/flutter_browser_app/blob/master/lib/custom_image.dart
// WebStorageManager webStorageManager = WebStorageManager.instance();
// const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';
Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    final exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // await FirebaseAppCheck.instance
    //     // Your personal reCaptcha public key goes here:
    //     .activate(
    //   androidProvider: AndroidProvider.debug,
    //   appleProvider: AppleProvider.debug,
    //   webRecaptchaSiteKey: kWebRecaptchaSiteKey,
    // );
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.storage.request();
    await AndroidAlarmManager.initialize();
    await configureDependencies();
    await configureInjections(getIt);
    final workManagerService = GetIt.I<WorkManagerService>();
    workManagerService.initialize();
    workManagerService.cleanUploadedDataTaskFunc();
    // workManagerService.generateBookDataTaskFunc();
    Bloc.observer = AppBlocObserver();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
      // await webStorageManager.deleteAllData();
    }
    final themeLocaleIntRepository = ThemeLocaleIntRepository();
    runApp(App(
      themeLocaleIntRepository: themeLocaleIntRepository,
    ));
  }, (error, stackTrace) async {
    debugPrint('Caught Dart Error!');
    if (kDebugMode) {
      debugPrint('$error');
      debugPrint('$stackTrace');
    } else {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    }
  });
}
