import 'package:he_api/he_api.dart';

abstract class IDatabaseRepository {
  Future<void> saveUserData(Subscription user);
  Future<List<Subscription?>> retrieveSubscriptionData();
}
