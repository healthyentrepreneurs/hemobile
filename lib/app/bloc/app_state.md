part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState._({
    this.status = HeAuthStatus.unknown,
    this.user = User.empty,
  });

  const AppState.unknown() : this._();

  const AppState.authenticated(User user)
      : this._(status: HeAuthStatus.authenticated, user: user);

  const AppState.unauthenticated()
      : this._(status: HeAuthStatus.unauthenticated);

  final HeAuthStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}

enum AppFlow {
mainScaffold,
userProfile,
surveyPageBrowser,
sectionsPage,
}