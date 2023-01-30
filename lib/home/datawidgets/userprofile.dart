import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/datawidgets/userlanding.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/survey/view/view.dart';
import 'package:he_api/he_api.dart';

import '../../course/view/view.dart';
import '../widgets/widgets.dart';

class UserProfile extends StatelessWidget {
  final User user;
  const UserProfile({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final int user_id = user.id!;
    //use count or pageSize in FirestoreListView
    return BlocBuilder<DatabaseBloc, DatabaseState>(builder: (context, state) {
      if (state is DatabaseInitial) {
        context.read<DatabaseBloc>().add(const DatabaseFetched('displayName'));
        return const StateLoadingHe().loadingData();
      } else if (state is DatabaseSuccess) {
        if (state.listOfSubscriptionData.isEmpty) {
          return const StateLoadingHe().noDataFound('You have no Tools');
        } else {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 40),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.listOfSubscriptionData.length,
            itemBuilder: (BuildContext context, int index) {
              var subscription = state.listOfSubscriptionData[index]!;
              return UserLanding(
                  subscription: subscription,
                  onTap: () {
                    //Content Form Survey
                    if (subscription.source == 'originalm') {
                      // printOnlyDebug("Njovu Surveys Here");
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
      else if(state is DatabaseError){
        return const StateLoadingHe().errorWithStackT(state.error.message);
      }
      else {
        return const StateLoadingHe().loadingData();
      }
    });
  }
}
