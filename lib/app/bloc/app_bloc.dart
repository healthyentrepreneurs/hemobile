import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:he_api/he_api.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc
    extends Bloc<AppEvent, AppState> {
  AppBloc({
    required HeAuthRepository heAuthRepository,
  })  : _heAuthRepository = heAuthRepository,
        super(const AppState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _heAuthRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
  }

  final HeAuthRepository _heAuthRepository;
  //Added final
  late final StreamSubscription<HeAuthStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _heAuthRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AppState> emit,
  ) async {
    switch (event.status) {
      case HeAuthStatus.unauthenticated:
        return emit(const AppState.unauthenticated());
      case HeAuthStatus.authenticated:
        final user = _heAuthRepository.user;
        debugPrint(user.props.join(" \n "));
        return emit(AppState.authenticated(user));
      case HeAuthStatus.unknown:
        return emit(const AppState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    _heAuthRepository.logOut();
  }
}
