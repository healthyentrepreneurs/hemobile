part of 'apk_bloc.dart';

// abstract class ApkEvent {}
abstract class ApkEvent extends Equatable {
  const ApkEvent();
}

class FetchApkEvent extends ApkEvent {
  const FetchApkEvent(this.apkdoc);
  final Either<Failure, DocumentSnapshot> apkdoc;
  @override
  List<Object> get props => [apkdoc];
}

