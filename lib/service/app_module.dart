import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:he/service/permit_fofi_service.dart';
import 'package:he/service/rx_sharedpref_service.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'firebase_service.dart';

@module
abstract class AppModule {
  @preResolve
  Future<FirebaseService> get fireService => FirebaseService.init();

  @preResolve
  Future<RxSharedPreferencesService> get getRxStorageService =>
      RxSharedPreferencesService.init();

  @preResolve
  Future<PermitFoFiService> get getfolderfileService =>
      PermitFoFiService.init();

  @lazySingleton
  @injectable
  RxSharedPreferences get getrxsharedprefrence =>
      RxSharedPreferences.getInstance();

  @lazySingleton
  @injectable
  FirebaseFirestore get firestore => FirebaseFirestore.instance
    ..useFirestoreEmulator(Endpoints.localEmulatorIp, 8080, sslEnabled: false)
    ..settings = const Settings(persistenceEnabled: false);

  @lazySingleton
  @injectable

  // FirebaseAuth get firebaseAuth =>
  //     FirebaseAuth.instance..useAuthEmulator(Endpoints.localEmulatorIp, 9099);
  firebase_auth.FirebaseAuth get firebaseAuth => firebase_auth.FirebaseAuth.instance
    ..useAuthEmulator(Endpoints.localEmulatorIp, 9099);

  @lazySingleton
  @injectable
  FirebaseStorage get storage => FirebaseStorage.instance
    ..bucket = Endpoints.bucketUrl
    ..useStorageEmulator(Endpoints.localEmulatorIp, 9199);

  @lazySingleton
  @injectable
  Directory get getdirectory => PermitFoFiService.directory;

  @lazySingleton
  @injectable
  String get getexternaldownlodpath => PermitFoFiService.externalDownlodPath;
}
