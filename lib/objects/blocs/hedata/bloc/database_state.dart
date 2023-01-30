part of 'database_bloc.dart';

@immutable
abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseSuccess extends DatabaseState {
  final List<Subscription?> listOfSubscriptionData;
  final String? displayName;
  const DatabaseSuccess(this.listOfSubscriptionData, this.displayName);

  @override
  List<Object?> get props => [listOfSubscriptionData, displayName];
}

class DatabaseError extends DatabaseState {
  final Failure error;
  const DatabaseError(this.error);
  @override
  List<Object?> get props => [error];
}
