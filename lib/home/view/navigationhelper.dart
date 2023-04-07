import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';

enum NavigationState {
  mainScaffold,
  surveyPage,
  errorPage,
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
    // Add more required parameters as needed
  }) {
    if (databaseState.gselectedsubscription != null) {
      if (databaseState.error != null) {
        return NavigationState.errorPage;
      }
      return NavigationState.mainScaffold;
    } else if (databaseState.error != null) {
      return NavigationState.errorPage;
    } else {
      return NavigationState.mainScaffold;
    }
  }
}
