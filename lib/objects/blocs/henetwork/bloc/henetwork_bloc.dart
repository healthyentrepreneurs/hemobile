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
// transformer: droppable()
  HenetworkBloc() : super(const HenetworkState.loading()) {
    on<HeNetworkNetworkStatus>(_onHeNetworkNetworkStatus);
  }
  final Connectivity _connectivity = Connectivity();

  FutureOr<void> _onHeNetworkNetworkStatus(
      HeNetworkNetworkStatus event, Emitter<HenetworkState> emit) async {
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
}
