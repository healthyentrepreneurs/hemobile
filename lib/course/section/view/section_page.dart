import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/course/section/view/view.dart';
import 'package:he/course/view/bookquiz_page.dart';
import 'package:he/home/home.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he_api/he_api.dart';

import '../../../helper/toolutils.dart';
import '../../../objects/blocs/hedata/bloc/database_bloc.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage._({Key? key}) : super(key: key);
  // const SectionsPage({Key? key}) : super(key: key);
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
      if (state == const SectionState.loading()) {
        debugPrint("Loading-Still A");
        sectionBloc.add(
          SectionFetched('${course.id}', databasebloc.state.ghenetworkStatus),
        );
      }
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
            subWidget = _buildEmptySectionsWidget();
          } else {
            subWidget = SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    physics: const ClampingScrollPhysics(),
                    itemCount: state.glistofSections.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.6),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var section = state.glistofSections[index]!;
                      final sectionBloc = BlocProvider.of<SectionBloc>(context);
                      return GestureDetector(
                        key: ValueKey(section.section),
                        child: SectionCard(
                            sectionName: section.name!,
                            imageUrl: course.imageUrlSmall!),
                        onTap: () {
                          sectionBloc.add(BookQuizSelected(course.id.toString(),
                              section.section.toString()));
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) => BookQuizPage(
                                    sectionName: section.name!,
                                    courseId: course.id.toString(),
                                    sectionSection:
                                        section.section.toString())),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            );
          }

          return [
            MaterialPage<void>(
                child: Scaffold(
              // resizeToAvoidBottomInset: true,
              backgroundColor: ToolUtils.whiteColor,
              appBar: _buildAppBar(context, course),
              body: subWidget,
              //endDrawer: CustomDrawer(),
            )),
          ];
        },
      );
    });
  }

  Future<void> _wait(Duration duration) async {
    await Future.delayed(duration);
  }

  Widget _buildEmptySectionsWidget() {
    return FutureBuilder<void>(
      future: _wait(const Duration(seconds: 1)),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const StateLoadingHe().noDataFound('You have no Sections');
        } else {
          return const Center(
              child: SpinKitFadingCircle(color: Colors.blue, size: 20));
        }
      },
    );
  }

  _buildAppBar(BuildContext context, Subscription course) {
    return AppBar(
        title: Text(
          course.fullname!,
          style: const TextStyle(color: ToolUtils.mainPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
        leading: Builder(
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
        ));
  }
}
