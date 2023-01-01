import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:he_api/he_api.dart';

void printOnlyDebug(var objectPrint) {
  if (kDebugMode) {
    print(objectPrint);
  }
}

void printOnlyDebugWrapped(var objectPrint) {
  // if (kDebugMode) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(objectPrint).forEach((match) => debugPrint(match.group(0)));
  // }
}

// debugPrint('Received click');
Future<void> userEmulator(bool emulator) async {
  const String host = Endpoints.localEmulatorIp;
  if (Platform.isAndroid && emulator) {
    FirebaseFirestore.instance
        .useFirestoreEmulator(host, 8080, sslEnabled: false);
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
    await FirebaseStorage.instanceFor(bucket: Endpoints.bucketUrl)
        .useStorageEmulator(host, 9199);
  }
}
