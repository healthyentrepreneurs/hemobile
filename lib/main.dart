import 'dart:io';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'helper/helper_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }
  await Permission.camera.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  userEmulator(true);
  await EasyLocalization.ensureInitialized();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  Locale localeCurrent = await authenticationRepository.currentLocale;
  BlocOverrides.runZoned(
    () => runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', ''),
        Locale('de', ''),
        Locale('nn', '')
      ],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: localeCurrent,
      child: App(authenticationRepository: authenticationRepository),
    )),
    blocObserver: AppBlocObserver(),
  );
}
