import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/course/section/view/sectioncard.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he_api/he_api.dart';

import '../../../helper/toolutils.dart';
import '../../../home/widgets/widgets.dart';
import '../../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../../widgets/sectionicon.dart';

class SectionsPage extends StatelessWidget {
  final Subscription course;
  const SectionsPage({Key? key, required this.course}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final heNetworkState =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    debugPrint("COURSE IDS ${course.id}");
    final sectionBloc = BlocProvider.of<SectionBloc>(context);
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
            BlocListener<HenetworkBloc, HenetworkState>(
              listener: (context, state) {
                sectionBloc
                    .add(SectionFetched(course.id.toString(), state.gstatus));
              },
              child: BlocBuilder<SectionBloc, SectionState>(
                  buildWhen: (previous, current) =>
                      previous.glistofSections != current.glistofSections,
                  builder: (context, state) {
                    if (state.error != null) {
                      return const StateLoadingHe()
                          .errorWithStackT(state.error!.message);
                    } else {
                      if (state.ghenetworkStatus == HenetworkStatus.loading) {
                        debugPrint('SectionsPage@HenetworkStatus.loading');
                        sectionBloc.add(SectionFetched(
                            course.id.toString(), heNetworkState));
                        return const StateLoadingHe().loadingData();
                      } else {
                        debugPrint(
                            'SectionsPage@SectionBlocB  ${state.ghenetworkStatus}');
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 1.6),
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                var section = state.glistofSections[index]!;
                                return GestureDetector(
                                  child: SectionCard(
                                      sectionName: section.name!,
                                      imageUrl: course.imageUrlSmall!),
                                  onTap: () {},
                                );
                              });
                        }
                      }
                    }
                  }),
            )
          ],
        ),
      ),
      //endDrawer: CustomDrawer(),
    );
  }
}
