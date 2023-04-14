import 'package:dartz/dartz.dart';
import 'package:he_api/he_api.dart';

import '../../../../helper/file_system_util.dart';
import 'repo_failure.dart';

abstract class IDatabaseRepository {
  Future<void> saveUserData(Subscription user);
  // Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData();
  Stream<Either<Failure, List<Subscription?>>> retrieveSubscriptionDataStream(
      String userid);
  Stream<Either<Failure, List<Section?>>> retrieveBookSectionData(
      String courseid);
  Stream<Either<Failure, String>> retrieveSurveyStream(String courseid);
  Stream<Either<Failure, List<BookQuiz?>>> retrieveBookQuiz(
      String courseId, String section);
  Stream<Either<Failure, List<BookContent?>>> retrieveBookChapter(
      String courseId, String section, String bookcontextid, int bookIndex);
  Future<void> addHenetworkStatus(HenetworkStatus status);
  Future<Either<Failure, void>> saveSurveys({
    required String surveyId,
    required String country,
    required String email,
    required String userId,
    required String surveyJson,
    required String surveyVersion,
  });
}
