import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:auth_repo/src/auth/cache.dart';
import 'package:flutter/foundation.dart';
import 'package:he_storage/he_storage.dart';

/// {@template he_auth_repo}
/// Dart package which manages the HE user domain
/// {@endtemplate}
enum HeAuthStatus { unknown, authenticated, unauthenticated }

class HeAuthRepository {
  final _controller = StreamController<HeAuthStatus>();
  final FirebaseAuthApi _firebaseAuthApi = FirebaseAuthApi();
  final DataCodeApiClient _userApiClient = DataCodeApiClient();
  User _user = User.empty;
  final CacheClient appcache = CacheClient();
  @visibleForTesting
  static const userkey = '__user_cache__';
  Stream<HeAuthStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield HeAuthStatus.unauthenticated;
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
        final checkMe = await _firebaseAuthApi.user.first;
        debugPrint('Login Status ${checkMe.username}');
        if (checkMe.username == null) {
          debugPrint('HEFirebase not authenticated');
          await _firebaseAuthApi.logInWithEmailAndPassword(
            email: _user.email!,
            password: password,
          );
        }
        appcache.write(key: userkey, value: _user.toJson());
        debugPrint('Login Status Jec ${checkMe.username}');
        _controller.add(HeAuthStatus.authenticated);
        break;
      default:
        throw HeAuthException(loginState?.msg);
    }
  }

  User get user => _user;

  Future<void> logOut() async {
    _controller.add(HeAuthStatus.unauthenticated);
    await _firebaseAuthApi.logOut();
    appcache.delete(key: userkey);
  }

  void dispose() => _controller.close();
}

class HeAuthException implements Exception {
  String? message = 'An unknown exception occurred';
  HeAuthException(this.message);
}
