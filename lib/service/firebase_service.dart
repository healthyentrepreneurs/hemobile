import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:he/firebase_options.dart';

import '../helper/helper_functions.dart';

class FirebaseService {
  static Future<FirebaseService> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // https://firebase.google.com/docs/app-check/flutter/default-providers
    // await FirebaseAppCheck.instance.activate();
    // userEmulator(true);
    return FirebaseService();
  }
}
