import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';

import '../../../../helper/file_system_util.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository repository;
  DatabaseBloc({required this.repository})
      : _databaseRepository = repository,
        super(const DatabaseState.loading()) {
    on<DatabaseFetched>(_fetchUserData);
    on<DatabaseSubSelected>(_onDatabaseSubSelected);
    on<DatabaseSubDeSelected>(_onDatabaseSubDeSelected);
  }
  final DatabaseRepository _databaseRepository;

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    _databaseRepository.addHenetworkStatus(event.henetworkStatus!);
    Stream<Either<Failure, List<Subscription?>>> listOfSubStream =
        _databaseRepository.retrieveSubscriptionDataStream(event.userid);
    debugPrint('DatabaseBloc@_fetchUserData ${event.henetworkStatus}');
    await emit.forEach(listOfSubStream,
        onData: (Either<Failure, List<Subscription?>> listOfSubscription) {
      return listOfSubscription.fold(
        (failure) => state.copyWith(error: failure),
        (listOfSubscription) => state.copyWith(
            listOfSubscriptionData: listOfSubscription,
            henetworkStatus: event.henetworkStatus,
            userid: event.userid),
      );
    });
  }

  _onDatabaseSubSelected(
      DatabaseSubSelected event, Emitter<DatabaseState> emit) {
    emit(state.copyWith(selectedsubscription: event.selectsubscription));
  }

  _onDatabaseSubDeSelected(
      DatabaseSubDeSelected event, Emitter<DatabaseState> emit) {
    emit(state.copyWith(selectedsubscription: null));
  }
}
// return listOfSubscription.fold(
//   (failure) => DatabaseState.error(failure),
//   (listOfSubscription) => DatabaseState.successful(listOfSubscription,event.henetworkStatus!,event.displayName),
// );
