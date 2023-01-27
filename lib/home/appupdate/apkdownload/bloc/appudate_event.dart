part of 'appudate_bloc.dart';

@immutable
abstract class AppUpdateEvent extends Equatable {
  const AppUpdateEvent();
}

class StartDownloading extends AppUpdateEvent {
  const StartDownloading();

  @override
  List<Object> get props => [];
}
