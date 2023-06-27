import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:he_api/he_api.dart';
import 'package:rxdart/rxdart.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  DatabaseRepository repository;
  late final StreamSubscription<BackupStateDataModel> _backupStateSubscription;

  StatisticsBloc({required this.repository})
      : _databaseRepository = repository,
        super(const StatisticsState.loading()) {
    on<LoadStateEvent>(_onLoadStateEvent);
    on<UploadData>(_onUploadDataEvent);
    on<ListSurveyTesting>(_onListSurveyTesting);
    on<ListBooksTesting>(_onListBooksTesting);
    on<FetchNetworkStatistics>(_onFetchNetworkStatistics);
    _backupStateSubscription = repository
        .getBackupStateDataModelStream()
        .distinct(_distinctBackupStateDataModelComparison)
        // .debounceTime(const Duration(milliseconds: 5))
        .listen((event) {
      debugPrint("EVANSN ${event.toString()}");
      add(UploadData(backupStateData: event));
    });
  }

  final DatabaseRepository _databaseRepository;

  FutureOr<void> _onListSurveyTesting(
      ListSurveyTesting event, Emitter<StatisticsState> emit) async {
    final result = _databaseRepository.getSurveysByPendingStatus(
        isPending: event.isPending);
    await emit.forEach(result,
        onData: (List<SurveyDataModel> listSurveyDataModel) {
      return state.copyWith(listOfSurveyDataModel: listSurveyDataModel);
    });
  }

  FutureOr<void> _onListBooksTesting(
      ListBooksTesting event, Emitter<StatisticsState> emit) async {
    final result = _databaseRepository.getBookChaptersByPendingStatus(
        isPending: event.isPending);
    await emit.forEach(result, onData: (List<BookDataModel> listBookDataModel) {
      return state.copyWith(listOfBookDataModel: listBookDataModel);
    });
  }

  // void _onLoadStateEvent(
  //     LoadStateEvent event, Emitter<StatisticsState> emit) async {
  //   final result = await _databaseRepository.loadState();
  //   debugPrint("_onLoadStateEvent@uploadData $result ");
  //   // {id: 1, uploadProgress: 0.0, isUploadingData: false, backupAnimation: false, surveyAnimation: false, booksAnimation: false}
  //   emit(state.copyWith(
  //       backupdataModel: BackupStateDataModel.fromJson(result!)));
  // }

  void _onLoadStateEvent(
      LoadStateEvent event, Emitter<StatisticsState> emit) async {
    final result = await _databaseRepository.loadState();
    debugPrint("_onLoadStateEvent@uploadData $result ");

    // Check if result is not null before emitting state
    if (result != null) {
      emit(state.copyWith(
          backupdataModel: BackupStateDataModel.fromJson(result)));
    }
  }

  _onUploadDataEvent(UploadData event, Emitter<StatisticsState> emit) async {
    debugPrint("NAKIGANDA EMITTING ${event.backupStateData.toJson()} ");
    emit(state.copyWith(
      backupdataModel: event.backupStateData,
    ));
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

  EventTransformer<UploadData> debounceRestartable<UploadData>(
    Duration duration,
  ) {
    // This feeds the debounced event stream to restartable() and returns that
    // as a transformer.
    return (events, mapper) =>
        restartable<UploadData>().call(events.debounceTime(duration), mapper);
  }

  @override
  Future<void> close() {
    _backupStateSubscription.cancel();
    repository.dispose();
    return super.close();
  }

  _onFetchNetworkStatistics(
      FetchNetworkStatistics event, Emitter<StatisticsState> emit) {
    emit(state.copyWith(
      henetworkStatus: event.henetworkStatus,
    ));
    // _databaseRepository.addHenetworkStatus(event.henetworkStatus!);
  }
}
