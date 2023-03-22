import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/course/section/view/sectioncard.dart';
import 'package:he/course/view/bookquiz_page.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he_api/he_api.dart';

import '../../../helper/toolutils.dart';
import '../../../home/widgets/widgets.dart';
import '../../../objects/blocs/hedata/bloc/database_bloc.dart';
import '../../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../../widgets/sectionicon.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage({Key? key}) : super(key: key);
  static Page page() => const MaterialPage<void>(child: SectionsPage());
  @override
  Widget build(BuildContext context) {
    Subscription course =
        BlocProvider.of<DatabaseBloc>(context).state.gselectedsubscription!;
    final sectionBloc = BlocProvider.of<SectionBloc>(context);
    final heNetworkState =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: ToolUtils.whiteColor,
      appBar: AppBar(
        title: Text(
          course.fullname!,
          style: const TextStyle(color: ToolUtils.mainPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SectionIcon()
                              .sectionTitle(course.summaryCustome!),
                        ]
                        // ,
                        ),
                  ),
                ],
              ),
            ),
            BlocBuilder<SectionBloc, SectionState>(
                buildWhen: (previous, current) {
              var _one_section = previous.glistofSections
                  .map((section) => section?.toJson() ?? 'null')
                  .join(', ');
              var _two_section = current.glistofSections
                  .map((section) => section?.toJson() ?? 'null')
                  .join(', ');
              var rebuild = _one_section != _two_section;
              var rebuildError = previous.error != current.error;
              if (previous.error == null && current.error != null) {
                sectionBloc.add(SectionFetchedError(
                    heNetworkState, const <Section>[], current.error));
              } else if (current.error == null && previous.error != null) {
                sectionBloc
                    .add(SectionFetched(course.id.toString(), heNetworkState));
              } else if (rebuild) {
                sectionBloc.add(SectionFetchedError(
                    heNetworkState, current.glistofSections, null));
              }
              debugPrint("BlocBuilder@SectionBloc@buildWhen --> $rebuild");
              return rebuildError || rebuild;
            }, builder: (context, state) {
              if (heNetworkState != state.ghenetworkStatus) {
                Navigator.pop(context);
                return const StateLoadingHe().loadingData();
              }
              if (state.error != null) {
                sectionBloc.add(SectionFetchedError(
                    heNetworkState, const <Section>[], state.error));
                return const StateLoadingHe()
                    .errorWithStackT(state.error!.message);
              } else {
                if (state.ghenetworkStatus == HenetworkStatus.loading) {
                  debugPrint('SectionsPage@HenetworkStatus.loading');
                  sectionBloc.add(
                      SectionFetched(course.id.toString(), heNetworkState));
                  return const StateLoadingHe().loadingData();
                } else {
                  if (state.glistofSections.isEmpty) {
                    return const StateLoadingHe()
                        .noDataFound('You have no Sections');
                  } else {
                    return GridView.builder(
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
                          return GestureDetector(
                            child: SectionCard(
                                sectionName: section.name!,
                                imageUrl: course.imageUrlSmall!),
                            onTap: () {
                              // if (heNetworkState ==
                              //     HenetworkStatus.noInternet) {
                              //   addBookSelectedStateOffline(context);
                              // } else if (heNetworkState ==
                              //     HenetworkStatus.wifiNetwork) {
                              //
                              // }
                              sectionBloc.add(BookQuizSelected(
                                  course.id.toString(),
                                  section.section.toString()));
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        BookQuizPage(
                                            sectionName: section.name!,
                                            courseId: course.id.toString(),
                                            sectionSection:
                                                section.section.toString())),
                              );
                            },
                          );
                        });
                  }
                }
              }
            })
          ],
        ),
      ),
      //endDrawer: CustomDrawer(),
    );
  }

  void addBookSelectedStateOffline(BuildContext context) {
    debugPrint("Offline Option");
  }
}
