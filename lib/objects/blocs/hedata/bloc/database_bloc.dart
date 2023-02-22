import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/impl/idatabase_repo.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../helper/file_system_util.dart';

part 'database_event.dart';
part 'database_state.dart';

@injectable
class DatabaseBloc extends HydratedBloc<DatabaseEvent, DatabaseState> {
  IDatabaseRepository repository;
  DatabaseBloc({required this.repository})
      : _databaseRepository = repository,
        super(const DatabaseState.loading()) {
    on<DatabaseFetched>(_fetchUserData, transformer: restartable());
  }
  final IDatabaseRepository _databaseRepository;

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    await _databaseRepository.addHenetworkStatus(event.henetworkStatus!);
    // await Future<void>.delayed(const Duration(seconds: 1));
    Stream<Either<Failure, List<Subscription?>>> listOfSubStream =
        _databaseRepository.retrieveSubscriptionDataStream();
    debugPrint('DatabaseBloc@_fetchUserData ${event.henetworkStatus}');
    await emit.forEach(listOfSubStream,
        onData: (Either<Failure, List<Subscription?>> listOfSubscription) {
      return listOfSubscription.fold(
        (failure) => state.copyWith(error: failure),
        (listOfSubscription) => state.copyWith(
            listOfSubscriptionData: listOfSubscription,
            henetworkStatus: event.henetworkStatus,
            displayName: event.displayName),
      );
    });
  }

  @override
  DatabaseState? fromJson(Map<String, dynamic> json) {
    return DatabaseState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DatabaseState state) {
    return state.toJson();
  }
}
// return listOfSubscription.fold(
//   (failure) => DatabaseState.error(failure),
//   (listOfSubscription) => DatabaseState.successful(listOfSubscription,event.henetworkStatus!,event.displayName),
// );
