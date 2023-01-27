import 'package:he_storage/he_storage.dart';

abstract class ApkUpdateApi{
  const ApkUpdateApi();
  Apkupdatestatus getSeenUpdateStatus();
  void updateSeenUpdateStatus(Apkupdatestatus apkupdatestatus);
  void deleteSeenUpdateStatus();
}
/// Error thrown when a [Account] with a given id is not found.
class ApkupdateNotFoundException implements Exception {}
