import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class AuthStateHandler {
//   final FirebaseAuth _auth;
//
//   AuthStateHandler(this._auth) {
//     _auth.idTokenChanges().listen((User? user) {
//       if (user == null) {
//         debugPrint('TravorUser is currently signed out!');
//       } else {
//         debugPrint('TravorUser is signed in!');
//       }
//     });
//   }
// }
import 'dart:async';

// class AuthStateHandler {
//   final FirebaseAuth _auth;
//   final StreamController<User?> _userStreamController;
//
//   AuthStateHandler(this._auth)
//       : _userStreamController = StreamController<User?>.broadcast() {
//     _auth.idTokenChanges().listen((User? user) {
//       _userStreamController.add(user);
//       if (user == null) {
//         debugPrint('TravorUser is currently signed out!');
//       } else {
//         debugPrint('TravorUser is signed in!');
//       }
//     });
//   }
//
//   Stream<User?> get userStream => _userStreamController.stream;
//
//   Future<void> reloadCurrentUser() async {
//     try {
//       await _auth.currentUser?.reload();
//       _userStreamController.add(_auth.currentUser);
//       debugPrint('User profile reloaded');
//     } catch (error) {
//       debugPrint('Error reloading user: $error');
//     }
//   }
//
//   void dispose() {
//     _userStreamController.close();
//   }
// }
