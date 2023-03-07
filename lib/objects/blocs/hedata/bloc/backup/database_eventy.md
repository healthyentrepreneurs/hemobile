part of 'database_blocy.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class DatabaseFetched extends DatabaseEvent {
  final String? displayName;
  final HenetworkStatus? henetworkStatus;
  const DatabaseFetched(this.displayName, this.henetworkStatus);
  @override
  List<Object?> get props => [displayName, henetworkStatus];
}

class DatabaseFetchedTwo extends DatabaseEvent {
  final HenetworkStatus? henetworkStatus;
  final String courseId;
  const DatabaseFetchedTwo(this.henetworkStatus, this.courseId);
  @override
  List<Object?> get props => [henetworkStatus, courseId];
}
