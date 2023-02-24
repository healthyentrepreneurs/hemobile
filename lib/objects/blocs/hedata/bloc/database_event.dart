part of 'database_bloc.dart';

@immutable
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
  List<Object?> get props => [displayName,henetworkStatus];
}