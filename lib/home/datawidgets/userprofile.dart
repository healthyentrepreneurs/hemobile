import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/home/datawidgets/userlanding.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/survey/view/view.dart';
import 'package:he_api/he_api.dart';
import '../../course/view/view.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../widgets/widgets.dart';

class UserProfile extends StatelessWidget with WidgetsBindingObserver {
  final User user;
  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    final henetworkstate =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    debugPrint('UserProfile@NETWOK ${henetworkstate.name}');
    return BlocListener<HenetworkBloc, HenetworkState>(
      listener: (context, state) {
        databasebloc.add(DatabaseFetched('phila', state.gstatus));
      },
      child: BlocBuilder<DatabaseBloc, DatabaseState>(
          buildWhen: (previous, current) {
        debugPrint(
            'WHATSTATES previous ${previous.ghenetworkStatus}  current ${current.ghenetworkStatus}');
        return previous.ghenetworkStatus != current.ghenetworkStatus;
      }, builder: (context, state) {
        if (state.error != null) {
          return const StateLoadingHe().errorWithStackT(state.error!.message);
        } else {
          if (state.ghenetworkStatus == HenetworkStatus.loading) {
            debugPrint('UserProfile@HenetworkStatus.loading');
            databasebloc.add(DatabaseFetched('musoke', state.ghenetworkStatus));
            return const StateLoadingHe().loadingData();
          } else {
            debugPrint(
                'UserProfile@DatabaseBlocB ${state.gdisplayName} then ${state.ghenetworkStatus}');
            if (state.glistOfSubscriptionData.isEmpty) {
              return const StateLoadingHe().noDataFound('You have no Tools');
            } else {
              return ListView.builder(
                key: Key(henetworkstate.name),
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 40),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.glistOfSubscriptionData.length,
                itemBuilder: (BuildContext context, int index) {
                  var subscription = state.glistOfSubscriptionData[index]!;
                  return UserLanding(
                      key: Key(henetworkstate.name),
                      subscription: subscription,
                      onTap: () {
                        if (subscription.source == 'originalm') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SurveyPage(course: subscription),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SectionsPage(course: subscription),
                              ));
                        }
                      });
                },
              );
            }
          }
        }
      }),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app in resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        break;
    }
    // super.didChangeAppLifecycleState(state);
  }
}
