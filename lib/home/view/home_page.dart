import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';
import 'package:he/home/view/view.dart';
import 'package:he/injection.dart';

import '../../helper/file_system_util.dart';
import '../../objects/blocs/hedata/bloc/database_bloc.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) => previous.gconnectivityResult != current.gconnectivityResult,
        builder: (context, state) {
          // if (state.gconnectivityResult == ConnectivityResult.none) {
          //   final dataBloc = BlocProvider.of<HenetworkBloc>(context);
          //   dataBloc.add(const HeNetworkNetworkStatus());
          //   debugPrint("HomePage@InitStateP  ${state.gconnectivityResult} and ${state.gstatus}");
          //   // return const SizedBox(height: 0.0);
          // }
            final dataBloc = BlocProvider.of<HenetworkBloc>(context);
            dataBloc.add(const HeNetworkNetworkStatus());
            debugPrint("HomePage@InitStateP  ${state.gconnectivityResult} and ${state.gstatus}");
          debugPrint(
              "HomePage@ConnectionState  ${state.gconnectivityResult} and GStatus ${state.gstatus} VS ${state.status}");
          return const MainScaffold();
        });
  }
}
