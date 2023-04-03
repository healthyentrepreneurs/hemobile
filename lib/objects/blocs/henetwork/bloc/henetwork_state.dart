part of 'henetwork_bloc.dart';

@immutable
class HenetworkState extends Equatable {
  const HenetworkState._({
    ConnectivityResult? connectivityResult,
    this.status = HenetworkStatus.loading,
  }) : _connectivityResult = connectivityResult;

  final ConnectivityResult? _connectivityResult;
  final HenetworkStatus status;
  ConnectivityResult get gconnectivityResult =>
      _connectivityResult ?? ConnectivityResult.none;

  HenetworkStatus get gstatus => status;

  const HenetworkState.loading(
      {ConnectivityResult? inconnectivityResult, HenetworkStatus? status})
      : this._(
            connectivityResult: inconnectivityResult,
            status: status ?? HenetworkStatus.loading);

  HenetworkState copyWith(
      {ConnectivityResult? connectivityResult, HenetworkStatus? status}) {
    return HenetworkState._(
        connectivityResult: connectivityResult ?? gconnectivityResult,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [status, gconnectivityResult];
}
