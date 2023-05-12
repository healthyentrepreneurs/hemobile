part of 'statistics_bloc.dart';

@immutable
abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();
}

class FetchNetworkStatistics extends StatisticsEvent {
  final HenetworkStatus? henetworkStatus;
  const FetchNetworkStatistics(this.henetworkStatus);
  @override
  List<Object?> get props => [henetworkStatus];
}

class DbCountBookEvent extends StatisticsEvent {
  const DbCountBookEvent();
  @override
  List<Object?> get props => [];
}

class LoadStateEvent extends StatisticsEvent {
  // final Function(Map<String, dynamic>) onLoadStateChanged;

  const LoadStateEvent();

  @override
  List<Object?> get props => [];
}

class UploadData extends StatisticsEvent {
  final BackupStateDataModel backupStateData;
  const UploadData({required this.backupStateData});
  @override
  List<Object> get props => [backupStateData];
}

class ListSurveyTesting extends StatisticsEvent {
  final bool isPending;
  const ListSurveyTesting({required this.isPending});
  @override
  List<Object> get props => [isPending];
}

class ListBooksTesting extends StatisticsEvent {
  final bool isPending;
  const ListBooksTesting({required this.isPending});
  @override
  List<Object> get props => [isPending];
}
