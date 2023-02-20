import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'appcycle_event.dart';

class AppLifecycleStateBloc
    extends Bloc<AppLifecycleStateEvent, AppLifecycleState> {
  AppLifecycleStateBloc() : super(AppLifecycleState.resumed) {
    on<AppLifecycleStateEvent>((event, emit) {
      // create a switch statement to handle the different events
      switch (event) {
        case AppLifecycleStateEvent.resumed:
          emit(AppLifecycleState.resumed);
          break;
        case AppLifecycleStateEvent.inactive:
          emit(AppLifecycleState.inactive);
          break;
        case AppLifecycleStateEvent.paused:
          emit(AppLifecycleState.paused);
          break;
        case AppLifecycleStateEvent.detached:
          emit(AppLifecycleState.detached);
          break;
      }
    });
  }
}
