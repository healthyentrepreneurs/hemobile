part of 'survey_bloc.dart';

// @immutable
abstract class SurveyEvent extends Equatable {
  const SurveyEvent();
}

class SurveyFetched extends SurveyEvent {
  final String courseid;
  final HenetworkStatus? henetworkStatus;
  const SurveyFetched(this.courseid, this.henetworkStatus);
  @override
  List<Object?> get props => [courseid, henetworkStatus];
}

class SurveySave extends SurveyEvent {
  final String surveyId;
  final String surveyVersion;
  final String surveyJson;
  final String userId;
  final String country;
  final String courseId;
  final bool isPending;
  // final HenetworkStatus? henetworkStatus;
  const SurveySave(this.surveyId, this.surveyVersion, this.surveyJson,
      this.userId, this.country, this.courseId, this.isPending);
  @override
  List<Object?> get props => [
        surveyId,
        surveyVersion,
        surveyJson,
        userId,
        country,
        courseId,
        isPending
      ];
}

class SurveyReset extends SurveyEvent {
  const SurveyReset();
  @override
  List<Object?> get props => [];
}
