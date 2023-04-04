// https://github.com/felangel/bloc/blob/master/examples/flutter_todos/packages/todos_api/lib/src/todos_api.dart
import 'package:he_storage/he_storage.dart';

/// {@template user_api}
/// The interface for an API that provides access to a user user.
/// {@endtemplate}
abstract class UserApi {
  /// {@macro user_api}
  const UserApi();

  /// Provides a [Stream] of this user.
  Stream<User> getUser();

  /// Saves a [user].
  /// If a [user] with the same id already exists, it will be replaced.
  Future<void> saveUser(User user);

  /// Deletes the user with the given id.
  ///
  /// If no user with the given id exists, a [UserNotFoundException] error
  /// is thrown.
  Future<void> deleteUser(int id);
}

/// Error thrown when a [User] with a given id is not found.
class UserNotFoundException implements Exception {}
