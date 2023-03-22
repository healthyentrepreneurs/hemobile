part of 'app_bloc.dart';

// @immutable
// abstract class AppEvent {}


abstract class AppEvent {}

class AuthenticationStatusChanged extends AppEvent {
  final HeAuthStatus status;
  FlowController<AppState>? flowController;
  AuthenticationStatusChanged({required this.status,this.flowController});
}

class UserProfileRequested extends AppEvent {
  final String userid;
  UserProfileRequested({required this.userid});
}
