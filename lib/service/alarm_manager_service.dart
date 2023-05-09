import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String countKey = 'count';
const String isolateName = 'isolate';
final ReceivePort port = ReceivePort();
SharedPreferences? prefs;

class AlarmManagerService {
  static final AlarmManagerService _instance = AlarmManagerService._internal();

  factory AlarmManagerService() {
    return _instance;
  }

  AlarmManagerService._internal();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );

    if (!prefs!.containsKey(countKey)) {
      await prefs!.setInt(countKey, 0);
    }

    AndroidAlarmManager.initialize();
    port.listen((_) async => await _incrementCounter());
  }

  Future<void> _incrementCounter() async {
    // Increment counter logic
  }

  static SendPort? uiSendPort;

  static Future<void> callback() async {
    // Alarm callback logic
  }
}
