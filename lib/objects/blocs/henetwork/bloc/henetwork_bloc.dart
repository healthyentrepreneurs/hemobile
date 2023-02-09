import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:meta/meta.dart';

part 'henetwork_event.dart';
part 'henetwork_state.dart';

class HenetworkBloc extends Bloc<HenetworkEvent, HenetworkState> {
  //assign connectivityResult to ConnectivityResult.none if no connectivity is available

  HenetworkBloc() : super(const HenetworkState.loading()) {
    on<HeNetworkNetworkStatus>(_onHeNetworkNetworkStatus,
        transformer: droppable());
    on<HeNetworkFirebaseNetworkChange>(
        _onHeHeNetworkFirebaseAction); // transformer:droppable() is used to drop all events when the state is not HenetworkInitial );
  }
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult mconnectivityResult;

  FutureOr<void> _onHeNetworkNetworkStatus(
      HeNetworkNetworkStatus event, Emitter<HenetworkState> emit) async {
    await emit.forEach(_connectivity.onConnectivityChanged,
        onData: (ConnectivityResult connectivityResult) {
      mconnectivityResult = connectivityResult;
      return state.copyWith(connectivityResult: connectivityResult);
      // return state.copyWith(connectivityResult: connectivityResult);
      // return HenetworkState.loading(inconnectivityResult: connectivityResult);
    });
  }

  FutureOr<void> _onHeHeNetworkFirebaseAction(
      HeNetworkFirebaseNetworkChange event, Emitter<HenetworkState> emit) {
    emit(state.copyWith(status: event.networkStatus));
  }
}
