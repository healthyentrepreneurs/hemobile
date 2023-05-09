part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();
  @override
  List<Object?> get props => [];
}

class DatabaseLoadEvent extends DatabaseEvent {
  @override
  List<Object?> get props => [];
}

class DatabaseFetched extends DatabaseEvent {
  final String userid;
  final HenetworkStatus? henetworkStatus;
  const DatabaseFetched(this.userid, this.henetworkStatus);
  @override
  List<Object?> get props => [userid, henetworkStatus];
}

class DatabaseSubSelected extends DatabaseEvent {
  final Subscription selectsubscription;
  const DatabaseSubSelected(this.selectsubscription);
  @override
  List<Object?> get props => [selectsubscription];
}

class DatabaseSubDeSelected extends DatabaseEvent {
  const DatabaseSubDeSelected();
}

class DatabaseFetchedError extends DatabaseEvent {
  final HenetworkStatus? henetworkStatus;
  final Failure? error;
  final bool clearData;
  const DatabaseFetchedError(this.henetworkStatus, this.error,
      {this.clearData = false});
  @override
  List<Object?> get props => [henetworkStatus, error, clearData];
}

// class DbCountSurveyEvent extends DatabaseEvent {
//   const DbCountSurveyEvent();
// }

class DbCountBookEvent extends DatabaseEvent {
  const DbCountBookEvent();
}

class LoadStateEvent extends DatabaseEvent {
  // final Function(Map<String, dynamic>) onLoadStateChanged;

  const LoadStateEvent();

  @override
  List<Object?> get props => [];
}

class UploadData extends DatabaseEvent {
  final BackupStateDataModel backupStateData;
  const UploadData({required this.backupStateData});
  @override
  List<Object> get props => [backupStateData];
}

// class UploadData extends DatabaseEvent {
//   const UploadData();
//   @override
//   List<Object> get props => [];
// }

class ListSurveyTesting extends DatabaseEvent {
  final bool isPending;
  const ListSurveyTesting({required this.isPending});
  @override
  List<Object> get props => [isPending];
}

class ListBooksTesting extends DatabaseEvent {
  final bool isPending;
  const ListBooksTesting({required this.isPending});
  @override
  List<Object> get props => [isPending];
}
