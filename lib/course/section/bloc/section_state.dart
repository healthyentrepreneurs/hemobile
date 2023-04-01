part of 'section_bloc.dart';

const emptySectionList = <Section>[];
const emptybookQuizList = <BookQuiz>[];
const emptybookChapterList = <BookContent>[];

// @immutable
class SectionState extends Equatable {
  const SectionState._(
      {List<Section?>? listofSections,
      HenetworkStatus? henetworkStatus,
      List<BookQuiz?>? listBookQuiz,
      List<BookContent>? listBookChapters,
      this.section,
      this.error})
      : _listofSections = listofSections ?? emptySectionList,
        _listBookQuiz = listBookQuiz ?? emptybookQuizList,
        _listBookChapters = listBookChapters ?? emptybookChapterList,
        _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;

  final List<Section?> _listofSections;
  final HenetworkStatus _henetworkStatus;
  final List<BookQuiz?> _listBookQuiz;
  final List<BookContent> _listBookChapters;
  final Failure? error;
  final Section? section;

  const SectionState.loading(
      {List<Section?>? listofSections, HenetworkStatus? henetworkStatus})
      : this._(
            listofSections: listofSections ?? emptySectionList,
            henetworkStatus: henetworkStatus);
  // create initial state constructor
  const SectionState.withError({HenetworkStatus? henetworkStatus})
      : this._(
          listofSections: emptySectionList,
          henetworkStatus: henetworkStatus,
          listBookQuiz: emptybookQuizList,
          listBookChapters: emptybookChapterList,
          error: null,
        );

  SectionState copyWith(
      {List<Section?>? listofSections,
      HenetworkStatus? henetworkStatus,
      List<BookQuiz?>? listBookQuiz,
      List<BookContent>? listBookChapters,
      Section? section,
      Failure? error}) {
    return SectionState._(
        listofSections: listofSections ?? _listofSections,
        listBookQuiz: listBookQuiz ?? _listBookQuiz,
        listBookChapters: listBookChapters ?? _listBookChapters,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        section: section ?? this.section,
        error: error ?? this.error);
  }

  List<Section?> get glistofSections => _listofSections;

  List<BookQuiz?> get glistBookQuiz => _listBookQuiz;

  List<BookContent> get glistBookChapters => _listBookChapters;

  HenetworkStatus get ghenetworkStatus => _henetworkStatus;

  @override
  List<Object?> get props => [
        glistofSections,
        ghenetworkStatus,
        glistBookQuiz,
        glistBookChapters,
        error
      ];
}
