import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());
  // static Route<void> route() {
  //   return MaterialPageRoute<void>(builder: (_) => const HomePage());
  // }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user)!;
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) {
          var networkChange =
              previous.gconnectivityResult != current.gconnectivityResult;
          if (networkChange) {
            debugPrint(
                'Nabada previous ${previous.gstatus} current ${current.gstatus} ');
            BlocProvider.of<DatabaseBloc>(context)
                .add(DatabaseFetched(user.id.toString(), current.gstatus));
          }
          return networkChange;
        }, builder: (context, state) {
      if (state.gconnectivityResult == ConnectivityResult.none) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          final networkBloc = BlocProvider.of<HenetworkBloc>(context);
          networkBloc.add(const HeNetworkNetworkStatus());
          debugPrint(
              "HomePage@InitState  ${state.gconnectivityResult} and ${state.gstatus}");
        });
      }
      debugPrint(
          "HomePage@ConnectionState  ${state.gconnectivityResult} and GStatus ${state.gstatus} VS ${state.status}");
      return MainScaffold(user: user);
      // return const Text("data");
    });
  }
}
