import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/course/section/view/view.dart';
import 'package:he/home/datawidgets/datawidget.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/survey/widgets/surveypagebrowser.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage._();
  const HomePage({Key? key}) : super(key: key);
  static Page<void> page() => const MaterialPage<void>(child: HomePage._());
  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const HomePage._());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    final _blocDatabase = BlocProvider.of<DatabaseBloc>(context);
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) {
      var networkChange =
          previous.gconnectivityResult != current.gconnectivityResult ||
              previous.gstatus != current.gstatus;
      if (networkChange) {
        _blocDatabase.add(DatabaseFetched(user.id.toString(), current.gstatus));
        //More less the same thing
        _blocDatabase.add(DatabaseLoadEvent()); // Add this line
        _blocDatabase.add(const DbCountSurvey());
        debugPrint("NetworkState Ends @B");
      }
      return networkChange;
    }, builder: (context, state) {
      if (state.gconnectivityResult == ConnectivityResult.none) {
        debugPrint("NetworkState Start @ A");
        final networkBloc = BlocProvider.of<HenetworkBloc>(context);
        networkBloc.add(const HeNetworkNetworkStatus());
      }
      return BlocBuilder<DatabaseBloc, DatabaseState>(
          buildWhen: (previous, current) {
        var networkChange =
            previous.ghenetworkStatus != current.ghenetworkStatus;
        bool dataChange = !listEquals(
            previous.glistOfSubscriptionData, current.glistOfSubscriptionData);
        return networkChange || dataChange;
      }, builder: (context, state) {
        final _henetworkstate = BlocProvider.of<HenetworkBloc>(context).state;
        debugPrint('CHECHE ${_henetworkstate.status.name}');
        debugPrint(
            'MPAPAKO ${state.ghenetworkStatus.name} \n ERROR_STARTS ${state.error?.message} ERROR_ENDS \n list ${state.glistOfSubscriptionData.toString()}');
        return FlowBuilder<DatabaseState>(
          state: context
              .select((DatabaseBloc databaseState) => databaseState.state),
          onGeneratePages: (DatabaseState state, List<Page<dynamic>> pages) {
            Widget subWidget;
            if (state == const DatabaseState.loading()) {
              debugPrint("NetworkState goes @B");
              subWidget = const StateLoadingHe().loadingData();
              _blocDatabase.add(
                  DatabaseFetched(user.id.toString(), _henetworkstate.status));
            } else if (state.error != null) {
              subWidget =
                  const StateLoadingHe().errorWithStackT(state.error!.message);
              debugPrint('PAPAWE ${_henetworkstate.status.name}');
            } else if (state.glistOfSubscriptionData.isEmpty) {
              subWidget =
                  const StateLoadingHe().noDataFound('You have no Tools');
            } else {
              subWidget = ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 40),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.glistOfSubscriptionData.length,
                itemBuilder: (BuildContext context, int index) {
                  var subscription = state.glistOfSubscriptionData[index]!;
                  return UserLanding(
                    subscription: subscription,
                    onTap: () {
                      _blocDatabase.add(DatabaseSubSelected(subscription));
                      if (subscription.source == 'originalm') {
                        Navigator.of(context).push(SurveyPageBrowser.route());
                      } else {
                        Navigator.of(context).push(SectionsFlow.route());
                      }
                    },
                  );
                },
              );
              // return [SubScription.page()];
            }
            return [
              MaterialPage<void>(child: MainScaffold(subwidget: subWidget)),
            ];
          },
        );
      });
    });
  }
}
