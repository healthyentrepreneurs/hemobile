import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';

abstract class IApkDRepository {
  // QueryDocumentSnapsho
  Future<Either<Failure, DownloadTask>> downloadApk();
}