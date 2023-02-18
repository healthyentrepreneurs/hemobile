import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';
import '../../../../helper/file_system_util.dart';
import '../../repo/database_repo.dart';
import '../../repo/impl/idatabase_repo.dart';

part 'database_event.dart';
part 'database_state.dart';

@injectable
class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository repository;
  DatabaseBloc(
      {required this.repository})
      : _databaseRepository = repository,
        super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
  }
  final DatabaseRepository _databaseRepository;
  late Stream<Either<Failure, List<Subscription?>>> listOfSubStream;
  // Sample-Future-Example
  _fetchUserDataFuture(
      DatabaseFetched event, Emitter<DatabaseState> emit) async {
    var listOfSubscription =
        await _databaseRepository.retrieveSubscriptionData();
    emit(listOfSubscription.fold(
      (failure) => DatabaseError(failure, event.henetworkStatus),
      (listOfSubscription) => DatabaseSuccess(
          listOfSubscription, event.displayName, event.henetworkStatus),
    ));
  }

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    Stream<Either<Failure, List<Subscription?>>> listOfSubStream =
        _databaseRepository.retrieveSubscriptionDataStream();
    debugPrint('DatabaseBloc@_fetchUserData ${event.henetworkStatus}');
    await emit.forEach(listOfSubStream,
        onData: (Either<Failure, List<Subscription?>> listOfSubscription) {
      return listOfSubscription.fold(
        (failure) => DatabaseError(failure, event.henetworkStatus),
        (listOfSubscription) => DatabaseSuccess(
            listOfSubscription, event.displayName, event.henetworkStatus),
      );
    });
  }
}
