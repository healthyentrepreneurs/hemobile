part of 'app_bloc.dart';

abstract class AppEvent {
  const AppEvent();
}

class _AuthenticationStatusChanged extends AppEvent {
  const _AuthenticationStatusChanged(this.status);

  final HeAuthStatus status;
}

class AuthenticationLogoutRequested extends AppEvent {}

class LangChanged extends AppEvent{}