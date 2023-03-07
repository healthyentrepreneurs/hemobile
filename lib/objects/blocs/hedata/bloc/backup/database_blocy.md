import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import '../../../../../helper/file_system_util.dart';
import '../../../repo/database_repo.dart';

part 'database_eventy.dart';
part 'database_statey.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository repository;
  DatabaseBloc({required this.repository}) : super(const DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
    on<DatabaseFetchedTwo>(_onDatabaseFetchedTwo);
  }
  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    repository.addHenetworkStatus(event.henetworkStatus!);
    Stream<Either<Failure, List<Subscription?>>> listOfSubStream =
        repository.retrieveSubscriptionDataStream();
    debugPrint('DatabaseBloc@_fetchUserData ${event.henetworkStatus}');
    await emit.forEach(listOfSubStream,
        onData: (Either<Failure, List<Subscription?>> listOfSubscription) {
      return listOfSubscription.fold(
        (failure) => DatabaseError(failure, state.henetworkStatus),
        (listOfSubscription) => DatabaseSuccess(
            listOfSubscription, event.henetworkStatus!, event.displayName),
      );
    });
  }

  _onDatabaseFetchedTwo(
      DatabaseFetchedTwo event, Emitter<DatabaseState> emit) async {
    Stream<Either<Failure, List<Section?>>> listOfSectionStream =
        repository.retrieveBookSectionData(event.courseId);
    debugPrint('DatabaseBloc@_onDatabaseFetchedTwo ${event.henetworkStatus}');
    await emit.forEach(listOfSectionStream,
        onData: (Either<Failure, List<Section?>> listOfSection) {
      return listOfSection.fold(
        (failure) => DatabaseError(failure, state.henetworkStatus),
        (listOfSectionData) =>
            DatabaseSuccessTwo(listOfSectionData, event.henetworkStatus),
      );
    });
  }
}
