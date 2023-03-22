import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'app/app.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  Bloc.observer = AppBlocObserver();
  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }
  await configureDependencies();
  // userEmulator(true);
  // final getIt = GetIt.instance;
  configureInjections(getIt);
  // final logRepository = getIt<LogRepository>();
  final heAuthRepository = HeAuthRepository();
  final themeLocaleIntRepository = ThemeLocaleIntRepository();
  runApp(App(
    themeLocaleIntRepository: themeLocaleIntRepository,
    heAuthRepository: heAuthRepository,
  ));
}
