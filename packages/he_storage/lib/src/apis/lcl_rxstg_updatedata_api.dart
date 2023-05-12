import 'package:flutter/material.dart';
import 'package:he_storage/he_storage.dart';

/// {@template LclRxStgUserApi}
/// Implementation of the local storage user api.
/// {@endtemplate}
class LclRxStgUpdateUploadApi extends UpdateUploadApi {
  /// {@macro LclRxStgUserApi}
  LclRxStgUpdateUploadApi({
    required RxSharedPreferences rxPrefs,
  }) {
    _rxPrefs = rxPrefs;
  }

  late RxSharedPreferences _rxPrefs;
  @visibleForTesting
  // ignore: public_member_api_docs
  static const updateuploadCacheKey = Endpoints.updateuploadCacheKey;

  Future<UpdateUpload?> _getValue(String key) =>
      _rxPrefs.read(key, UpdateUpload.toUpdateUploadOrEmpty);

  Future<void> _setValue(String key, UpdateUpload value) async =>
      _rxPrefs.write<UpdateUpload>(
        key,
        value,
        UpdateUpload.updateUploadToString,
      );

  Future<void> _removeValue(String key) => _rxPrefs.remove(key);

  @override
  Future<void> deleteUpdateUpload(int id) async {
    var _user = await _getValue(updateuploadCacheKey);
    if (id != 0 && id == _user?.id) {
      debugPrint('Deleted UpdateUpload ${_user?.toJson()}');
      return _removeValue(updateuploadCacheKey);
    } else if (id == 0) {
      debugPrint('Empty UpdateUpload ${_user?.toJson()}');
      throw UpdateUploadNotFoundException();
    } else {
      debugPrint('ID mismatch User ${_user?.toJson()}');
      throw UpdateUploadNotFoundException();
    }
  }

  // @override
  // Stream<UpdateUpload> getUpdateUpload() => _rxPrefs
  //     .observe(updateuploadCacheKey, UpdateUpload.toUpdateUploadOrNull)
  //     .map((event) => event ?? UpdateUpload.empty);

  @override
  Stream<UpdateUpload> getUpdateUpload() => _rxPrefs
          .observe(updateuploadCacheKey, UpdateUpload.toUpdateUploadOrNull)
          .map((event) {
        final updateUpload = event ?? UpdateUpload.empty;
        debugPrint('getUpdateUpload event: ${updateUpload.toJson()}');
        return updateUpload;
      });

  // Stream<UpdateUpload> getUpdateUpload() {
  //   return _rxPrefs
  //       .observe(updateuploadCacheKey, UpdateUpload.toUpdateUploadOrNull)
  //       .map((event) => event ?? UpdateUpload.empty)
  //       .asBroadcastStream(); // Use shareValue() from rxdart to buffer the latest event
  // }

  @override
  Future<void> saveUpdateUpload(UpdateUpload user) async {
    var _user = await _getValue(updateuploadCacheKey);
    debugPrint('UpdateUploadDarth ${_user?.toJson()}');

    // Check if the user ID is 1 and the user object is not empty
    if (user.id == 1 && user.isNotEmpty) {
      if (_user == null || _user.id != user.id) {
        debugPrint('UpdateUpload added ${user.toJson()}');
      } else {
        debugPrint('UpdateUpload updated ${user.toJson()}');
      }
      return _setValue(updateuploadCacheKey, user);
    } else {
      debugPrint('saveUpdateUpload isEmpty or invalid ID ${user.toJson()}');
      throw UpdateUploadNotFoundException();
    }
  }
}
