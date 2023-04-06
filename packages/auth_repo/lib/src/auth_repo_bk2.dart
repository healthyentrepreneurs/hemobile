import 'dart:async';

import 'package:auth_repo/src/firebase_auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:he_storage/he_storage.dart';
import 'package:rxdart/rxdart.dart';

/// {@template he_auth_repo}
/// Dart package which manages the HE user domain
/// {@endtemplate}
enum HeAuthStatus { unknown, authenticated, unauthenticated }

class HeAuthRepository {
  // final FirebaseAuthApi _firebaseAuthApi = FirebaseAuthApi();

  HeAuthRepository({
    required RxSharedPreferences rxPrefs,
    required firebase_auth.FirebaseAuth firebaseAuth,
  })  : _firebaseAuthApi = FirebaseAuthApi(
          accountApi: LclRxStgAccountApi(rxPrefs: rxPrefs),
          firebaseAuth: firebaseAuth,
        ),
        _userApi = LclRxStgUserApi(rxPrefs: rxPrefs) {
    _firebaseAuthApi.user.listen((user) {
      _userSubject.add(user);
    });
  }

  final _controller = StreamController<HeAuthStatus>();
  final FirebaseAuthApi _firebaseAuthApi;
  final DataCodeApiClient _userApiClient = DataCodeApiClient();
  User _user = User.empty;
  final LclRxStgUserApi _userApi;
  final BehaviorSubject<Account> _userSubject = BehaviorSubject<Account>();

  Future<void> _initializeUser() async {
    _user = await _userApi.getUser().first;
    // You can add more initialization logic here if needed
  }

  // Stream<HeAuthStatus> get status async* {
  //   await Future<void>.delayed(const Duration(seconds: 1));
  //   yield HeAuthStatus.unauthenticated;
  //   yield* _controller.stream;
  // }

  Stream<HeAuthStatus> get status async* {
    await _initializeUser();
    if (_user.isNotEmpty) {
      yield HeAuthStatus.authenticated;
    } else {
      yield HeAuthStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<User?> logIn({
    required String username,
    required String password,
  }) async {
    final loginState = await _userApiClient.userLogin(username, password);
    final code = loginState?.code;
    switch (code) {
      case 200:
        _user = loginState!.data!;
        debugPrint('Mona ${_user.toJson()}');
        if (_userSubject.hasValue) {
          debugPrint('HEREHE Status ');
        } else {
          debugPrint('HEFirebase not authenticated');
          await _firebaseAuthApi.logInWithEmailAndPassword(
            email: _user.email!,
            password: password,
          );
        }
        await _userApi.saveUser(_user);
        _controller.add(HeAuthStatus.authenticated);
        break;
      default:
        throw HeAuthException(loginState?.msg);
    }
  }

  User get user => _user;

  Future<void> logOut() async {
    await _firebaseAuthApi.logOut();
    _controller.add(HeAuthStatus.unauthenticated);
    await _firebaseAuthApi.logOut();
    await _userApi.deleteUser(_user.id!);
  }

  void dispose() => _controller.close();
}

class HeAuthException implements Exception {
  HeAuthException(this.message);
  String? message = 'An unknown exception occurred';
}
