import 'package:flutter/foundation.dart';
import 'package:he_storage/he_storage.dart';

/// {@template LclRxStgAccountApi}
/// Implementation of the local storage account api.
/// {@endtemplate}
class LclRxStgAccountApi extends AccountApi {
  /// {@macro LclRxStgAccountApi}
  LclRxStgAccountApi({
    required RxSharedPreferences rxPrefs,
  }) {
    _rxPrefs = rxPrefs;
  }

  late RxSharedPreferences _rxPrefs;
  @visibleForTesting
  // ignore: public_member_api_docs
  static const actCacheKey = Endpoints.userCacheKey;

  Future<Account?> _getValue(String key) =>
      _rxPrefs.read(key, Account.toAccountOrEmpty);

  Future<void> _setValue(String key, Account value) async =>
      _rxPrefs.write<Account>(
        key,
        value,
        Account.accountToString,
      );

  Future<void> _removeValue(String key) => _rxPrefs.remove(key);

  @override
  Future<void> deleteAccount(int id) async {
    var _account = await _getValue(actCacheKey);
    if (id != 0 && id == _account?.id) {
      debugPrint('Deleted Account ${_account?.toJson()}');
      return _removeValue(actCacheKey);
    } else if (id == 0) {
      debugPrint('Empty Account ${_account?.toJson()}');
      throw AccountNotFoundException();
    } else {
      debugPrint('ID mismatch Account ${_account?.toJson()}');
      throw AccountNotFoundException();
    }
  }

  @override
  Stream<Account> getAccount() => _rxPrefs
      .observe(actCacheKey, Account.toAccountOrNull)
      .map((event) => event ?? Account.empty);

  @override
  Future<void> saveAccount(Account account) async {
    var _account = await _getValue(actCacheKey);
    debugPrint('Darth ${_account?.toJson()}');
    if (_account!.id != account.id && account.isNotEmpty) {
      debugPrint('User added ${account.toJson()}');
      return _setValue(actCacheKey, account);
    } else {
      debugPrint('saveAccount isEmpty ${account.toJson()}');
      throw AccountNotFoundException();
    }
  }
}
