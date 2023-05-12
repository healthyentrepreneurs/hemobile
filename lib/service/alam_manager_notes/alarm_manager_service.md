import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

const String countKey = 'count';
const String isolateName = 'isolate';
final ReceivePort _port = ReceivePort();
SharedPreferences? prefs;

class AlarmManagerService {
  static SendPort? uiSendPort;
  static ReceivePort get port => _port;

  static Future<void> init() async {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    prefs = await SharedPreferences.getInstance();
    if (!prefs!.containsKey(countKey)) {
      await prefs!.setInt(countKey, 0);
    }
    AndroidAlarmManager.initialize();
  }

  static Future<void> _incrementCounter() async {
    print('Increment counter!');
    await prefs!.reload();

    int currentCount = prefs!.getInt(countKey) ?? 0;
    await prefs!.setInt(countKey, currentCount + 1);
  }

  static Future<void> _decrementCounter() async {
    print('Decrement counter!');
    await prefs!.reload();

    int currentCount = prefs!.getInt(countKey) ?? 0;
    await prefs!.setInt(countKey, max(0, currentCount - 1));
  }

  static Future<void> _incrementUsingCounterTill200() async {
    print('Increment counter till 200!');
    await prefs!.reload();

    int currentCount = prefs!.getInt(countKey) ?? 0;
    if (currentCount < 200) {
      for (int i = currentCount; i < 200; i++) {
        print('INCSHOWME $currentCount');
        await prefs!.setInt(countKey, i + 1);
      }
    }
  }

  static void _oneShotTaskCallback() {
    print("One Shot Task Running");
  }

  static Future<void> _decrementUsingCounterTill0() async {
    print('Decrement counter till 0!');
    await prefs!.reload();

    int currentCount = prefs!.getInt(countKey) ?? 0;
    if (currentCount > 0) {
      for (int i = currentCount; i > 0; i--) {
        print('DECSHOWME $currentCount');
        await prefs!.setInt(countKey, i - 1);
      }
    }
  }

  static Future<void> callback(String action) async {
    debugPrint('Alarm fired! and action $action');
    if (action == 'increment') {
      await _incrementCounter();
    } else if (action == 'decrement') {
      await _decrementCounter();
    } else if (action == 'increment_till_200') {
      // await _incrementUsingCounterTill200();
      await AndroidAlarmManager.oneShot(
          const Duration(seconds: 1), 2, _incrementUsingCounterTill200);
    } else if (action == 'decrement_till_0') {
      await _decrementUsingCounterTill0();
    }
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(action);
  }
}
