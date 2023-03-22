part of 'app_bloc.dart';

// @immutable
// abstract class AppState {}
//
// class AppInitial extends AppState {}

enum AppStatus {
  unknown,
  authenticated,
  unauthenticated,
  userProfile,
  surveyPageBrowser,
  sectionsPage,
}

// class AppState extends Equatable {
//   final AppStatus status;
//   final User? user;
//   const AppState({required this.status, this.user});
//
//   @override
//   List<Object?> get props => [status, user];
// }

class AppState extends Equatable {
  final AppStatus status;
  final User? user;
  final FlowController<AppState>? flowController;

  const AppState({
    required this.status,
    this.user,
    this.flowController,
  });

  AppState copyWith({
    AppStatus? status,
    User? user,
    FlowController<AppState>? flowController,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      flowController: flowController ?? this.flowController,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppState &&
        other.status == status &&
        other.user == user &&
        other.flowController == flowController;
  }

  @override
  int get hashCode => status.hashCode ^ user.hashCode ^ flowController.hashCode;

  @override
  List<Object?> get props => [status, user];
}
