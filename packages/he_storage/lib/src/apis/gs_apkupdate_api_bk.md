
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:he_storage/he_storage.dart';

class GsApkUpdateApi extends ApkUpdateApi {
  GsApkUpdateApi({
    required GetStorage box,
  }) {
    _box = box;
  }

  late GetStorage _box;
  // final box = GetStorage();

  @override
  Future<void> deleteSeenUpdateStatus() {
    debugPrint('JacksonMutebi ');
    return _box.remove('seen_update');
    return _box.erase();
  }

  @override
  Apkupdatestatus getSeenUpdateStatus() {
    //check if the box has the key else return default
    if (!_box.hasData('seen_update')) {
      return const Apkupdatestatus(
        seen: false,
        updated: false,
      );
    }
    final seen_update = _box.read('seen_update');
    // final seenUpdate = Apkupdatestatus.fromJson(
    //   jsonDecode(seen_update) as Map<String, dynamic>,
    // );
    final seenUpdate = Apkupdatestatus.fromJson(seen_update as Map<String, dynamic>);
    return seenUpdate;
  }

  @override
  Future<void> updateSeenUpdateStatus(Apkupdatestatus apkupdatestatus) {
    return _box.write('seen_update', apkupdatestatus.toJson());
  }
}
