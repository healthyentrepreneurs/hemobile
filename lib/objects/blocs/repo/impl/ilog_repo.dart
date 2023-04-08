import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'repo_failure.dart';

abstract class ILogRepository {
  // Stream<Either<Failure, QuerySnapshot>> getApks();
  // QueryDocumentSnapshot
  Stream<Either<Failure, DocumentSnapshot>> getLatestApk();
  Future<PackageInfo?> getAppApk();
}
