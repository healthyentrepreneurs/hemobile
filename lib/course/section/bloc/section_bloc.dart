import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/objects.dart';
import 'package:he_api/he_api.dart';

part 'section_event.dart';
part 'section_state.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  DatabaseRepository repository;
  SectionBloc({required this.repository})
      : _databaseRepository = repository,
        super(const SectionState.loading()) {
    on<SectionFetched>(_onSectionFetched);
  }
  final DatabaseRepository _databaseRepository;

  _onSectionFetched(SectionFetched event, Emitter<SectionState> emit) async {
    // _databaseRepository.addHenetworkStatus(event.henetworkStatus!);
    Stream<Either<Failure, List<Section?>>> listOfSectionStream =
        _databaseRepository.retrieveBookSectionData(event.courseid);
    debugPrint('SectionBloc@_onSectionFetched ${event.henetworkStatus}');
    await emit.forEach(listOfSectionStream,
        onData: (Either<Failure, List<Section?>> listOfSection) {
      return listOfSection.fold(
        (failure) => state.copyWith(error: failure),
        (listOfSection) => state.copyWith(
            listofSections: listOfSection,
            henetworkStatus: event.henetworkStatus),
      );
    });
  }
}
