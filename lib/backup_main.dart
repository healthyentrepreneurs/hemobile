import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nl_health_app/screens/homePage/homePage.dart';
import 'package:nl_health_app/screens/login/loginPage.dart';
import 'package:nl_health_app/screens/login/login_logic.dart';
import 'package:nl_health_app/services/service_locator.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    final exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    setupGetIt();
    runApp(Phoenix(child: MyApp()));
    //https://firebase.google.com/docs/crashlytics/test-implementation?platform=android#enable_debug_logging
    //Had to manually add this
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }, (error, stackTrace) async {
    print('Caught Dart Error!');
    // kDebugMode
    if (kDebugMode) {
      //Print The errors
      print('$error');
      print('$stackTrace');
    } else {
      //Send to Error reporting System
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
  // WidgetsFlutterBinding.ensureInitialized();
  // runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final stateManager = getIt<LoginManager>();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: stateManager.loginStateNotifier,
      builder: (context, whatsIssue, __) {
        int papa = stateManager.isSignedIn();
        return MaterialApp(
          title: 'HE Health',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff349141),
            accentColor: Colors.green,
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: papa == 1 ? LoginPage() : Homepage(),
        );
      },
    );
  }
  // void checkMyName(BuildContext context){
  //   Phoenix.rebirth(context);
  // }
  @override
  void initState() {
    super.initState();
  }
}
