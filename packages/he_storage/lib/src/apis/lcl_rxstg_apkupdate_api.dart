import 'package:flutter/material.dart';
import 'package:he_storage/he_storage.dart';
import 'package:injectable/injectable.dart';

//We are Here
@injectable
class RxStgApkUpdateApi extends ApkUpdateApi {
  RxStgApkUpdateApi({
    required RxSharedPreferences rxPrefs,
  }) {
    _rxPrefs = rxPrefs;
  }

  late RxSharedPreferences _rxPrefs;
  static const seenUpdateKey = 'seen_update';

  Future<Apkupdatestatus?> _getValue(String key) =>
      _rxPrefs.read(key, Apkupdatestatus.toApkupdatestatusOrNull);

  Future<void> _setValue(String key, Apkupdatestatus value) async =>
      _rxPrefs.write(key, value, Apkupdatestatus.apkupdatestatusToString);

  Future<void> _removeValue(String key) => _rxPrefs.remove(key);

  @override
  Future<void> deleteSeenUpdateStatus() async {
    debugPrint('JacksonMutebi ');
    return _removeValue(seenUpdateKey);
  }

  @override
  Future<Apkupdatestatus> getSeenUpdateStatus() async {
    final seenUpdate = await _getValue(seenUpdateKey);
    if (seenUpdate == null) {
      return const Apkupdatestatus(seen: false, updated: false, heversion: '');
    }
    return seenUpdate;
  }

  @override
  Future<void> updateSeenUpdateStatus(Apkupdatestatus apkupdatestatus) async {
    return _setValue(seenUpdateKey, apkupdatestatus);
  }
}
