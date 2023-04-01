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
import 'he_webviewwidget.dart';

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
  _SurveyPageBrowser createState() => _SurveyPageBrowser();
}

class _SurveyPageBrowser extends State<SurveyPageBrowser> {
  @override
  Widget build(BuildContext context) {
    final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    final surveyBloc = BlocProvider.of<SurveyBloc>(context);
    Subscription course = databasebloc.state.gselectedsubscription!;
    return BlocBuilder<SurveyBloc, SurveyState>(
      builder: (context, state) {
        if (state == const SurveyState.loading()) {
          debugPrint("Loading-Still A");
          surveyBloc.add(SurveyFetched(
              '${course.id}', databasebloc.state.ghenetworkStatus));
        }
        return FlowBuilder<SurveyState>(
          state: context.select((SurveyBloc surveyBloc) => surveyBloc.state),
          onGeneratePages: (SurveyState state, List<Page<dynamic>> pages) {
            Widget subWidget;
            if (state == const SurveyState.loading()) {
              debugPrint("Loading-Still");
              subWidget = const StateLoadingHe().loadingDataSpink();
              surveyBloc.add(SurveyFetched(
                  '${course.id}', databasebloc.state.ghenetworkStatus));
            } else if (state.error != null) {
              subWidget =
                  const StateLoadingHe().errorWithStackT(state.error!.message);
            } else if (state.gsurveyjson == null) {
              subWidget =
                  const StateLoadingHe().noDataFound('This Survey Is Empty');
            } else {
              subWidget = const HEWebViewWidget();
            }
            return [
              MaterialPage<void>(
                  child: Scaffold(
                backgroundColor: ToolUtils.whiteColor,
                appBar: AppBar(
                    title: Text(
                      course.fullname!,
                      style: const TextStyle(color: ToolUtils.mainPrimaryColor),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    centerTitle: true,
                    iconTheme:
                        const IconThemeData(color: ToolUtils.mainPrimaryColor),
                    leading: Builder(
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
                    )),
                body: Center(child: subWidget),
              )),
            ];
          },
        );
      },
    );
  }
}
