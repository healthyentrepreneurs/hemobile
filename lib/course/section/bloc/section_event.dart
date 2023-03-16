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

class BookQuizSelected extends SectionEvent {
  final String courseId;
  final String section;
  const BookQuizSelected(this.courseId, this.section);
  @override
  List<Object?> get props => [courseId, section];
}

class BookChapterSelected extends SectionEvent {
  final String courseId;
  final String section;
  final String bookContextId;
  final int bookIndex;
  const BookChapterSelected(
      this.courseId, this.section, this.bookContextId, this.bookIndex);
  @override
  List<Object?> get props => [courseId, section, bookContextId];
}

class SectionFetchedError extends SectionEvent {
  final HenetworkStatus? henetworkStatus;
  final List<Section?>? listofSections;
  final Failure? error;
  const SectionFetchedError(
      this.henetworkStatus, this.listofSections, this.error);
  @override
  List<Object?> get props => [henetworkStatus, listofSections, error];
}
