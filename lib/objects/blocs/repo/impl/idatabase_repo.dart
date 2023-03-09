import 'package:dartz/dartz.dart';
import 'package:he/objects/objectbookcontent.dart';
import 'package:he_api/he_api.dart';

import '../../../../helper/file_system_util.dart';
import '../../../objectbookquiz.dart';
import 'repo_failure.dart';

abstract class IDatabaseRepository {
  Future<void> saveUserData(Subscription user);
  Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData();
  Stream<Either<Failure, List<Subscription?>>> retrieveSubscriptionDataStream(
      String userid);
  Stream<Either<Failure, List<Section?>>> retrieveBookSectionData(
      String courseid);
  Stream<Either<Failure, String>> retrieveSurveyStream(String courseid);
  Stream<Either<Failure, List<ObjectBookQuiz?>>> retrieveBookQuiz(
      String courseId, String section);
  Stream<Either<Failure, List<ObjectBookContent?>>> retrieveBookChapter(
      String courseId, String section, String bookcontextid);
  Future<void> addHenetworkStatus(HenetworkStatus status);
}
