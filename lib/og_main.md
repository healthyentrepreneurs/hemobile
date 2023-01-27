import 'package:auth_repo/auth_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'helper/helper_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  Bloc.observer = AppBlocObserver();
  // https://api.flutter.dev/flutter/widgets/WidgetsBindingObserver-class.html
  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }
  await Permission.camera.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  userEmulator(true);
  final heAuthRepository = HeAuthRepository();
  final themeLocaleIntRepository = ThemeLocaleIntRepository();
  runApp(App(themeLocaleIntRepository: themeLocaleIntRepository, heAuthRepository: heAuthRepository,));
}
