import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';

import 'firebase_service.dart';
import 'getstorage_service.dart';

@module
abstract class AppModule {
  @preResolve
  Future<FirebaseService> get fireService => FirebaseService.init();

  @preResolve
  Future<GetStorageService> get getStorageService => GetStorageService.init();
  // create a getter for the box
  @lazySingleton
  @injectable
  GetStorage get box => GetStorage();

  @lazySingleton
  @injectable
  FirebaseFirestore get firestore => FirebaseFirestore.instance
    ..useFirestoreEmulator(Endpoints.localEmulatorIp, 8080, sslEnabled: false)
    ..settings = const Settings(persistenceEnabled: false);

  @lazySingleton
  @injectable
  FirebaseAuth get firebaseAuth =>
      FirebaseAuth.instance..useAuthEmulator(Endpoints.localEmulatorIp, 9099);

  @lazySingleton
  @injectable
  FirebaseStorage get storage => FirebaseStorage.instance
    ..bucket = Endpoints.bucketUrl
    ..useStorageEmulator(Endpoints.localEmulatorIp, 9199);

  // void tempJe(){
  //   FirebaseStorage get storage => FirebaseStorage.instanceFor(bucket: Endpoints.bucketUrl)
  //     ..useStorageEmulator(Endpoints.localEmulatorIp, 9199);
  // }
}
