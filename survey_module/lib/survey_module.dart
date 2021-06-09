
import 'dart:async';

import 'package:flutter/services.dart';

class SurveyModule {
  static const MethodChannel _channel =
      const MethodChannel('survey_module');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
