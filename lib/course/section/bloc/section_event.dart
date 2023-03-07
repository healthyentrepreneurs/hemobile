part of 'section_bloc.dart';

@immutable
abstract class SectionEvent extends Equatable {
  const SectionEvent();
}

class SectionFetched extends SectionEvent {
  final String courseid;
  final HenetworkStatus? henetworkStatus;
  const SectionFetched(this.courseid, this.henetworkStatus);
  @override
  List<Object?> get props => [courseid, henetworkStatus];
}
