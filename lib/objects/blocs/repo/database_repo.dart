import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helper/file_system_util.dart';
import 'impl/idatabase_repo.dart';
import 'impl/repo_failure.dart';

@LazySingleton(as: IDatabaseRepository)
class DatabaseRepository implements IDatabaseRepository {
  final FirebaseFirestore _firestore;
  DatabaseRepository(this._firestore);
  final BehaviorSubject<HenetworkStatus> _henetworkStatusSubject =
      BehaviorSubject<HenetworkStatus>.seeded(HenetworkStatus.loading);

  DatabaseService _service() => DatabaseService(firestore: _firestore);
  final DatabaseServiceLocal _serviceLocal = DatabaseServiceLocal();
  @override
  Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData() {
// return _serviceLocal.retrieveSubscriptionDataLocal();
    return _service().retrieveSubscriptionData(3);
  }

  // create a final variable that calls a function from the service

  @override
  Future<void> saveUserData(Subscription user) {
// return service.addUserData(user);
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<Subscription?>>>
      retrieveSubscriptionDataStream() {
    final checkValue = _henetworkStatusSubject.valueOrNull;
    debugPrint('Shit@retrieveSubscriptionDataStream $checkValue');
    // checkValue != null &&
    if (checkValue == HenetworkStatus.wifiNetwork) {
      debugPrint('DatabaseRepository@retrieveSubscriptionDataStream connected');
      return _service().retrieveSubscriptionDataStream();
    } else {
      debugPrint(
          'DatabaseRepository@retrieveSubscriptionDataStream not connected');
      return _serviceLocal.retrieveSubscriptionDataLocalStream();
    }
  }

  @override
  Future<void> addHenetworkStatus(HenetworkStatus status) async {
    _henetworkStatusSubject.add(status);
  }
}
