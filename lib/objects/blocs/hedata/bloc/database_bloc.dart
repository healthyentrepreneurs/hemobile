import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../repo/impl/idatabase_repo.dart';

part 'database_event.dart';
part 'database_state.dart';

@injectable
class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  IDatabaseRepository repository;
  DatabaseBloc({required this.repository})
      : _databaseRepository = repository,
        super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
  }
  final IDatabaseRepository _databaseRepository;

  // Sample-Future-Example
  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    var listOfSubscription =
        await _databaseRepository.retrieveSubscriptionData();
    emit(listOfSubscription.fold(
      (failure) => DatabaseError(failure),
      (listOfSubscription) =>
          DatabaseSuccess(listOfSubscription, event.displayName),
    ));
  }

  _fetchUserDataStream(
      DatabaseFetched event, Emitter<DatabaseState> emit) async {
    await emit.forEach(_databaseRepository.retrieveSubscriptionDataStream(),
        onData: (Either<Failure, List<Subscription?>> listOfSubscription) {
      // Stream<Either<Failure, List<Subscription?>>> listOfSubscription =
      //     _databaseRepository.retrieveSubscriptionDataStream();
      return listOfSubscription.fold(
        (failure) => DatabaseError(failure),
        (listOfSubscription) =>
            DatabaseSuccess(listOfSubscription, event.displayName),
      );
    });
  }
}
