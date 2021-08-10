import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/services/storage_service/storage_service.dart';

class LoginStateNotifier extends ValueNotifier<int> {
  LoginStateNotifier() : super(initialValue);
  static bool isLoading = false;
  static String? loginState;
  final _storageService = getIt<StorageService>();
  static late int initialValue = 2;

  Future<int> initialize() async {
    final _loginState = await _storageService.getLogin();
    return _loginState!;
  }

  void loginCall(String username, String password) {
    _loginCall(username, password);
  }

  void signOut() {}

  @override
  void dispose() {
    super.dispose();
  }

  void updateLoadingState(bool newValue) {
    isLoading = newValue;
    notifyListeners();
  }

  void updateLoginState() {
    notifyListeners();
  }

  void updateLoginStatus(int newValue) {
    initialValue = newValue;
    notifyListeners();
  }

  //Should Move To Service Layer
  _loginCall(String email, String password) {
    OpenApi()
        .login(email, password)
        .then((data) => {_processJson(data.body)})
        .catchError((err) =>
            {updateLoadingState(false), print("Error -- " + err.toString())});
  }

  _processJson(String body) {
    var json = jsonDecode(body);
    if (json['code'] == 200) {
      var user = User.fromJson(json['data']);
      _storageService.setUser(user);
      loginState = null;
      _storageService.setLogin(2);
      updateLoadingState(false);
    } else {
      loginState = "Wrong Credentials";
      print("Wrong Credentials");
      _storageService.setLogin(1);
      updateLoadingState(false);
    }
  }
}
