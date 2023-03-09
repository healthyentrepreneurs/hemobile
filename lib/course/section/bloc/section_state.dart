part of 'section_bloc.dart';

const emptySectionList = <Section>[];
const emptybookQuizList = <ObjectBookQuiz>[];
const emptybookChapterList = <ObjectBookContent>[];

class SectionState extends Equatable {
  const SectionState._(
      {List<Section?>? listofSections,
      HenetworkStatus? henetworkStatus,
      List<ObjectBookQuiz?>? listBookQuiz,
      List<ObjectBookContent?>? listBookChapters,
      this.error})
      : _listofSections = listofSections ?? emptySectionList,
        _listBookQuiz = listBookQuiz ?? emptybookQuizList,
        _listBookChapters = listBookChapters ?? emptybookChapterList,
        _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;

  final List<Section?> _listofSections;
  final HenetworkStatus _henetworkStatus;
  final List<ObjectBookQuiz?> _listBookQuiz;
  final List<ObjectBookContent?> _listBookChapters;
  final Failure? error;

  const SectionState.loading(
      {List<Section?>? listofSections, HenetworkStatus? henetworkStatus})
      : this._(
            listofSections: listofSections ?? emptySectionList,
            henetworkStatus: henetworkStatus);

  SectionState copyWith(
      {List<Section?>? listofSections,
      HenetworkStatus? henetworkStatus,
      List<ObjectBookQuiz?>? listBookQuiz,
      List<ObjectBookContent?>? listBookChapters,
      Failure? error}) {
    return SectionState._(
        listofSections: listofSections ?? _listofSections,
        listBookQuiz: listBookQuiz ?? _listBookQuiz,
        listBookChapters: listBookChapters ?? _listBookChapters,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        error: error ?? this.error);
  }

  List<ObjectBookQuiz?> get glistBookQuiz => _listBookQuiz;
  List<ObjectBookContent?> get glistBookChapters => _listBookChapters;
  List<Section?> get glistofSections => _listofSections;
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
