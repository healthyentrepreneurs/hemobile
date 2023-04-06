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
  // assign ConnectivityResult.none if no connectivity is available
  final _connectivity = Connectivity();

  HenetworkBloc() : super(const HenetworkState.loading()) {
    on<HeNetworkNetworkStatus>(_onHeNetworkNetworkStatus);
    on<HeNetworkFirebaseNetworkChange>(
      _onHeHeNetworkFirebaseAction,
      transformer: droppable(),
    );
  }

  Future<void> _onHeNetworkNetworkStatus(
    HeNetworkNetworkStatus event,
    Emitter<HenetworkState> emit,
  ) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    emit(
      state.copyWith(
        connectivityResult: connectivityResult,
        status: _getStatusFromConnectivityResult(connectivityResult),
      ),
    );
    _connectivity.onConnectivityChanged.listen(
      (result) {
        emit(
          state.copyWith(
            connectivityResult: result,
            status: _getStatusFromConnectivityResult(result),
          ),
        );
      },
    );
  }

  void _onHeHeNetworkFirebaseAction(
    HeNetworkFirebaseNetworkChange event,
    Emitter<HenetworkState> emit,
  ) {
    emit(state.copyWith(status: event.networkStatus));
  }

  HenetworkStatus _getStatusFromConnectivityResult(
    ConnectivityResult connectivityResult,
  ) {
    switch (connectivityResult) {
      case ConnectivityResult.none:
        return HenetworkStatus.noInternet;
      case ConnectivityResult.mobile:
        return HenetworkStatus.mobileNetwork;
      case ConnectivityResult.wifi:
        return HenetworkStatus.wifiNetwork;
      default:
        return HenetworkStatus.loading;
    }
  }
}
