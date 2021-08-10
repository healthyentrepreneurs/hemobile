import 'dart:convert';

import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

class SharedPreferencesStorage extends StorageService {
  static const String UserKey = 'user';
  static const String LoginFlag = 'loginState';
  static const String OnlineFlag = 'online';
  // static const String ONLINE = 'off';
  // static const String OFFLINE = 'on';
  static const String SURUPDATE = "survey_upload_date";

  @override
  Future<int?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(LoginFlag) ?? 1;
  }

  @override
  Future<String> getOnline() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(OnlineFlag) ?? "off";
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString(UserKey);
    return userJson != null ? User.fromJson(json.decode(userJson)) : null;
    // return User.fromJson(json.decode(userJson!));
  }

  @override
  Future<void> setLogin(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoginFlag, value);
  }

  @override
  Future<void> setOffline(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(OnlineFlag, value);
  }

  @override
  Future<void> setOnline(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(OnlineFlag, value);
  }

  @override
  Future<void> setUser(User userToSave) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(UserKey, json.encode(userToSave.toJson()));
  }

  @override
  Future<String?> getSurveyUploadDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SURUPDATE) ?? null;
  }

  @override
  Future<void> setSurveyUploadDate(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SURUPDATE, value);
  }

  @override
  Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
