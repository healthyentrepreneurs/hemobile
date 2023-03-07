part of 'section_bloc.dart';

const emptySectionList = <Section>[];

class SectionState extends Equatable {
  const SectionState._(
      {List<Section?>? listofSections,
      HenetworkStatus? henetworkStatus,
      this.error})
      : _listofSections = listofSections ?? emptySectionList,
        _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;
  final List<Section?> _listofSections;
  final HenetworkStatus _henetworkStatus;
  final Failure? error;

  const SectionState.loading(
      {List<Section?>? listofSections, HenetworkStatus? henetworkStatus})
      : this._(
            listofSections: listofSections ?? emptySectionList,
            henetworkStatus: henetworkStatus);

  SectionState copyWith(
      {List<Section?>? listofSections,
      HenetworkStatus? henetworkStatus,
      Failure? error}) {
    return SectionState._(
        listofSections: listofSections ?? _listofSections,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        error: error ?? this.error);
  }

  List<Section?> get glistofSections => _listofSections;
  HenetworkStatus get ghenetworkStatus => _henetworkStatus;
  @override
  List<Object?> get props => [glistofSections, ghenetworkStatus, error];
}
