import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey_module/survey_module.dart';

void main() {
  const MethodChannel channel = MethodChannel('survey_module');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SurveyModule.platformVersion, '42');
  });
}
