import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:he_api/he_api.dart';

import 'repo_failure.dart';

abstract class IApkRepository{
  Stream<Either<Failure, DocumentSnapshot>> getLatestApk();
  Future<Apkupdatestatus?> getAppApk();
  // Future<Either<Failure, DownloadTask>> downloadApk();
}
