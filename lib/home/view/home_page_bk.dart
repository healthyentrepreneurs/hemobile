import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';

import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) {
      debugPrint(
          'Nabada previous ${previous.gstatus} current ${current.gstatus} ');
      return previous.gconnectivityResult != current.gconnectivityResult;
    }, builder: (context, state) {
      if (state.gconnectivityResult == ConnectivityResult.none) {
        final networkBloc = BlocProvider.of<HenetworkBloc>(context);
        networkBloc.add(const HeNetworkNetworkStatus());
        debugPrint(
            "HomePage@InitState  ${state.gconnectivityResult} and ${state.gstatus}");
      }
      debugPrint(
          "HomePage@ConnectionState  ${state.gconnectivityResult} and GStatus ${state.gstatus} VS ${state.status}");
      return const MainScaffold();
    });
  }
}
