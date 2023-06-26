import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:he_storage/he_storage.dart';
import 'package:injectable/injectable.dart';

import 'impl/iapk_repo.dart';
import 'impl/repo_failure.dart';

@LazySingleton(as: IApkRepository)
class ApkRepository implements IApkRepository {
  final FirebaseFirestore _firestore;
  final RxStgApkUpdateApi _rxStgApkUpdateApi;
  ApkRepository(this._firestore, this._rxStgApkUpdateApi);
  @override
  Stream<Either<Failure, DocumentSnapshot>> getLatestApk() {
    try {
      return _firestore
          .collection('apks')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots()
          .map((event) {
        if (event.docs.isEmpty) {
          return Left(RepositoryFailure('No Apk found'));
        }
        return Right(event.docs.first);
      });
    } on Exception catch (e) {
      return Stream.value(Left(RepositoryFailure(e.toString())));
    }
  }

  @override
  Future<Apkupdatestatus?> getAppApk() async {
    final Apkupdatestatus packageInfo =
        await _rxStgApkUpdateApi.getSeenUpdateStatus();
    return packageInfo;
  }
}
