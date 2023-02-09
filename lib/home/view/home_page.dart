import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';

import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.gconnectivityResult == ConnectivityResult.none) {
            final dataBloc = BlocProvider.of<HenetworkBloc>(context);
            dataBloc.add(const HeNetworkNetworkStatus());
            debugPrint("HomePage@InitState  ${state.gconnectivityResult}");
            return const SizedBox(height: 0.0);
          }
          debugPrint("HomePage@ConnectionState  ${state.gconnectivityResult}");
          return const MainScaffold();
          // return const SizedBox(height: 0.0);
        });
    // var currentV = initSurveyDataHomePage(user.id!, apks);
  }
}
