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

class SectionDeFetched extends SectionEvent {
  const SectionDeFetched();
  @override
  List<Object?> get props => [];
}

class BookQuizSelected extends SectionEvent {
  final String courseId;
  final String section;
  const BookQuizSelected(this.courseId, this.section);
  @override
  List<Object?> get props => [courseId, section];
}

class BookQuizDeselected extends SectionEvent {
  const BookQuizDeselected();
  @override
  List<Object?> get props => [];
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
  // final List<Section?>? listofSections;
  // final Failure? error;
  const SectionFetchedError(this.henetworkStatus);
  @override
  List<Object?> get props => [henetworkStatus];
}
