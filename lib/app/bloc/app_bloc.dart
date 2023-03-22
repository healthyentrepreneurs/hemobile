import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:he_api/he_api.dart';

// import '../../auth/authentication/authentication.dart';
// import '../../objects/blocs/hedata/bloc/database_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required this.authenticationBloc,
    required this.databaseBloc,
    required this.sectionBloc,
    required this.surveyBloc,
    required this.henetworkBloc,
  }) : super(const AppState(status: AppStatus.unknown)) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    authenticationBloc.stream.listen((authState) {
      add(AuthenticationStatusChanged(status: authState.status));
    });
    // Add listeners for the other blocs here, and update the AppFlowState based on their states
  }

  final AuthenticationBloc authenticationBloc;
  final DatabaseBloc databaseBloc;
  final SectionBloc sectionBloc;
  final SurveyBloc surveyBloc;
  final HenetworkBloc henetworkBloc;
  _onAuthenticationStatusChanged(
      AuthenticationStatusChanged event, Emitter<AppState> emit) {
    switch (event.status) {
      case HeAuthStatus.unauthenticated:
        // return emit(const AppState.unauthenticated());
        return emit(const AppState(status: AppStatus.unknown));
      case HeAuthStatus.authenticated:
        debugPrint(
            "FLOWARTHUR ${authenticationBloc.state.user.props.join(" \n ")}");
        return emit(AppState(
            status: AppStatus.authenticated,
            user: authenticationBloc.state.user,
            flowController: event.flowController));
      case HeAuthStatus.unknown:
        return emit(const AppState(status: AppStatus.unknown));
    }
  }
}
