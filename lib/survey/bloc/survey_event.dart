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
  final String userEmail;
  final String country;
  // final HenetworkStatus? henetworkStatus;
  const SurveySave(this.surveyId, this.surveyVersion, this.surveyJson,
      this.userId, this.userEmail, this.country);
  @override
  List<Object?> get props => [
        surveyId,
        surveyVersion,
        surveyJson,
        userId,
        userEmail,
        country,
      ];
}

class SurveyReset extends SurveyEvent {
  const SurveyReset();
  @override
  List<Object?> get props => [];
}
