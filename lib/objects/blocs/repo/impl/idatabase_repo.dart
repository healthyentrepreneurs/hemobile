import 'package:dartz/dartz.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:he_api/he_api.dart';

import '../../../../helper/file_system_util.dart';
import 'repo_failure.dart';

abstract class IDatabaseRepository {
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
  Future<Either<Failure, int>> saveSurveys(
      {required SurveyDataModel surveyData});

  Future<Either<Failure, int>> saveBookChapters({
    required String bookId,
    required String chapterId,
    required String courseId,
    required String userId,
    required bool isPending,
  });
  Stream<Either<Failure, int>> totalSavedSurvey();
}
