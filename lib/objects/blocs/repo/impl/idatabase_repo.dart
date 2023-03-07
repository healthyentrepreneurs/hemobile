import 'package:dartz/dartz.dart';
import 'package:he_api/he_api.dart';

import '../../../../helper/file_system_util.dart';
import 'repo_failure.dart';

abstract class IDatabaseRepository {
  Future<void> saveUserData(Subscription user);
  Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData();
  Stream<Either<Failure, List<Subscription?>>> retrieveSubscriptionDataStream(String userid);
  Stream<Either<Failure, List<Section?>>> retrieveBookSectionData(
      String courseid);
  Stream<Either<Failure, String>> retrieveSurveyStream(String courseid);
  Future<void> addHenetworkStatus(HenetworkStatus status);
}
