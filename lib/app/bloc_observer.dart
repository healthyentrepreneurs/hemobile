import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/helper_functions.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    printOnlyDebug(event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    printOnlyDebug(error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    printOnlyDebug(change);
    if (bloc.runtimeType.toString() == "LangHeCubit") {

    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    printOnlyDebug(transition);
  }
}
