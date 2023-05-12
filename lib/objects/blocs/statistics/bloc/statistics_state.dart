part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  const StatisticsState._({
    HenetworkStatus? henetworkStatus,
    this.fetchError,
    this.backupdataModel,
    this.listOfSurveyDataModel,
    this.listOfBookDataModel,
  }) : _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;

  final HenetworkStatus _henetworkStatus;
  final Failure? fetchError;
  final BackupStateDataModel? backupdataModel;
  final List<SurveyDataModel>? listOfSurveyDataModel;
  final List<BookDataModel>? listOfBookDataModel;

  const StatisticsState.loading({HenetworkStatus? henetworkStatus})
      : this._(henetworkStatus: henetworkStatus);

  StatisticsState copyWith(
      {List<SurveyDataModel>? listOfSurveyDataModel,
      List<BookDataModel>? listOfBookDataModel,
      HenetworkStatus? henetworkStatus,
      Failure? fetchError,
      final BackupStateDataModel? backupdataModel}) {
    return StatisticsState._(
        listOfSurveyDataModel:
            listOfSurveyDataModel ?? this.listOfSurveyDataModel,
        listOfBookDataModel: listOfBookDataModel ?? this.listOfBookDataModel,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        fetchError: fetchError ?? this.fetchError,
        backupdataModel: backupdataModel ?? this.backupdataModel);
  }

  @override
  List<Object?> get props =>
      [listOfSurveyDataModel, listOfBookDataModel, fetchError, backupdataModel];
}
