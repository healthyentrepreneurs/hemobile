import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:he/injection.config.dart';
import 'package:he_storage/he_storage.dart';
import 'package:injectable/injectable.dart';

import 'objects/objects.dart';
import 'service/appmodule_imp.dart';

final getIt = GetIt.instance;
@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => getIt.init();

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

@injectableInit
void configureInjections(GetIt getIt) {
  final injectableModule = AppModuleImp();
  getIt.registerLazySingleton<ApkupdateRepository>(() => ApkupdateRepository(
          apkupdateApi: RxStgApkUpdateApi(
        rxPrefs: injectableModule.getrxsharedprefrence,
      )));

  getIt.registerLazySingleton<HeAuthRepository>(() => HeAuthRepository(
      rxPrefs: injectableModule.getrxsharedprefrence,
      firebaseAuth: injectableModule.firebaseAuth));

  getIt.registerLazySingleton<LogRepository>(
      () => LogRepository(injectableModule.firestore));

  getIt.registerLazySingleton<DatabaseRepository>(
      () => DatabaseRepository(injectableModule.firestore));
  // getIt.registerLazySingleton<FoFiRepository>(() => FoFiRepository());
}
