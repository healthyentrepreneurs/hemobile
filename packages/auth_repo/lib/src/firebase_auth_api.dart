import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:he_storage/he_storage.dart';
import 'package:rxdart/rxdart.dart';

/// {@template log_in_with_email_and_password_failure}
/// {@endtemplate}
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

/// {@template firebase_auth_repo}
/// {@endtemplate}

class FirebaseAuthApi {
  /// {@macro firebase_auth_repo}
  FirebaseAuthApi({
    required LclRxStgAccountApi accountApi,
    required firebase_auth.FirebaseAuth firebaseAuth,
  })  : _accountApi = accountApi,
        _firebaseAuth = firebaseAuth {
    _init();
  }

  final LclRxStgAccountApi _accountApi;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Whether or not the current environment is web
  /// Should only be overriden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;
  final BehaviorSubject<Account> _userSubject = BehaviorSubject<Account>();

  /// Stream of [Account] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [Account.empty] if the user is not authenticated.
  // Stream<Account> get user {
  //   return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
  //     final user = firebaseUser == null ? Account.empty : firebaseUser.toUser;
  //     debugPrint('What is here ${user.toJson()}');
  //     await _accountApi.saveAccount(user);
  //     return user;
  //   });
  // }
  Stream<Account> get user => _userSubject.stream;

  void _init() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      final user = firebaseUser == null ? Account.empty : firebaseUser.toUser;
      debugPrint('What is here ${user.toJson()}');
      if (user.isEmpty) {
        debugPrint('Namu is here ${user.toJson()}');
      } else {
        debugPrint('Jacki is here ${user.toJson()}');
        await _accountApi.saveAccount(user);
      }
      _userSubject.add(user);
    });
  }

  /// Returns the current cached user.
  /// Defaults to [Account.empty] if there is no cached user.
  Future<Account> get currentUser async {
    return _accountApi.getAccount().first;
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
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _accountApi.deleteAccount((await _accountApi.getAccount().first).id!),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  Account get toUser {
    return Account(id: uid.hashCode, username: uid, email: email);
  }
}
