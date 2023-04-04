part of 'appudate_bloc.dart';

@immutable
abstract class AppUpdateEvent extends Equatable {
  const AppUpdateEvent();
}

class StartDownloading extends AppUpdateEvent {

  final String url;
  const StartDownloading(this.url);
  // const StartDownloading(String url);
  // final String userid;
  @override
  List<Object> get props => [url];
}
