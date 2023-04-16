part of 'section_bloc.dart';

const emptySectionList = <Section>[];
const emptybookQuizList = <BookQuiz>[];
const emptybookChapterList = <BookContent>[];

class SectionState extends Equatable {
  const SectionState._(
      {List<Section?>? listofSections,
      HenetworkStatus? henetworkStatus,
      List<BookQuiz?>? listBookQuiz,
      List<BookContent>? listBookChapters,
      this.section,
      this.bookquiz,
      this.error,
      this.bookSavedId})
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
  final BookQuiz? bookquiz;
  final int? bookSavedId;

  const SectionState.loading(
      {List<Section?>? listofSections, HenetworkStatus? henetworkStatus})
      : this._(
            listofSections: listofSections ?? emptySectionList,
            henetworkStatus: henetworkStatus);

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
      BookQuiz? bookquiz,
      Failure? error,
      int? bookSavedId}) {
    return SectionState._(
        listofSections: listofSections ?? _listofSections,
        listBookQuiz: listBookQuiz ?? _listBookQuiz,
        listBookChapters: listBookChapters ?? _listBookChapters,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        section: section ?? this.section,
        bookquiz: bookquiz ?? this.bookquiz,
        error: error ?? this.error,
        bookSavedId: bookSavedId ?? this.bookSavedId);
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
        section,
        bookquiz,
        error,
        bookSavedId
      ];
}
