import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/view/view.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/home/datawidgets/userlanding.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import '../../course/section/bloc/section_bloc.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../../survey/bloc/survey_bloc.dart';
import '../../survey/widgets/surveypagebrowser.dart';
import '../widgets/widgets.dart';

class UserProfile extends StatelessWidget {
  // final String userid;
  const UserProfile({Key? key}) : super(key: key);

  static Page page({required String userid}) {
    return const MaterialPage(
      child: UserProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HenetworkBloc, HenetworkState>(
      listener: (context, state) {
        BlocProvider.of<DatabaseBloc>(context)
            .add(DatabaseFetched('3', state.gstatus));
      },
      child: BlocBuilder<DatabaseBloc, DatabaseState>(
          buildWhen: (previous, current) =>
              previous.ghenetworkStatus != current.ghenetworkStatus,
          builder: (context, state) {
            final databasebloc = BlocProvider.of<DatabaseBloc>(context);
            if (state.error != null) {
              return const StateLoadingHe()
                  .errorWithStackT(state.error!.message);
            } else {
              if (state.ghenetworkStatus == HenetworkStatus.loading) {
                databasebloc.add(DatabaseFetched('3',
                    context.select((HenetworkBloc bloc) => bloc.state.status)));
                return const StateLoadingHe().loadingData();
              } else {
                if (state.glistOfSubscriptionData.isEmpty) {
                  return const StateLoadingHe()
                      .noDataFound('You have no Tools');
                } else {
                  // final sectionBloc = BlocProvider.of<SectionBloc>(context);
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
                          databasebloc.add(DatabaseSubSelected(subscription));
                          if (subscription.source == 'originalm') {
                            BlocProvider.of<SurveyBloc>(context).add(
                              SurveyFetched(
                                  '${subscription.id}', state.ghenetworkStatus),
                            );
                          } else {
                            BlocProvider.of<SectionBloc>(context).add(
                              SectionFetched(
                                  '${subscription.id}', state.ghenetworkStatus),
                            );
                          }
                        },
                      );

                      // return UserLanding(
                      //     subscription: subscription,
                      //     onTap: () {
                      //       if (subscription.source == 'originalm') {
                      //         databasebloc
                      //             .add(DatabaseSubSelected(subscription));
                      //         BlocProvider.of<SurveyBloc>(context).add(
                      //             SurveyFetched('${subscription.id}',
                      //                 state.ghenetworkStatus));
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) =>
                      //                   const SurveyPageBrowser(),
                      //             ));
                      //       } else {
                      //         databasebloc
                      //             .add(DatabaseSubSelected(subscription));
                      //         BlocProvider.of<SectionBloc>(context).add(
                      //             SectionFetched('${subscription.id}',
                      //                 state.ghenetworkStatus));
                      //         Navigator.of(context).push(
                      //           MaterialPageRoute<SectionsPage>(
                      //             builder: (context) {
                      //               return BlocProvider.value(
                      //                 value: databasebloc,
                      //                 child: const SectionsPage(),
                      //               );
                      //             },
                      //           ),
                      //         );
                      //         // Navigator.push(
                      //         //     context,
                      //         //     MaterialPageRoute(
                      //         //       builder: (context) =>  const SectionsPage(),
                      //         //     ));
                      //       }
                      //     });
                    },
                  );
                }
              }
            }
          }),
    );
  }
}
