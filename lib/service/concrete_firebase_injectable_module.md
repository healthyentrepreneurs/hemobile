import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_injectable_module.dart';


class ConcreteFirebaseInjectableModule extends FirebaseInjectableModule {
  @override
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @override
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  FirebaseStorage get storage => FirebaseStorage.instance;
}