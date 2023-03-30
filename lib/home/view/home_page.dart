import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/survey/widgets/surveypagebrowser.dart';
import 'package:he_api/he_api.dart';

import '../../course/section/bloc/section_bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage._({required this.user});
  // static Page<void> page(User user) => const MaterialPage<void>(child: HomePage._(user:user));
  static Page<void> page(User user) =>
      MaterialPage<void>(child: HomePage._(user: user));
  // static Route<DatabaseState> route(User user) {
  //   return MaterialPageRoute(
  //     builder: (_) => BlocProvider(
  //       create: (_) => DatabaseBloc(repository: getIt<DatabaseRepository>()),
  //       child: HomePage._(user: user),
  //     ),
  //   );
  // }

  static Route<DatabaseState> route(User user) {
    return MaterialPageRoute(
      builder: (_) => BlocBuilder<HenetworkBloc, HenetworkState>(
        builder: (context, current) {
          if (current.gconnectivityResult == ConnectivityResult.none) {
            final networkBloc = BlocProvider.of<HenetworkBloc>(context);
            networkBloc.add(const HeNetworkNetworkStatus());
          }
          return BlocProvider(
            create: (_) => DatabaseBloc(repository: getIt<DatabaseRepository>())
              ..add(DatabaseFetched(user.id.toString(), current.gstatus)),
            child: HomePage._(user: user),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocBuilder<HenetworkBloc, HenetworkState>(
        buildWhen: (previous, current) {
      var networkChange =
          previous.gconnectivityResult != current.gconnectivityResult;
      if (networkChange) {
        BlocProvider.of<DatabaseBloc>(context)
            .add(DatabaseFetched(user.id.toString(), current.gstatus));
      }
      return networkChange;
    }, builder: (context, state) {
      if (state.gconnectivityResult == ConnectivityResult.none) {
        final networkBloc = BlocProvider.of<HenetworkBloc>(context);
        networkBloc.add(const HeNetworkNetworkStatus());
      }
      return BlocBuilder<DatabaseBloc, DatabaseState>(
          buildWhen: (previous, current) =>
              previous.ghenetworkStatus != current.ghenetworkStatus,
          builder: (context, state) {
            return FlowBuilder<DatabaseState>(
              state: context
                  .select((DatabaseBloc databaseState) => databaseState.state),
              onGeneratePages:
                  (DatabaseState state, List<Page<dynamic>> pages) {
                Widget subWidget;
                if (state.error != null) {
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
                        onTap: () async {
                          databasebloc.add(DatabaseSubSelected(subscription));
                          if (subscription.source == 'originalm') {
                            // BlocProvider.of<SurveyBloc>(context).add(
                            //   SurveyFetched(
                            //       '${subscription.id}', state.ghenetworkStatus),
                            // );
                            await Navigator.of(context)
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
