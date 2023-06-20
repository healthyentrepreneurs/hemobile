// Package imports
import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:he/injection.config.dart';
import 'package:he/service/work_manager_service.dart';
import 'package:he_storage/he_storage.dart';
import 'package:injectable/injectable.dart';

// Relative imports
import 'objects/objects.dart';
import 'service/appmodule_imp.dart';
import 'service/objectbox_service.dart';

final getIt = GetIt.instance;
@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => getIt.init();

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

@injectableInit
Future<void> configureInjections(GetIt getIt) async {
  final injectableModule = AppModuleImp();
  ObjectBoxService objectbox = await injectableModule.objectBoxService;
  getIt.registerLazySingleton<ApkupdateRepository>(() => ApkupdateRepository(
          apkupdateApi: RxStgApkUpdateApi(
        rxPrefs: injectableModule.getrxsharedprefrence,
      )));

  getIt.registerLazySingleton<HeAuthRepository>(() => HeAuthRepository(
      rxPrefs: injectableModule.getrxsharedprefrence,
      firebaseAuth: injectableModule.firebaseAuth));

  getIt.registerLazySingleton<ApkRepository>(
      () => ApkRepository(injectableModule.firestore));

  getIt.registerSingleton<DatabaseRepository>(
      DatabaseRepository(injectableModule.firestore, objectbox));
  // getIt.registerLazySingleton<DatabaseRepository>(
  //     () => DatabaseRepository(injectableModule.firestore, objectbox));
  getIt.registerSingleton<WorkManagerService>(WorkManagerService());

  getIt.registerLazySingleton<LclRxStgUpdateUploadApi>(() =>
      LclRxStgUpdateUploadApi(rxPrefs: injectableModule.getrxsharedprefrence));

  // getIt.registerLazySingleton<FoFiRepository>(() => FoFiRepository(
  //     directory: injectableModule.getdirectory,
  //     externalDownlodPath: injectableModule.getexternaldownlodpath));
}
