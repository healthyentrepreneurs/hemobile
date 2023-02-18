import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';

part 'henetwork_event.dart';
part 'henetwork_state.dart';

class HenetworkBloc extends Bloc<HenetworkEvent, HenetworkState> {
  //assign connectivityResult to ConnectivityResult.none if no connectivity is available
// transformer: droppable()
  HenetworkBloc() : super(const HenetworkState.loading()) {
    on<HeNetworkNetworkStatus>(_onHeNetworkNetworkStatus);
    on<HeNetworkFirebaseNetworkChange>(
        _onHeHeNetworkFirebaseAction); // transformer:droppable() is used to drop all events when the state is not HenetworkInitial );
  }
  final Connectivity _connectivity = Connectivity();

  FutureOr<void> _onHeNetworkNetworkStatus(
      HeNetworkNetworkStatus event, Emitter<HenetworkState> emit) async {
    await emit.forEach(_connectivity.onConnectivityChanged,
        onData: (ConnectivityResult connectivityResult) {
      // create a switch statement to handle the different connectivity states and emit the appropriate state
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

  // return state.copyWith(connectivityResult: connectivityResult);
  // return HenetworkState.loading(inconnectivityResult: connectivityResult);

  FutureOr<void> _onHeHeNetworkFirebaseAction(
      HeNetworkFirebaseNetworkChange event, Emitter<HenetworkState> emit) {
    emit(state.copyWith(status: event.networkStatus));
  }
}
