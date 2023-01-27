import 'package:auth_repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:he/service/concrete_firebase_injectable_module.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'objects/blocs/repo/apk_repo.dart';

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final getIt = GetIt.instance;
  @injectableInit
  void configureInjections(GetIt getIt) {
    final firebaseInjectableModule = ConcreteFirebaseInjectableModule();
    getIt.registerLazySingleton<FirebaseAuth>(
            () => firebaseInjectableModule.firebaseAuth);
    getIt.registerLazySingleton<FirebaseFirestore>(
            () => firebaseInjectableModule.firestore);
    getIt.registerLazySingleton<FirebaseStorage>(
            () => firebaseInjectableModule.storage);
    getIt.registerLazySingleton<LogRepository>(
            () => LogRepository(firebaseInjectableModule.firestore));
    getIt.registerLazySingletonAsync<PackageInfo>(() async {
      return await PackageInfo.fromPlatform();
    }
    );
  }
  configureInjections(getIt);
  // final logRepository = getIt<LogRepository>();
  final heAuthRepository = HeAuthRepository();
  final themeLocaleIntRepository = ThemeLocaleIntRepository();
  runApp(App(
    themeLocaleIntRepository: themeLocaleIntRepository,
    heAuthRepository: heAuthRepository,
  ));
}
