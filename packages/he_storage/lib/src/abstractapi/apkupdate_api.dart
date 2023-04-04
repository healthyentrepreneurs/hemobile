import 'package:he_storage/he_storage.dart';

abstract class ApkUpdateApi {
  const ApkUpdateApi();
  Future<Apkupdatestatus> getSeenUpdateStatus();
  Future<void> updateSeenUpdateStatus(Apkupdatestatus apkupdatestatus);
  Future<void> deleteSeenUpdateStatus();
}

/// Error thrown when a [Account] with a given id is not found.
class ApkupdateNotFoundException implements Exception {}
