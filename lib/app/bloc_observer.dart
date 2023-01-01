import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/helper_functions.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    printOnlyDebug('Josh Event ${bloc.runtimeType} $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    printOnlyDebug('Josh Error ${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    printOnlyDebug(
        "Josh Runtime ${bloc.runtimeType.toString()} and Josh Change $change");
    // if (bloc.runtimeType.toString() == "LangHeCubit") {
    //
    // }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // capture information about what triggered the state change
    super.onTransition(bloc, transition);
    printOnlyDebug("Josh Transition ${bloc.runtimeType} $transition");
  }
}
