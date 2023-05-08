import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:he_api/he_api.dart';

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
    Stream<Either<Failure, String>> surveyStream =
        _databaseRepository.retrieveSurveyStream(event.courseid);
    debugPrint('SurveyBloc@_onSurveyFetched ${event.henetworkStatus}');
    await emit.forEach(surveyStream,
        onData: (Either<Failure, String> surveyJsonValue) {
      return surveyJsonValue.fold(
        (failure) => state.copyWith(error: failure),
        (surveyJson) => state.copyWith(
            surveyjson: surveyJson, henetworkStatus: event.henetworkStatus),
      );
    });
  }

  void _onSurveyReset(SurveyReset event, Emitter<SurveyState> emit) {
    if (event.resetSurveySaveSuccess) {}
    // emit(const SurveyState.loading());
    emit(const SurveyState.reset());
  }

  Future<void> _onSurveySave(
      SurveySave event, Emitter<SurveyState> emit) async {
    SurveyDataModel survey = SurveyDataModel(
      userId: event.userId,
      surveyVersion: event.surveyVersion,
      surveyObject: event.surveyJson,
      surveyId: event.surveyId,
      isPending: event.isPending,
      courseId: event.courseId,
      country: event.country,
    );
    final result = await _databaseRepository.saveSurveys(surveyData: survey);

    result.fold(
      (failure) {
        emit(state.copyWith(
          saveError: failure,
        ));
      },
      (successId) {
        emit(state.copyWith(
          surveySavedId: successId.toString(),
        ));
      },
    );
  }
}
