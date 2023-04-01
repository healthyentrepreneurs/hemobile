import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:he_api/he_api.dart';

import '../../home/home.dart';
import '../../objects/blocs/hedata/bloc/database_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final databaseBloc = BlocProvider.of<DatabaseBloc>(context);
    final surveyBloc = BlocProvider.of<SurveyBloc>(context);

    _course = databaseBloc.state.gselectedsubscription!;

    return BlocBuilder<SurveyBloc, SurveyState>(
      builder: (context, state) {
        if (state == const SurveyState.loading()) {
          _fetchSurvey(surveyBloc, databaseBloc);
        }
        return FlowBuilder<SurveyState>(
          state: context.select((SurveyBloc surveyBloc) => surveyBloc.state),
          onGeneratePages: _onGeneratePages,
        );
      },
    );
  }

  void _fetchSurvey(SurveyBloc surveyBloc, DatabaseBloc databaseBloc) {
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
      subWidget = const StateLoadingHe().loadingDataSpink();
      _fetchSurvey(
        BlocProvider.of<SurveyBloc>(context),
        BlocProvider.of<DatabaseBloc>(context),
      );
    } else if (state.error != null) {
      subWidget = const StateLoadingHe().errorWithStackT(state.error!.message);
    } else if (state.gsurveyjson == null) {
      subWidget = const StateLoadingHe().noDataFound('This Survey Is Empty');
    } else {
      subWidget = const SurveyWebViewWidget();
    }

    return [
      MaterialPage<void>(
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
    ];
  }

}
