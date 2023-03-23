import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/home/datawidgets/datawidget.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import '../../course/section/view/section_page.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../../survey/widgets/surveypagebrowser.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());
  // static Route<void> route() {
  //   return MaterialPageRoute<void>(builder: (_) => const HomePage());
  // }

  @override
  _HomePageState createState() => _HomePageState();
}

enum FlowState {
  mainScaffold,
  surveyPage,
  sectionsPage,
}

class _HomePageState extends State<HomePage> {
  FlowState _determineFlowState(BuildContext context) {
    final DatabaseState databaseState =
        context.select((DatabaseBloc bloc) => bloc.state);
    final HenetworkState henetworkState =
        context.select((HenetworkBloc bloc) => bloc.state);
    final SurveyState surveyState =
        context.select((SurveyBloc bloc) => bloc.state);
    final SectionState sectionState =
        context.select((SectionBloc bloc) => bloc.state);

    if (databaseState.gselectedsubscription != null) {
      if (surveyState.gsurveyjson != null &&
          databaseState.gselectedsubscription!.source == 'originalm') {
        return FlowState.surveyPage;
      }
      if (databaseState.gselectedsubscription!.source != 'originalm' &&
          sectionState.glistofSections.isNotEmpty) {
        return FlowState.sectionsPage;
      }
    }
    return FlowState.mainScaffold;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user)!;

    return BlocBuilder<HenetworkBloc, HenetworkState>(
      buildWhen: (previous, current) {
        var networkChange =
            previous.gconnectivityResult != current.gconnectivityResult;
        if (networkChange) {
          BlocProvider.of<DatabaseBloc>(context)
              .add(DatabaseFetched(user.id.toString(), current.gstatus));
        }
        return networkChange;
      },
      builder: (context, state) {
        if (state.gconnectivityResult == ConnectivityResult.none) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            final networkBloc = BlocProvider.of<HenetworkBloc>(context);
            networkBloc.add(const HeNetworkNetworkStatus());
          });
        }
        return MultiBlocListener(
          listeners: [
            BlocListener<DatabaseBloc, DatabaseState>(
              listener: (context, state) {
                setState(
                    () {}); // Trigger rebuild when the DatabaseBloc state changes.
              },
            ),
            BlocListener<SurveyBloc, SurveyState>(
              listener: (context, state) {
                setState(
                    () {}); // Trigger rebuild when the SurveyBloc state changes.
              },
            ),
            BlocListener<SectionBloc, SectionState>(
              listener: (context, state) {
                setState(
                    () {}); // Trigger rebuild when the SectionBloc state changes.
              },
            ),
          ],
          child: FlowBuilder<FlowState>(
            state: _determineFlowState(context),
            onGeneratePages: (flowState, pages) {
              switch (flowState) {
                case FlowState.mainScaffold:
                  return [MaterialPage(child: MainScaffold(user: user))];
                case FlowState.surveyPage:
                  return [const MaterialPage(child: SurveyPageBrowser())];
                case FlowState.sectionsPage:
                  return [const MaterialPage(child: SectionsPage())];
              }
            },
          ),
        );
      },
    );
  }
}
