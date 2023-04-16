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
  final Section section;
  // final String section;
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
  // final String bookContextId;
  final BookQuiz bookquiz;
  final int bookIndex;
  const BookChapterSelected(
      this.courseId, this.section, this.bookquiz, this.bookIndex);
  @override
  List<Object?> get props => [courseId, section, bookquiz];
}

class BookChapterDeSelected extends SectionEvent {
  const BookChapterDeSelected();
  @override
  List<Object?> get props => [];
}

class SectionFetchedError extends SectionEvent {
  final HenetworkStatus? henetworkStatus;
  const SectionFetchedError(this.henetworkStatus);
  @override
  List<Object?> get props => [henetworkStatus];
}

//Adding BookView
class AddBookView extends SectionEvent {
  final String bookId;
  final String chapterId;
  final String courseId;
  final String userId;
  final bool isPending;
  const AddBookView(
      this.bookId, this.chapterId, this.courseId, this.userId, this.isPending);
  @override
  List<Object?> get props => [bookId, chapterId, courseId, userId, isPending];
}
