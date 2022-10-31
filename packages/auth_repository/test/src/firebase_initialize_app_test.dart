import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);
void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future<T>.delayed(const Duration(minutes: 5));
  }
}
// MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
//   if (call.method == 'Firebase#initializeCore') {
//     return [
//       {
//         'name': defaultFirebaseAppName,
//         'options': {
//           'apiKey': '123',
//           'appId': '123',
//           'messagingSenderId': '123',
//           'projectId': '123',
//         },
//         'pluginConstants': const <String, String>{},
//       }
//     ];
//   }
//
//   if (call.method == 'Firebase#initializeApp') {
//     final arguments = call.arguments as Map<String, dynamic>;
//     return <String, dynamic>{
//       'name': arguments['appName'],
//       'options': arguments['options'],
//       'pluginConstants': const <String, String>{},
//     };
//   }
//
//   return null;
// });