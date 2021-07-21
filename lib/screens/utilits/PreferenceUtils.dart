import 'dart:async' show Future;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance = await SharedPreferences.getInstance();
  static late SharedPreferences _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static const String UserKey = 'user';
  static const String LoginFlag = 'loginState';
  static const String OnlineFlag = 'online';
  static const String ONLINE = 'on';
  static const String OFFLINE = 'off';
  // static String getString(String key, [String? defValue]) {
  //   return _prefsInstance.getString(key) ?? defValue ?? "";
  // }
  //
  // static Future<bool> setString(String key, String? value) async {
  //   var prefs = await _instance;
  //   return prefs.setString(key, value!);
  // }
  static User getUser() {
    var userJson = _getFromDisk(UserKey);
    return User.fromJson(json.decode(userJson));
  }

  static Future<bool?> setUser(User userToSave) {
    return _saveToDisk(UserKey, json.encode(userToSave.toJson()));
  }

  static bool getLoginxx() => _getFromDisk(LoginFlag) ?? false;
  static Future<bool> getLogin() async {
    var prefs = await _instance;
    return prefs.getBool(LoginFlag) ?? false;
  }

  static Future<bool?> setLogin(bool value) => _saveToDisk(LoginFlag, value);

  static String getOnline() => _getFromDisk(OnlineFlag) ?? "off";
  static Future<bool?> setOnline() => _saveToDisk(OnlineFlag, ONLINE);
  static Future<bool?> setOffline() => _saveToDisk(OnlineFlag, OFFLINE);

  static dynamic _getFromDisk(String key) {
    var value = _prefsInstance.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  static Future<bool?> _saveToDisk<T>(String key, T content) async {
    var prefs = await _instance;
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');
    if (content is String) {
      return prefs.setString(key, content);
    }
    if (content is bool) {
      return prefs.setBool(key, content);
    }
    if (content is int) {
      return prefs.setInt(key, content);
    }
    if (content is double) {
      return prefs.setDouble(key, content);
    }
    if (content is List<String>) {
      return prefs.setStringList(key, content);
    }
  }
}
