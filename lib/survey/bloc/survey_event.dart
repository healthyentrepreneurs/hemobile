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

class SurveyReset extends SurveyEvent {
  const SurveyReset();
  @override
  List<Object?> get props => [];
}
