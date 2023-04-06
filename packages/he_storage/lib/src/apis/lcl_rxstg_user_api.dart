// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:he_storage/he_storage.dart';

/// {@template LclRxStgUserApi}
/// Implementation of the local storage user api.
/// {@endtemplate}
class LclRxStgUserApi extends UserApi {
  /// {@macro LclRxStgUserApi}
  LclRxStgUserApi({
    required RxSharedPreferences rxPrefs,
  }) {
    _rxPrefs = rxPrefs;
  }

  late RxSharedPreferences _rxPrefs;
  @visibleForTesting
  // ignore: public_member_api_docs
  static const actCacheKey = Endpoints.userCacheKey;

  Future<User?> _getValue(String key) => _rxPrefs.read(key, User.toUserOrEmpty);

  Future<void> _setValue(String key, User value) async => _rxPrefs.write<User>(
        key,
        value,
        User.userToString,
      );

  Future<void> _removeValue(String key) => _rxPrefs.remove(key);

  @override
  Future<void> deleteUser(int id) async {
    var _user = await _getValue(actCacheKey);
    if (id != 0 && id == _user?.id) {
      debugPrint('Deleted User ${_user?.toJson()}');
      return _removeValue(actCacheKey);
    } else if (id == 0) {
      debugPrint('Empty User ${_user?.toJson()}');
      throw UserNotFoundException();
    } else {
      debugPrint('ID mismatch User ${_user?.toJson()}');
      throw UserNotFoundException();
    }
  }

  @override
  Stream<User> getUser() => _rxPrefs
      .observe(actCacheKey, User.toUserOrNull)
      .map((event) => event ?? User.empty);
  // @override
  // Stream<User> getUser() => _rxPrefs
  //     .observe(actCacheKey, User.toUserOrNull)
  //     .map((event) => event ?? User.empty)
  //     .where((user) => user.isNotEmpty);

  @override
  Future<void> saveUser(User user) async {
    var _user = await _getValue(actCacheKey);
    debugPrint('UserDarth ${_user?.toJson()}');
    if (_user!.id != user.id && user.isNotEmpty) {
      debugPrint('User added ${user.toJson()}');
      return _setValue(actCacheKey, user);
    } else {
      debugPrint('saveUser isEmpty ${user.toJson()}');
      throw UserNotFoundException();
    }
  }
  // Future<void> saveUser(User user) async {
  //   var _user = await _getValue(actCacheKey);
  //   debugPrint('UserDarth ${_user?.toJson()}');
  //   if (user.isNotEmpty) {
  //     if (_user == null || _user!.id != user.id) {
  //       debugPrint('User added ${user.toJson()}');
  //     } else {
  //       debugPrint('User updated ${user.toJson()}');
  //     }
  //     return _setValue(actCacheKey, user);
  //   } else {
  //     debugPrint('saveUser isEmpty ${user.toJson()}');
  //     throw UserNotFoundException();
  //   }
  // }
}
