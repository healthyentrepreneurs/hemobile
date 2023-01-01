// https://github.com/felangel/bloc/blob/master/examples/flutter_todos/packages/todos_api/lib/src/todos_api.dart
import 'package:he_storage/he_storage.dart';

/// {@template account_api}
/// The interface for an API that provides access to a user account.
/// {@endtemplate}
abstract class AccountApi {
  /// {@macro account_api}
  const AccountApi();

  /// Provides a [Stream] of this account.
  Stream<Account> getAccount();

  /// Saves a [account].
  /// If a [account] with the same id already exists, it will be replaced.
  Future<void> saveAccount(Account account);

  /// Deletes the account with the given id.
  ///
  /// If no account with the given id exists, a [AccountNotFoundException] error
  /// is thrown.
  Future<void> deleteAccount(int id);
}

/// Error thrown when a [Account] with a given id is not found.
class AccountNotFoundException implements Exception {}
