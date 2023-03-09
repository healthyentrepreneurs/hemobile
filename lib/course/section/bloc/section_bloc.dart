import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/objects.dart';
import 'package:he_api/he_api.dart';

import '../../../objects/objectbookcontent.dart';
import '../../../objects/objectbookquiz.dart';

part 'section_event.dart';
part 'section_state.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  DatabaseRepository repository;
  SectionBloc({required this.repository})
      : _databaseRepository = repository,
        super(const SectionState.loading()) {
    on<SectionFetched>(_onSectionFetched);
    on<BookQuizSelected>(_onBookQuizSelected);
    on<BookChapterSelected>(_onBookChapterSelected);
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

  _onBookQuizSelected(
      BookQuizSelected event, Emitter<SectionState> emit) async {
    Stream<Either<Failure, List<ObjectBookQuiz?>>> listBookQuizStream =
        _databaseRepository.retrieveBookQuiz(event.courseId, event.section);
    await emit.forEach(listBookQuizStream,
        onData: (Either<Failure, List<ObjectBookQuiz?>> listBookQuiz) {
      return listBookQuiz.fold(
        (failure) => state.copyWith(error: failure),
        (listBookQuiz) => state.copyWith(listBookQuiz: listBookQuiz),
      );
    });
    // listBookQuiz
  }

  _onBookChapterSelected(
      BookChapterSelected event, Emitter<SectionState> emit) async {
    Stream<Either<Failure, List<ObjectBookContent?>>> listBookChapterStream =
        _databaseRepository.retrieveBookChapter(
            event.courseId, event.section, event.bookContextId);
    await emit.forEach(listBookChapterStream,
        onData: (Either<Failure, List<ObjectBookContent?>> listBookChapter) {
      return listBookChapter.fold(
        (failure) => state.copyWith(error: failure),
        (listBookChapters) =>
            state.copyWith(listBookChapters: listBookChapters),
      );
    });
    // listBookQuiz
  }
}
