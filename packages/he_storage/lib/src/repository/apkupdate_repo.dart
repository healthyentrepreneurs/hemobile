// apkupdate_repo

import 'package:he_storage/he_storage.dart';
import 'package:injectable/injectable.dart';

/// {@template account_repository}
/// A repository that handles account related requests.
/// {@endtemplate}

@injectable
class ApkupdateRepository {
  /// {@macro account_repository}
  const ApkupdateRepository({
    required ApkUpdateApi apkupdateApi,
  }) : _apkupdateApi = apkupdateApi;

  final ApkUpdateApi _apkupdateApi;
  Apkupdatestatus getSeenUpdateStatus() => _apkupdateApi.getSeenUpdateStatus();
  // Apkupdatestatus getSeenUpdateStatus();
  void updateSeenUpdateStatus(Apkupdatestatus apkupdatestatus) =>
      _apkupdateApi.updateSeenUpdateStatus(apkupdatestatus);
  void deleteSeenUpdateStatus() => _apkupdateApi.deleteSeenUpdateStatus();
}
