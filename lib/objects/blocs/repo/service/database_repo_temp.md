import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';

import '../impl/idatabase_repo.dart';


class DatabaseRepository implements IDatabaseRepository {
  final DatabaseService _service =
      DatabaseService(firestore: FirebaseFirestore.instance);
  final DatabaseServiceLocal _serviceLocal = DatabaseServiceLocal();
  final Connectivity _connectivity = Connectivity();
  @override
  Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData() {
    // return _service.dataService.retrieveSubscriptionDataLocal();
    return _service.retrieveSubscriptionData(3);
    // return _service.retrieveSubscriptionDataLocal();
  }

  @override
  Future<void> saveUserData(Subscription user) {
    // TODO: implement saveUserData
    // return service.addUserData(user);
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<Subscription?>>>
      retrieveSubscriptionDataStream() async* {
    // ConnectivityResult connectivityResult =
    //     await _connectivity.checkConnectivity();
    // if (connectivityResult == ConnectivityResult.mobile ||
    //     connectivityResult == ConnectivityResult.wifi) {
    //   yield* _service.retrieveSubscriptionDataStream();
    // } else {
    //   yield* _serviceLocal.retrieveSubscriptionDataLocalStream();
    // }
    _connectivity.onConnectivityChanged.map((connectivityResult) async {
      if (connectivityResult == ConnectivityResult.none) {
        return _service.retrieveSubscriptionDataStream();
        // yield* _service.retrieveSubscriptionDataStream();
        // return Left(Failure(message: "No Internet Connection"));
      } else {
        return _serviceLocal.retrieveSubscriptionDataLocalStream();
        // return Right(await _service.retrieveSubscriptionData(3));
      }
    });
  }
}
