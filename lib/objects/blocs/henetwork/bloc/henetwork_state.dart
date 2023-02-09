part of 'henetwork_bloc.dart';

// enum HenetworkStatus {
//   loading,
//   firebaseNetworkDisabled,
//   firebaseNetworkEnabled,
//   noInternet,
//   wifiNetwork,
//   mobileNetwork,
//   vpnNetwork,
//   ethernetNetwork,
//   wimaxNetwork,
//   bluetoothNetwork,
// }
// https://firebase.flutter.dev/docs/firestore/usage/#access-data-offline
// https://pub.dev/packages/connectivity_plus/example
class HenetworkState extends Equatable {
  // const HenetworkState(
  //     {ConnectivityResult? connectivityResult, bool? firebaseEnableNetwork})
  //     : _connectivityResult = connectivityResult ?? ConnectivityResult.none,
  //       _firebaseEnableNetwork = firebaseEnableNetwork ?? false;

  const HenetworkState._({
    ConnectivityResult? connectivityResult,
    this.status = HenetworkStatus.loading,
  }) : _connectivityResult = connectivityResult;

  final ConnectivityResult? _connectivityResult;
  final HenetworkStatus status;
  ConnectivityResult get gconnectivityResult =>
      _connectivityResult ?? ConnectivityResult.none;

  const HenetworkState.loading({ConnectivityResult? inconnectivityResult})
      : this._(connectivityResult: inconnectivityResult);

  HenetworkState copyWith(
      {ConnectivityResult? connectivityResult, HenetworkStatus? status}) {
    return HenetworkState._(
        connectivityResult: connectivityResult ?? gconnectivityResult,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [status, gconnectivityResult];
}
