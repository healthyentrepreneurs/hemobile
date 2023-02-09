part of 'henetwork_bloc.dart';

@immutable
abstract class HenetworkEvent {
  const HenetworkEvent();
}

class HeNetworkFirebaseNetworkChange extends HenetworkEvent {
  final HenetworkStatus networkStatus;
  const HeNetworkFirebaseNetworkChange({required this.networkStatus});
}

class HeNetworkNetworkStatus extends HenetworkEvent {
  const HeNetworkNetworkStatus();
}
