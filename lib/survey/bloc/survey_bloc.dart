import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';

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

  _onSurveyFetched(SurveyFetched event, Emitter<SurveyState> emit) async {
    // _databaseRepository.addHenetworkStatus(event.henetworkStatus!);
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
    emit(const SurveyState.loading());
  }

  FutureOr<int> _onSurveySave(
      SurveySave event, Emitter<SurveyState> emit) async {
    emit(state.copyWith(henetworkStatus: HenetworkStatus.loading));

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
          error: failure,
        ));
        return 0;
      },
      (successId) {
        emit(state.copyWith(
          surveySavedId:
              event.surveyId, // Set surveySavedId to the saved survey's ID
        ));
        return successId;
      },
    );
  }
}
