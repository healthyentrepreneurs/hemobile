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

class UserProfile extends StatelessWidget {
  final User user;
  const UserProfile({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // DatabaseBloc databasebloc = context.read<DatabaseBloc>();
    // final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    final henetworkstate =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    return BlocBuilder<DatabaseBloc, DatabaseState>(
        buildWhen: (previous, current) {
      debugPrint(
          'NabadaA ${previous.ghenetworkStatus} and ${current.ghenetworkStatus}');
      return previous.ghenetworkStatus != current.ghenetworkStatus;
    }, builder: (context, state) {
      if (state.error != null) {
        // debugPrint('UserProfile@DatabaseError ');
        return const StateLoadingHe().errorWithStackT(state.error!.message);
      } else {
        final databasebloc = BlocProvider.of<DatabaseBloc>(context);
        if (state.ghenetworkStatus == HenetworkStatus.loading) {
          debugPrint('UserProfile@HenetworkStatus.loading');
          databasebloc.add(DatabaseFetched('njovu', henetworkstate));
          return const StateLoadingHe().loadingData();
        } else {
          debugPrint(
              'UserProfile@DatabaseBlocB ${state.gdisplayName} then ${state.ghenetworkStatus}');
          if (state.glistOfSubscriptionData.isEmpty) {
            return const StateLoadingHe().noDataFound('You have no Tools');
          } else {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.glistOfSubscriptionData.length,
              itemBuilder: (BuildContext context, int index) {
                var subscription = state.glistOfSubscriptionData[index]!;
                return UserLanding(
                    subscription: subscription,
                    onTap: () {
                      //Content Form Survey
                      if (subscription.source == 'originalm') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SurveyPage(course: subscription),
                            ));
                      } else {
                        //Course content Books, Quiz Etc
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
    });
  }
}
