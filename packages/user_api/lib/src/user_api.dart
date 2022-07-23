import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:user_api/user_api.dart';

/// Exception thrown when customeLogin fails.
class UserRequestFailure implements Exception {
  const UserRequestFailure([
    this.message = 'User request faliure',
  ]);
  final String message;
}

/// Exception thrown when the provided user is not found.
class UserNotFoundFailure implements Exception {
  const UserNotFoundFailure([
    this.message = 'User Not Found',
  ]);
  final String message;
}

/// Exception thrown when the provided user is not found.
class UserNoSubscription implements Exception {
  const UserNoSubscription([
    this.message = 'User has no content quiz/books or survey',
  ]);
  final String message;
}

class FailedConnection extends SocketException {
  const FailedConnection([
    this.message = 'No connection to the server',
  ]) : super('');
  final String message;
}

/// {@template user_api}
/// Dart API Client which wraps the [User API](http://localhost:5051/userlogin/).
/// {@contemplate}
class UserApiClient {
  /// {@macro user_api}
  UserApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// Finds a [User] `/login`.
  Future<User> customeLogin(String username, String password) async {
    try {
      final loginResponse = await httpP(
        _httpClient,
        baseUrl,
        '/userlogin',
        <String, String>{'username': username, 'password': password},
        'post',
      );

      if (loginResponse.statusCode != 200) {
        printOnlyDebug("whats the issue ${loginResponse.body}");
        throw const UserRequestFailure();
      }
      final userJson = jsonDecode(loginResponse.body) as Map<String, dynamic>;
      if (userJson.isEmpty) {
        throw const UserNotFoundFailure();
      }
      return User.fromJson(userJson['data'] as Map<String, dynamic>);
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        throw const FailedConnection();
      } else if (e is TimeoutException) {
        //treat TimeoutException
        printOnlyDebug('Timeout exception: ${e.toString()}');
        rethrow;
      } else {
        rethrow;
      }
    }
  }

  ///Close If not closed
  void closeHttp() {
    _httpClient.close();
  }
}
