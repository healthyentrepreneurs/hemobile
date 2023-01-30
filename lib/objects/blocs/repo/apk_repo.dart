import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'impl/ilog_repo.dart';
import 'impl/repo_failure.dart';

@LazySingleton(as: ILogRepository)
class LogRepository implements ILogRepository {
  final FirebaseFirestore _firestore;

  LogRepository(this._firestore);

  @override
  Stream<Either<Failure, QuerySnapshot>> getApks() {
    try {
      return _firestore.collection('apks').snapshots().map((event) {
        if (event.docs.isEmpty) {
          return Left(RepositoryFailure('No Apk found'));
        }
        return Right(event);
      });
    } on Exception catch (e) {
      return Stream.value(Left(RepositoryFailure(e.toString())));
    }
  }

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
  Future<PackageInfo?> getAppApk() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
