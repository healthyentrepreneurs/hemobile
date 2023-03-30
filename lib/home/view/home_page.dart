import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:he/survey/widgets/surveypagebrowser.dart';

import '../../course/section/bloc/section_bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage._();
  static Page<void> page() => const MaterialPage<void>(child: HomePage._());
  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const HomePage._());
  }
  // static Route<DatabaseState> routex() {
  //   return MaterialPageRoute(
  //     builder: (_) => BlocProvider(
  //       create: (_) => DatabaseBloc(repository: getIt<DatabaseRepository>()),
  //       child: const HomePage._(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    // final networkBloc = context.watch<HenetworkBloc>().state;
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) {
      var networkChange =
          previous.gconnectivityResult != current.gconnectivityResult;
      if (networkChange) {
        BlocProvider.of<DatabaseBloc>(context)
            .add(DatabaseFetched(user.id.toString(), current.gstatus));
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
          buildWhen: (previous, current) =>
              previous.ghenetworkStatus != current.ghenetworkStatus,
          builder: (context, state) {
            final _henetworkstate =
                BlocProvider.of<HenetworkBloc>(context).state;
            return FlowBuilder<DatabaseState>(
              state: context
                  .select((DatabaseBloc databaseState) => databaseState.state),
              onGeneratePages:
                  (DatabaseState state, List<Page<dynamic>> pages) {
                Widget subWidget;
                if (state == const DatabaseState.loading()) {
                  debugPrint("NetworkState goes @B");
                  subWidget = const StateLoadingHe().loadingData();
                  BlocProvider.of<DatabaseBloc>(context).add(DatabaseFetched(
                      user.id.toString(), _henetworkstate.status));
                } else if (state.error != null) {
                  subWidget = const StateLoadingHe()
                      .errorWithStackT(state.error!.message);
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
                      final databasebloc =
                          BlocProvider.of<DatabaseBloc>(context);
                      var subscription = state.glistOfSubscriptionData[index]!;
                      return UserLanding(
                        subscription: subscription,
                        onTap: ()  {
                          databasebloc.add(DatabaseSubSelected(subscription));
                          if (subscription.source == 'originalm') {
                            // BlocProvider.of<SurveyBloc>(context).add(
                            //   SurveyFetched(
                            //       '${subscription.id}', state.ghenetworkStatus),
                            // );
                             Navigator.of(context)
                                .push(SurveyPageBrowser.route());
                          } else {
                            BlocProvider.of<SectionBloc>(context).add(
                              SectionFetched(
                                  '${subscription.id}', state.ghenetworkStatus),
                            );
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
