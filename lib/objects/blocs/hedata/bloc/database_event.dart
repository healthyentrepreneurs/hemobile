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

class DbCountSurvey extends DatabaseEvent {
  const DbCountSurvey();
}

class UploadDataEvent extends DatabaseEvent {
  final bool isUploadingData;
  final double uploadProgress;
  final bool simulateUpload;
  final Function(bool, double) onUploadStateChanged;
  const UploadDataEvent({
    required this.isUploadingData,
    required this.uploadProgress,
    this.simulateUpload = true,
    required this.onUploadStateChanged,
  });

  @override
  List<Object?> get props =>
      [isUploadingData, uploadProgress, simulateUpload, onUploadStateChanged];
}

class LoadStateEvent extends DatabaseEvent {
  final Function(Map<String, dynamic>) onLoadStateChanged;

  const LoadStateEvent({required this.onLoadStateChanged});

  @override
  List<Object?> get props => [onLoadStateChanged];
}


class SaveStateEvent extends DatabaseEvent {
  final bool? isUploadingData;
  final double? uploadProgress;
  final bool? backupAnimation;
  final bool? surveyAnimation;
  final bool? booksAnimation;

  const SaveStateEvent({
     this.isUploadingData,
     this.uploadProgress,
     this.backupAnimation,
     this.surveyAnimation,
     this.booksAnimation,
  });

  @override
  List<Object?> get props => [
        isUploadingData,
        uploadProgress,
        backupAnimation,
        surveyAnimation,
        booksAnimation,
      ];
}
