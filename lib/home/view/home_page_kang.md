import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/home/home.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import '../../course/section/view/section_page.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../../survey/widgets/surveypagebrowser.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationHelper _navigationHelper = NavigationHelper();
  late FlowController<NavigationState> _controller;

  NavigationState _determineFlowState({
    required DatabaseState databaseState,
    required HenetworkState henetworkState,
    required SurveyState surveyState,
    required SectionState sectionState,
  }) {
    return _navigationHelper.determineNavigationState(
      databaseState: databaseState,
      henetworkState: henetworkState,
      surveyState: surveyState,
      sectionState: sectionState,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = FlowController(NavigationState.mainScaffold);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          // WidgetsBinding.instance!.addPostFrameCallback((_) {
          //   final networkBloc = BlocProvider.of<HenetworkBloc>(context);
          //   networkBloc.add(const HeNetworkNetworkStatus());
          // });
          final networkBloc = BlocProvider.of<HenetworkBloc>(context);
          networkBloc.add(const HeNetworkNetworkStatus());
        }
        return MultiBlocListener(
          listeners: [
            BlocListener<DatabaseBloc, DatabaseState>(
              listener: (context, state) {
                _controller.update((_) => _determineFlowState(
                      databaseState: state,
                      henetworkState: context.read<HenetworkBloc>().state,
                      surveyState: context.read<SurveyBloc>().state,
                      sectionState: context.read<SectionBloc>().state,
                    ));
                setState(
                        () {});
              },
            ),
            BlocListener<SurveyBloc, SurveyState>(
              listener: (context, state) {
                _controller.update((_) => _determineFlowState(
                      databaseState: context.read<DatabaseBloc>().state,
                      henetworkState: context.read<HenetworkBloc>().state,
                      surveyState: state,
                      sectionState: context.read<SectionBloc>().state,
                    ));
              },
            ),
            BlocListener<SectionBloc, SectionState>(
              listener: (context, state) {
                _controller.update((_) => _determineFlowState(
                      databaseState: context.read<DatabaseBloc>().state,
                      henetworkState: context.read<HenetworkBloc>().state,
                      surveyState: context.read<SurveyBloc>().state,
                      sectionState: state,
                    ));
              },
            ),
            BlocListener<HenetworkBloc, HenetworkState>(
              listenWhen: (previous, current) =>
                  previous.gstatus != current.gstatus,
              listener: (context, state) {
                if (_controller.state.name == "surveyPage") {
                  BlocProvider.of<SurveyBloc>(context).add(const SurveyReset());
                  BlocProvider.of<DatabaseBloc>(context)
                      .add(const DatabaseSubDeSelected());
                } else if (_controller.state.name == "sectionsPage") {
                  BlocProvider.of<DatabaseBloc>(context)
                      .add(const DatabaseSubDeSelected());
                  BlocProvider.of<SectionBloc>(context)
                      .add(const SectionDeFetched());
                }
                _controller.update((_) => _determineFlowState(
                      databaseState: context.read<DatabaseBloc>().state,
                      henetworkState: state,
                      surveyState: context.read<SurveyBloc>().state,
                      sectionState: context.read<SectionBloc>().state,
                    ));
                setState(
                        () {});
              },
            ),
          ],
          child: FlowBuilder<NavigationState>(
            controller: _controller,
            // state: _determineFlowState(context),
            onGeneratePages: (flowState, pages) {
              switch (flowState) {
                // case NavigationState.errorPage:
                //   return [const MaterialPage(child: ErrorPage())];
                case NavigationState.mainScaffold:
                  return [const MaterialPage(child: MainScaffold())];
                case NavigationState.surveyPage:
                  return [const MaterialPage(child: SurveyPageBrowser())];
                case NavigationState.sectionsPage:
                  return [const MaterialPage(child: SectionsPage())];
              }
            },
          ),
        );
      },
    );
  }
}
