import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/course/section/view/view.dart';
import 'package:he/home/home.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he_api/he_api.dart';

import '../../../helper/toolutils.dart';
import '../../../objects/blocs/hedata/bloc/database_bloc.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage._({Key? key}) : super(key: key);
  // static Page page() => const MaterialPage<void>(child: SectionsPage());
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => SectionBloc(repository: getIt<DatabaseRepository>()),
        child: const SectionsPage._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionBloc = BlocProvider.of<SectionBloc>(context);
    final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    Subscription course = databasebloc.state.gselectedsubscription!;
    return BlocBuilder<SectionBloc, SectionState>(builder: (context, state) {
      // if (state == const SectionState.loading()) {
      //   debugPrint("Loading-Still A");
      //   sectionBloc.add(
      //     SectionFetched('${course.id}', databasebloc.state.ghenetworkStatus),
      //   );
      // }
      return FlowBuilder<SectionState>(
        state: context.select((SectionBloc sectionBloc) => sectionBloc.state),
        onGeneratePages: (SectionState state, List<Page<dynamic>> pages) {
          Widget subWidget;
          if (state == const SectionState.loading()) {
            debugPrint("Loading-Still");
            subWidget = const StateLoadingHe().loadingDataSpink();
            sectionBloc.add(SectionFetched(
                '${course.id}', databasebloc.state.ghenetworkStatus));
          } else if (state.error != null) {
            subWidget =
                const StateLoadingHe().errorWithStackT(state.error!.message);
          } else if (state.glistofSections.isEmpty) {
            // _buildEmptySectionsWidget
            subWidget =
                const StateLoadingHe().noDataFound('You have no Sections');
            ;
          } else {
            subWidget = SectionList(
              course: databasebloc.state.gselectedsubscription!,
              sections: state.glistofSections,
            );
          }

          return [
            MaterialPage<void>(
                child: Scaffold(
              // resizeToAvoidBottomInset: true,
              backgroundColor: ToolUtils.whiteColor,
              appBar: HeAppBar(
                course: course.fullname,
                appbarwidget: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        const MenuItemHe()
                            .showExitConfirmationDialog(context)
                            .then((value) {
                          if (value) {
                            context.flow<SectionState>().complete();
                          }
                        });
                      },
                    );
                  },
                ),
                transparentBackground: true,
              ),
              body: subWidget,
              //endDrawer: CustomDrawer(),
            )),
          ];
        },
      );
    });
  }
}
