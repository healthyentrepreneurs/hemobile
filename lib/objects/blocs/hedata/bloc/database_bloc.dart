import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/backupstate_datamodel.dart';
import 'package:he_api/he_api.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helper/file_system_util.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository repository;
  late final StreamSubscription<BackupStateDataModel> _backupStateSubscription;
  late final StreamSubscription<BackupStateDataModel> _subscription;
  DatabaseBloc({required this.repository})
      : _databaseRepository = repository,
        super(const DatabaseState.loading()) {
    on<DatabaseFetched>(_fetchUserData);
    on<DatabaseLoadEvent>(_onDatabaseLoadEvent);
    on<DatabaseSubSelected>(_onDatabaseSubSelected);
    on<DatabaseSubDeSelected>(_onDatabaseSubDeSelected);
    on<DatabaseFetchedError>(_onDatabaseFetchedError);
    on<DbCountSurveyEvent>(_onDbCountSurveyEvent);
    on<DbCountBookEvent>(_onDbCountBookEvent);
    on<LoadStateEvent>(_onLoadStateEvent);
    on<UploadData>(_onUploadDataEvent);
    _backupStateSubscription = repository
        .getBackupStateDataModelStream()
        .distinct(_distinctBackupStateDataModelComparison)
        .listen((event) {
      debugPrint("EVANSN ${event.toString()}");
      add(UploadData(backupStateData: event));
    });
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

  FutureOr<void> _onDbCountSurveyEvent(
      DbCountSurveyEvent event, Emitter<DatabaseState> emit) async {
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

  FutureOr<void> _onDbCountBookEvent(
      DbCountBookEvent event, Emitter<DatabaseState> emit) async {
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

  _onUploadDataEvent(UploadData event, Emitter<DatabaseState> emit) async {
    debugPrint("NAKIGANDA EMITTING ${event.backupStateData.toJson()} ");
    emit(state.copyWith(
      uploadProgress: event.backupStateData.uploadProgress,
      isUploadingData: event.backupStateData.isUploadingData,
      backupAnimation: event.backupStateData.backupAnimation,
      surveyAnimation: event.backupStateData.surveyAnimation,
      booksAnimation: event.backupStateData.booksAnimation,
    ));
  }

  // Handle LoadStateEvent
  void _onLoadStateEvent(
      LoadStateEvent event, Emitter<DatabaseState> emit) async {
    final result = await _databaseRepository.loadState();
    if (result != null) {
      debugPrint("_onLoadStateEvent@uploadData $result ");
      // {id: 1, uploadProgress: 0.0, isUploadingData: false, backupAnimation: false, surveyAnimation: false, booksAnimation: false}
      emit(state.copyWith(
        uploadProgress: result['uploadProgress'],
        isUploadingData: result['isUploadingData'],
        backupAnimation: result['backupAnimation'],
        surveyAnimation: result['surveyAnimation'],
        booksAnimation: result['booksAnimation'],
      ));
    } else {
      debugPrint("_onLoadStateEvent@uploadData $result PEPE");
    }
  }

  @override
  Future<void> close() {
    _backupStateSubscription.cancel();
    _subscription.cancel();
    return super.close();
  }

  EventTransformer<UploadData> debounceRestartable<UploadData>(
    Duration duration,
  ) {
    // This feeds the debounced event stream to restartable() and returns that
    // as a transformer.
    return (events, mapper) =>
        restartable<UploadData>().call(events.debounceTime(duration), mapper);
  }

  bool _distinctBackupStateDataModelComparison(
      BackupStateDataModel prev, BackupStateDataModel curr) {
    return prev.id == curr.id &&
        prev.uploadProgress == curr.uploadProgress &&
        prev.isUploadingData == curr.isUploadingData &&
        prev.backupAnimation == curr.backupAnimation &&
        prev.surveyAnimation == curr.surveyAnimation &&
        prev.booksAnimation == curr.booksAnimation &&
        prev.dateCreated == curr.dateCreated;
  }
}
