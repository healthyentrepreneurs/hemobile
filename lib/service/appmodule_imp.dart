// class AppModuleImp extends AppModule{
//
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:he_api/he_api.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'service.dart';

class AppModuleImp extends AppModule {
  @override
  Future<FirebaseService> get fireService => FirebaseService.init();

  @override
  Future<RxSharedPreferencesService> get getRxStorageService =>
      RxSharedPreferencesService.init();

  @override
  Future<PermitFoFiService> get getfolderfileService =>
      PermitFoFiService.init();

  @override
  Future<ObjectBoxService> get objectBoxService => ObjectBoxService.create();

  @override
  Future<HydratedStorage> get hydratedBloc => setupHydratedBloc();

  @override
  RxSharedPreferences get getrxsharedprefrence =>
      RxSharedPreferences.getInstance();

  @override
  FirebaseFirestore get firestore => FirebaseFirestore.instance
    ..useFirestoreEmulator(Endpoints.localEmulatorIp, 8080, sslEnabled: false)
    ..settings = const Settings(persistenceEnabled: false);

  @override
  firebase_auth.FirebaseAuth get firebaseAuth =>
      firebase_auth.FirebaseAuth.instance
        ..useAuthEmulator(Endpoints.localEmulatorIp, 9099);

  @override
  FirebaseStorage get storage => FirebaseStorage.instance
    ..bucket = Endpoints.bucketUrl
    ..useStorageEmulator(Endpoints.localEmulatorIp, 9199);

  @override
  Directory get getdirectory => PermitFoFiService.directory;

  @override
  String get getexternaldownlodpath => PermitFoFiService.externalDownlodPath;
}
