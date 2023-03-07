part of 'database_blocy.dart';

const emptySub = <Subscription>[];

abstract class DatabaseState extends Equatable {
  const DatabaseState(this.henetworkStatus);
  final HenetworkStatus? henetworkStatus;
  @override
  List<Object?> get props => [henetworkStatus];
}

class DatabaseInitial extends DatabaseState {
  // create a constructor that takes in the optional henetworkStatus
  const DatabaseInitial([HenetworkStatus? henetworkStatus])
      : super(henetworkStatus);
  @override
  List<Object?> get props => [henetworkStatus];
}

class DatabaseSuccess extends DatabaseState {
  final List<Subscription?> listOfSubscriptionData;
  final String? displayName;
  final HenetworkStatus? henetworkStatus;
  const DatabaseSuccess(
      this.listOfSubscriptionData, this.henetworkStatus, this.displayName)
      : super(henetworkStatus);

  @override
  List<Object?> get props =>
      [listOfSubscriptionData, displayName, henetworkStatus];
}

// Create DatabaseSuccessTwo which extends DatabaseSuccess
class DatabaseSuccessTwo extends DatabaseState {
  final List<Section?> listOfSectionData;
  final HenetworkStatus? henetworkStatus;
  const DatabaseSuccessTwo(this.listOfSectionData, this.henetworkStatus)
      : super(henetworkStatus);

  @override
  List<Object?> get props => [listOfSectionData, henetworkStatus];
}

class DatabaseError extends DatabaseState {
  final Failure? error;
  final HenetworkStatus? henetworkStatus;
  const DatabaseError(this.error, this.henetworkStatus)
      : super(henetworkStatus);

  @override
  List<Object?> get props => [];
}
