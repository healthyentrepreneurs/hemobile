import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:he/firebase_options.dart';

const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';

class FirebaseService {
  static Future<FirebaseService> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance
        // Your personal reCaptcha public key goes here:
        .activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
      webRecaptchaSiteKey: kWebRecaptchaSiteKey,
    );
    // https://firebase.google.com/docs/app-check/flutter/default-providers
    // userEmulator(true);
    // await FirebaseAppCheck.instance.activate(
    //   androidProvider: AndroidProvider.playIntegrity,
    // );
    // await FirebaseAppCheck.instance.activate(
    //   webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    //   // androidProvider: AndroidProvider.debug,
    // );
    return FirebaseService();
  }
}
