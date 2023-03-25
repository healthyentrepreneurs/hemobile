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
