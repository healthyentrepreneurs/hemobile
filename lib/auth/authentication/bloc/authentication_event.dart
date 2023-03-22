part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged(this.status);
  final HeAuthStatus status;
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}