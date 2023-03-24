import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/survey/bloc/survey_bloc.dart';

enum NavigationState {
  mainScaffold,
  surveyPage,
  sectionsPage,
  // Add more navigation states as needed
}

class NavigationHelper {
  // Singleton pattern to have only one instance of NavigationHelper
  static final NavigationHelper _singleton = NavigationHelper._internal();

  factory NavigationHelper() {
    return _singleton;
  }

  NavigationHelper._internal();

  // A function to update the navigation state based on custom conditions
  NavigationState determineNavigationState({
    required DatabaseState databaseState,
    required HenetworkState henetworkState,
    required SurveyState surveyState,
    required SectionState sectionState,
    // Add more required parameters as needed
  }) {
    if (databaseState.gselectedsubscription != null) {
      if (surveyState.gsurveyjson != null &&
          databaseState.gselectedsubscription!.source == 'originalm') {
        return NavigationState.surveyPage;
      }
      if (databaseState.gselectedsubscription!.source != 'originalm' &&
          sectionState.glistofSections.isNotEmpty) {
        return NavigationState.sectionsPage;
      }
    }
    return NavigationState.mainScaffold;
  }
}
// enum FlowEvent { resetSurvey, pop }
//
// late FlowController<FlowEvent> _controller;
