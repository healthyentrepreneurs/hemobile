import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';

import 'impl/idatabase_repo.dart';
import 'impl/repo_failure.dart';

@LazySingleton(as: IDatabaseRepository)
class DatabaseRepository implements IDatabaseRepository {
  final FirebaseFirestore _firestore;
  DatabaseRepository(this._firestore);
  final DatabaseService _service =
      DatabaseService(firestore: FirebaseFirestore.instance);

  @override
  Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData() {
    return _service.dataService.retrieveSubscriptionDataLocal();
    // return _service.retrieveSubscriptionData(3);
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
    return _service.retrieveSubscriptionDataStream();
  }

  // @override
  // Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData2() {
  //   // TODO: implement retrieveSubscriptionData2
  //   return _service.dataService.retrieveSubscriptionDataLocal();
  // }
}
