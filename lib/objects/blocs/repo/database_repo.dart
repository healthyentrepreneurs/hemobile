import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:he/objects/blocs/repo/service/service.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';

import 'impl/idatabase_repo.dart';

@LazySingleton(as: IDatabaseRepository)
class DatabaseRepository implements IDatabaseRepository {
  final FirebaseFirestore _firestore;
  DatabaseRepository(this._firestore);
  DatabaseService service =
      DatabaseService(firestore: FirebaseFirestore.instance);

  @override
  Future<void> saveUserData(Subscription user) {
    return service.addUserData(user);
  }

  @override
  Future<List<Subscription?>> retrieveSubscriptionData() {
    return service.retrieveSubscriptionData(3);
  }
}
