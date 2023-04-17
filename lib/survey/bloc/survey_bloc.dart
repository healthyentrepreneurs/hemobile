import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:rxdart/rxdart.dart';

import '../../helper/file_system_util.dart';
import '../../objects/blocs/repo/impl/repo_failure.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  DatabaseRepository repository;
  SurveyBloc({required this.repository})
      : _databaseRepository = repository,
        super(const SurveyState.loading()) {
    on<SurveyFetched>(_onSurveyFetched);
    on<SurveyReset>(_onSurveyReset);
    on<SurveySave>(_onSurveySave);
  }
  final DatabaseRepository _databaseRepository;
  // final _surveySaveSuccessSubject = BehaviorSubject<String?>.seeded(null);
  // ValueStream<String?> get surveySaveSuccessStream =>
  //     _surveySaveSuccessSubject.stream;
  final _surveySaveResultSubject =
      BehaviorSubject<Either<Failure, String>?>.seeded(null);
  ValueStream<Either<Failure, String>?> get surveySaveResultStream =>
      _surveySaveResultSubject.stream;

  _onSurveyFetched(SurveyFetched event, Emitter<SurveyState> emit) async {
    Stream<Either<Failure, String>> surveyStream =
        _databaseRepository.retrieveSurveyStream(event.courseid);
    debugPrint('SurveyBloc@_onSurveyFetched ${event.henetworkStatus}');
    await emit.forEach(surveyStream,
        onData: (Either<Failure, String> surveyjson) {
      return surveyjson.fold(
        (failure) => state.copyWith(error: failure),
        (surveyjson) => state.copyWith(
            surveyjson: surveyjson, henetworkStatus: event.henetworkStatus),
      );
    });
  }

  void _onSurveyReset(SurveyReset event, Emitter<SurveyState> emit) {
    if (event.resetSurveySaveSuccessStream) {
      _surveySaveResultSubject.add(null);
    }
    // emit(const SurveyState.loading());
    emit(const SurveyState.reset());
  }

  FutureOr<Either<Failure, int>> _onSurveySave(
      SurveySave event, Emitter<SurveyState> emit) async {
    final result = await _databaseRepository.saveSurveys(
      surveyId: event.surveyId,
      surveyVersion: event.surveyVersion,
      surveyJson: event.surveyJson,
      country: event.country,
      userId: event.userId,
      courseId: event.courseId,
      isPending: event.isPending,
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          saveError: failure,
        ));
        _surveySaveResultSubject.add(Left(failure));
        return Left(failure);
      },
      (successId) {
        emit(state.copyWith(
          surveySavedId: successId
              .toString(), // Set surveySavedId to the saved survey's ID
        ));
        _surveySaveResultSubject.add(Right(successId.toString()));
        return Right(successId);
      },
    );
  }

  @override
  Future<void> close() {
    _surveySaveResultSubject.close();
    return super.close();
  }
}
