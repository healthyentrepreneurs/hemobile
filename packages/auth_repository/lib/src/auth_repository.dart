import 'dart:async';

import 'package:auth_repository/auth_helper.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_api/user_api.dart' hide User, printOnlyDebug;

/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@contemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template auth_repository}
/// Repository which manages user authentication.
/// {@contemplate}
class AuthenticationRepository {
  /// {@macro auth_repository}
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance
          ..useAuthEmulator('192.168.0.26', 9099);
  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  final UserApiClient _userApiClient = UserApiClient();
  // _userApiClient = userApiClient ?? UserApiClient(),
  // final UserApiClient _userApiClient;
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  //Lang Settings
  //Must be hard coded unless its from Remote Config
  List<Locale> get listLocale => [
        const Locale('en', 'US'),
        const Locale('es', ''),
        const Locale('ar', ''),
        const Locale('nn'),
      ];
  Future<Locale> get currentLocale async {
    final local = await _cache.readLang();
    return local.isEmpty ? listLocale[0] : Locale(local.code, local.uppercode);
    // return listLocale[0];
  }

  Future<int> setLocale(String lang) async {
    try {
      final localObject = await _cache.readLang();
      final countrycode = localObject.code == 'en' ? 'US' : '';
      if (localObject.isNotEmpty) {
        return await _cache.updateLang(
          localObject.id!,
          lang,
          countrycode,
        );
      } else {
        final langObject = Langobject()
          ..code = lang
          ..uppercode = countrycode;
        return await _cache.writeLang(langObject);
      }
    } catch (e) {
      printOnlyDebug('$e \n twende');
      return 0;
    }
  }

  // List<Locale> get listLocale
  ///Sign in with Username and Password
  Future<User?> logInWithUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    try {
      final user = await _userApiClient.customeLogin(username, password);
      // await logInWithEmailAndPassword(email: user.email!, password: password);
      return User(
        id: user.id.toString(),
        username: user.username,
        email: user.email,
        photo: user.profileimageurlsmall,
        token: user.token,
        lang: user.lang,
        country: user.country,
      );
    } on UserNoSubscription catch (e) {
      throw const UserNoSubscription().message;
    } on UserRequestFailure catch (e) {
      throw const UserRequestFailure().message;
    } on UserNotFoundFailure catch (e) {
      throw const UserNotFoundFailure().message;
    } on FailedConnection catch (e) {
      throw const FailedConnection().message;
    } catch (e, stacktrace) {
      rethrow;
    }
  }

  /// Signs in with the provided [email] and [password].
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (en) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  /// close http
  Future<void> closeHttpInAuth() async {
    _userApiClient.closeHttp();
    // @override
    // void dispose() {
    //   api.client.close();
    //   super.dispose();
    // }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
