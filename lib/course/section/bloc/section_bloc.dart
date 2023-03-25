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
    on<SectionDeFetched>(_onSectionDeFetched);
    on<BookQuizSelected>(_onBookQuizSelected);
    on<BookQuizDeselected>(_onBookQuizDeselected);
    on<BookChapterSelected>(_onBookChapterSelected);
    // ,transformer: droppable()
    on<SectionFetchedError>(_onSectionFetchedError);
    // ErrorCounted
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

  FutureOr<void> _onSectionDeFetched(
      SectionDeFetched event, Emitter<SectionState> emit) {
    emit(state.copyWith(listofSections: <Section>[]));
  }

  _onBookQuizSelected(
      BookQuizSelected event, Emitter<SectionState> emit) async {
    Stream<Either<Failure, List<BookQuiz?>>> listBookQuizStream =
        _databaseRepository.retrieveBookQuiz(event.courseId, event.section);
    await emit.forEach(listBookQuizStream,
        onData: (Either<Failure, List<BookQuiz?>> listBookQuiz) {
      return listBookQuiz.fold(
        (failure) => state.copyWith(error: failure),
        (listBookQuiz) => state.copyWith(listBookQuiz: listBookQuiz),
      );
    });
    // listBookQuiz
  }

  FutureOr<void> _onBookQuizDeselected(
      BookQuizDeselected event, Emitter<SectionState> emit) {
    emit(state.copyWith(listBookQuiz: <BookQuiz>[]));
  }

  _onBookChapterSelected(
      BookChapterSelected event, Emitter<SectionState> emit) async {
    Stream<Either<Failure, List<BookContent>>> listBookChapterStream =
        _databaseRepository.retrieveBookChapter(event.courseId, event.section,
            event.bookContextId, event.bookIndex);
    await emit.forEach(listBookChapterStream,
        onData: (Either<Failure, List<BookContent>> listBookChapter) {
      return listBookChapter.fold(
        (failure) => state.copyWith(error: failure),
        (listBookChapters) =>
            state.copyWith(listBookChapters: listBookChapters),
      );
    });
    // listBookQuiz
  }

  _onSectionFetchedError(
      SectionFetchedError event, Emitter<SectionState> emit) {
    //add wait of 2 seconds
    // await Future.delayed(const Duration(seconds: 2));
    emit(SectionState.withError(
        listofSections: event.listofSections,
        henetworkStatus: event.henetworkStatus,
        error: event.error));
  }
}
