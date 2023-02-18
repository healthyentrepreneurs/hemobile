import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

// import '../../../helper/file_system_util.dart';
import '../../../helper/file_system_util.dart';
import 'impl/idatabase_repo.dart';
import 'impl/repo_failure.dart';

@LazySingleton(as: IDatabaseRepository)
class DatabaseRepository implements IDatabaseRepository {
  final PublishSubject<HenetworkStatus> _henetworkStatus =
      PublishSubject<HenetworkStatus>();

  void addHenetworkStatus(HenetworkStatus status) {
    _henetworkStatus.add(status);
  }

  final DatabaseService _service =
      DatabaseService(firestore: FirebaseFirestore.instance);
  final DatabaseServiceLocal _serviceLocal = DatabaseServiceLocal();
// DatabaseService get service => _service;
// DatabaseServiceLocal get serviceLocal => _serviceLocal;
  @override
  Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData() {
// return _serviceLocal.retrieveSubscriptionDataLocal();
    return _service.retrieveSubscriptionData(3);
  }

  @override
  Future<void> saveUserData(Subscription user) {
// TODO: implement saveUserData
// return service.addUserData(user);
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<Subscription?>>>
      retrieveSubscriptionDataStream() {
    return _henetworkStatus.stream.switchMap((henetworkStatus) {
      debugPrint('DatabaseRepository@retrieveSubscriptionDataStream');
      if (henetworkStatus == HenetworkStatus.wifiNetwork) {
        debugPrint(
            'DatabaseRepository@retrieveSubscriptionDataStream connected');
        return _service.retrieveSubscriptionDataStream();
      } else {
        debugPrint(
            'DatabaseRepository@retrieveSubscriptionDataStream not connected');
        return _serviceLocal.retrieveSubscriptionDataLocalStream();
      }
    });
  }
}
