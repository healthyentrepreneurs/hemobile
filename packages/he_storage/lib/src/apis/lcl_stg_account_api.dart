import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:he_storage/he_storage.dart';
import 'package:rxdart/subjects.dart';

/// {@template LclStgAccountApi}
/// Implementation of the local storage account api.
/// {@endtemplate}
class LclStgAccountApi extends AccountApi {
  /// {@macro LclStgAccountApi}
  // Remove account from constructor
  LclStgAccountApi({required SharedPreferences plugin}) : _plugin = plugin {
    _init();
  }
  late BehaviorSubject<Account> _actStreamCtl;
  final SharedPreferences _plugin;
  // ignore: public_member_api_docs
  // Account account = Account.empty;

  @visibleForTesting
  // ignore: public_member_api_docs
  static const actCacheKey = Endpoints.userCacheKey;

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  Future<void> _removeValue(String key) async => _plugin.remove(key);

  Future<void> _init() async {
    _actStreamCtl = BehaviorSubject<Account>.seeded(Account.empty);
    final accountJson = _getValue(actCacheKey);
    if (accountJson != null) {
      // ignore: no_leading_underscores_for_local_identifiers
      final _actUser = Account.fromJson(
        jsonDecode(accountJson) as Map<String, dynamic>,
      );
      _actStreamCtl.add(_actUser);
      debugPrint('Init accountJson ${_actUser.username}');
    } else {
      _actStreamCtl.add(Account.empty);
      debugPrint('Look dataJson');
    }
  }

  @override
  Future<void> deleteAccount(int id) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _account = _actStreamCtl.value;
    if (id != 0 && id == _account.id) {
      debugPrint('Deleted Account ${_account.toJson()}');
      _actStreamCtl.add(Account.empty);
      return _removeValue(actCacheKey);
    } else if (id == 0) {
      debugPrint('Empty Account ${_account.toJson()}');
      throw AccountNotFoundException();
    } else {
      debugPrint('ID mismatch Account ${_account.toJson()}');
      throw AccountNotFoundException();
    }
  }

  @override
  Stream<Account> getAccount() => _actStreamCtl.asBroadcastStream();

  @override
  Future<void> saveAccount(Account account) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _account = _actStreamCtl.value;
    if (_account.id != account.id && account.isNotEmpty) {
      _actStreamCtl.add(account);
      debugPrint('User added ${account.toJson()}');
      return _setValue(actCacheKey, json.encode(account));
    } else {
      debugPrint('saveAccount isEmpty ${account.toJson()}');
      throw AccountNotFoundException();
    }
  }
}
