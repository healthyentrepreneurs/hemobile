import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he_api/he_api.dart';
part 'henetwork_event.dart';
part 'henetwork_state.dart';

class HenetworkBloc extends Bloc<HenetworkEvent, HenetworkState> {
  HenetworkBloc() : super(const HenetworkState.loading()) {
    on<HeNetworkNetworkStatus>(_onHeNetworkNetworkStatus);
    on<HeNetworkFirebaseNetworkChange>(_onHeHeNetworkFirebaseAction);
  }

  final Connectivity _connectivity = Connectivity();

  FutureOr<void> _onHeNetworkNetworkStatus(
      HeNetworkNetworkStatus event, Emitter<HenetworkState> emit) async {
    // Get the current connectivity result
    ConnectivityResult currentConnectivityResult =
        await _connectivity.checkConnectivity();
    // Emit the current connectivity state
    emit(_emitConnectivityState(currentConnectivityResult));
    await emit.forEach(_connectivity.onConnectivityChanged,
        onData: (ConnectivityResult connectivityResult) {
      switch (connectivityResult.name) {
        case 'none':
          debugPrint('LexFrid Is none ${connectivityResult.name}');
          return state.copyWith(
              connectivityResult: connectivityResult,
              status: HenetworkStatus.noInternet);
        case 'mobile':
          debugPrint('LexFrid Is mobile ${connectivityResult.name}');
          return state.copyWith(
              connectivityResult: connectivityResult,
              status: HenetworkStatus.mobileNetwork);
        case 'wifi':
          debugPrint('LexFrid Is wifi ${connectivityResult.name}');
          return state.copyWith(
              connectivityResult: connectivityResult,
              status: HenetworkStatus.wifiNetwork);
        default:
          debugPrint('LexFrid Is default ${connectivityResult.name}');
          return state.copyWith(
              connectivityResult: connectivityResult,
              status: HenetworkStatus.loading);
      }
    });
  }

  HenetworkState _emitConnectivityState(ConnectivityResult connectivityResult) {
    switch (connectivityResult.name) {
      case 'none':
        debugPrint('MexNi Is none ${connectivityResult.name}');
        return state.copyWith(
            connectivityResult: connectivityResult,
            status: HenetworkStatus.noInternet);
      case 'mobile':
        debugPrint('MexNi Is mobile ${connectivityResult.name}');
        return state.copyWith(
            connectivityResult: connectivityResult,
            status: HenetworkStatus.mobileNetwork);
      case 'wifi':
        debugPrint('MexNi Is wifi ${connectivityResult.name}');
        return state.copyWith(
            connectivityResult: connectivityResult,
            status: HenetworkStatus.wifiNetwork);
      default:
        debugPrint('MexNi Is default ${connectivityResult.name}');
        return state.copyWith(
            connectivityResult: connectivityResult,
            status: HenetworkStatus.loading);
    }
  }

  FutureOr<void> _onHeHeNetworkFirebaseAction(
      HeNetworkFirebaseNetworkChange event, Emitter<HenetworkState> emit) {
    emit(state.copyWith(status: event.networkStatus));
  }
}
