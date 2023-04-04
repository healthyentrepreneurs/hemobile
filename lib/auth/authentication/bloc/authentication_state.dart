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

  factory AuthenticationState.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      return AuthenticationState.authenticated(
        User.fromJson(json['user'] as Map<String, dynamic>),
      );
    } else if (json['status'] == 'unauthenticated') {
      return const AuthenticationState.unauthenticated();
    } else {
      return const AuthenticationState.unknown();
    }
  }

  Map<String, dynamic> toJson() {
    if (status == HeAuthStatus.authenticated) {
      return {
        'status': 'authenticated',
        'user': user.toJson(),
      };
    } else if (status == HeAuthStatus.unauthenticated) {
      return {
        'status': 'unauthenticated',
      };
    } else {
      return {
        'status': 'unknown',
      };
    }
  }
}
