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
  Future<Apkupdatestatus> getSeenUpdateStatus() =>
      _apkupdateApi.getSeenUpdateStatus();
  Future<void> updateSeenUpdateStatus(Apkupdatestatus apkupdatestatus) =>
      _apkupdateApi.updateSeenUpdateStatus(apkupdatestatus);
  Future<void> deleteSeenUpdateStatus() =>
      _apkupdateApi.deleteSeenUpdateStatus();
}
