import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:he_api/he_api.dart';

import '../../home/home.dart';
import 'survey_webviewwidget.dart';

class SurveyPageBrowser extends StatefulWidget {
  const SurveyPageBrowser._();
  static Route<SurveyState> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => SurveyBloc(repository: getIt<DatabaseRepository>()),
        child: const SurveyPageBrowser._(),
      ),
    );
  }

  @override
  _SurveyPageBrowserState createState() => _SurveyPageBrowserState();
}

class _SurveyPageBrowserState extends State<SurveyPageBrowser> {
  late Subscription _course;
  late final DatabaseBloc databaseBloc;
  late final SurveyBloc surveyBloc;

  @override
  void initState() {
    super.initState();
    _course = context.read<DatabaseBloc>().state.gselectedsubscription!;
    databaseBloc = BlocProvider.of<DatabaseBloc>(context);
    surveyBloc = BlocProvider.of<SurveyBloc>(context);
    _fetchSurvey();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyBloc, SurveyState>(
      // buildWhen: (previous, current) => previous.props != current.props,
      builder: (context, state) {
        if (state == const SurveyState.loading()) {
          _fetchSurvey();
        }
        return FlowBuilder<SurveyState>(
          state: context.select((SurveyBloc surveyBloc) => surveyBloc.state),
          onGeneratePages: _onGeneratePages,
        );
      },
    );
  }

  void _fetchSurvey() {
    surveyBloc.add(
      SurveyFetched(
        '${_course.id}',
        databaseBloc.state.ghenetworkStatus,
      ),
    );
  }

  List<Page<void>> _onGeneratePages(
    SurveyState state,
    List<Page<dynamic>> pages,
  ) {
    Widget subWidget;
    if (state == const SurveyState.loading()) {
      _fetchSurvey();
      subWidget = const StateLoadingHe().loadingDataSpink();
    } else if (state.error != null) {
      subWidget = const StateLoadingHe().errorWithStackT(state.error!.message);
    } else if (state.gsurveyjson == null) {
      subWidget = const StateLoadingHe().noDataFound('This Survey Is Empty');
    } else {
      subWidget = SurveyWebViewWidget(_course.id.toString());
    }

    return [
      MaterialPage<void>(
        child: BlocListener<DatabaseBloc, DatabaseState>(
          listenWhen: (previous, current) {
            return previous.ghenetworkStatus != current.ghenetworkStatus;
          },
          listener: (context, state) {
            if (!mounted) return;
            if (state.ghenetworkStatus != surveyBloc.state.ghenetworkStatus) {
              context.flow<SurveyState>().complete();
            }
          },
          child: Scaffold(
            backgroundColor: ToolUtils.whiteColor,
            appBar: HeAppBar(
              course: _course.fullname,
              appbarwidget: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      const MenuItemHe()
                          .showExitConfirmationDialog(context)
                          .then((value) {
                        if (value) {
                          context.flow<SurveyState>().complete();
                        }
                      });
                    },
                  );
                },
              ),
              transparentBackground: false,
            ),
            body: Center(child: subWidget),
          ),
        ),
      ),
    ];
  }
}
