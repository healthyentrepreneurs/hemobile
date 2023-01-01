import 'package:he_storage/he_storage.dart';

/// {@template account_repository}
/// A repository that handles account related requests.
/// {@endtemplate}
class AccountRepository {
  /// {@macro account_repository}
  const AccountRepository({
    required AccountApi accountApi,
  }) : _accountApi = accountApi;

  final AccountApi _accountApi;

  /// Provides a [Stream] of a account.
  Stream<Account> getAccount() => _accountApi.getAccount();

  /// Saves a [account].
  ///
  /// If a [account] with the same id already exists, it will be replaced.
  Future<void> saveAccount(Account account) => _accountApi.saveAccount(account);

  /// Deletes the user with the given id.
  ///
  /// If no user with the given id exists, a [AccountNotFoundException] error is
  /// thrown.
  Future<void> deleteAccount(int id) => _accountApi.deleteAccount(id);
}
