import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:he_api/he_api.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required HeAuthRepository heAuthRepository,
  })  : _heAuthRepository = heAuthRepository,
        super(const AuthenticationState.unknown()) {
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
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case HeAuthStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case HeAuthStatus.authenticated:
        final user = _heAuthRepository.user;
        debugPrint(user.props.join(" \n "));
        return emit(AuthenticationState.authenticated(user));
      case HeAuthStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _heAuthRepository.logOut();
  }
}
