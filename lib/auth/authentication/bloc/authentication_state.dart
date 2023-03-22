part of 'authentication_bloc.dart';


class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = HeAuthStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: HeAuthStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: HeAuthStatus.unauthenticated);

  final HeAuthStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}