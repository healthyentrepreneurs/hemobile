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
    on<DatabaseLoadEvent>(_onDatabaseLoadEvent);
    on<DatabaseSubSelected>(_onDatabaseSubSelected);
    on<DatabaseSubDeSelected>(_onDatabaseSubDeSelected);
    on<DatabaseFetchedError>(_onDatabaseFetchedError);
    on<DbCountSurvey>(_onDbCountSurvey);
    on<UploadDataEvent>(_onUploadDataEvent);
    on<LoadStateEvent>(_onLoadStateEvent);
    on<SaveStateEvent>(_onSaveStateEvent);
  }
  final DatabaseRepository _databaseRepository;

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    _databaseRepository.addHenetworkStatus(event.henetworkStatus!);
    Stream<Either<Failure, List<Subscription?>>> listOfSubStream =
        _databaseRepository.retrieveSubscriptionDataStream(event.userid);
    await emit.forEach(listOfSubStream,
        onData: (Either<Failure, List<Subscription?>> listOfSubscription) {
      return listOfSubscription.fold(
        (failure) => state.copyWith(
            error: failure, henetworkStatus: event.henetworkStatus),
        (listOfSubscription) => state.copyWith(
            listOfSubscriptionData: listOfSubscription,
            henetworkStatus: event.henetworkStatus,
            userid: event.userid,
            error: null), // Reset the error to null when fetching is successful
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

  FutureOr<void> _onDatabaseLoadEvent(
      DatabaseLoadEvent event, Emitter<DatabaseState> emit) {
    emit(const DatabaseState.loading());
  }

  _onDatabaseFetchedError(
      DatabaseFetchedError event, Emitter<DatabaseState> emit) {
    if (event.clearData) {
      emit(state.copyWith(
          error: event.error,
          listOfSubscriptionData: emptySub,
          henetworkStatus: event.henetworkStatus));
    } else {
      emit(state.copyWith(
          error: event.error, henetworkStatus: event.henetworkStatus));
    }
  }

  FutureOr<void> _onDbCountSurvey(
      DbCountSurvey event, Emitter<DatabaseState> emit) async {
    final result = _databaseRepository.totalSavedSurvey();
    await emit.forEach(result, onData: (Either<Failure, int> countSurvey) {
      return countSurvey.fold(
        (failure) => state.copyWith(fetchError: failure),
        (countValue) => state.copyWith(
            surveyTotalCount:
                countValue), // Reset the error to null when fetching is successful
      );
    });
  }

  // Handle UploadDataEvent
  void _onUploadDataEvent(UploadDataEvent event, Emitter<DatabaseState> emit) {
    emit(state.copyWith(
        isUploadingData: event.isUploadingData,
        uploadProgress: event.uploadProgress));
    event.onUploadStateChanged(event.isUploadingData, event.uploadProgress);
  }

  // Handle LoadStateEvent
  void _onLoadStateEvent(
      LoadStateEvent event, Emitter<DatabaseState> emit) async {
    final result = await _databaseRepository.loadState();
    if (result != null) {
      event.onLoadStateChanged(result);
    }
  }

  // Handle SaveStateEvent
  void _onSaveStateEvent(SaveStateEvent event, Emitter<DatabaseState> emit) {
    emit(state.copyWith(
      isUploadingData: event.isUploadingData,
      uploadProgress: event.uploadProgress,
      backupAnimation: event.backupAnimation,
      surveyAnimation: event.surveyAnimation,
      booksAnimation: event.booksAnimation,
    ));
    _databaseRepository.saveState(
      isUploadingData: event.isUploadingData,
      uploadProgress: event.uploadProgress,
      backupAnimation: event.backupAnimation,
      surveyAnimation: event.surveyAnimation,
      booksAnimation: event.booksAnimation,
    );
  }
}
