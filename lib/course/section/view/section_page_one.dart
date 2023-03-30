import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/course/section/view/view.dart';
import 'package:he/course/view/bookquiz_page.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/home/home.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he_api/he_api.dart';

import '../../../helper/toolutils.dart';
import '../../../objects/blocs/hedata/bloc/database_bloc.dart';
import '../../widgets/sectionicon.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage({Key? key}) : super(key: key);
  static Page page() => const MaterialPage<void>(child: SectionsPage());
  @override
  Widget build(BuildContext context) {
    Subscription course =
        BlocProvider.of<DatabaseBloc>(context).state.gselectedsubscription!;
// final heNetworkState =
//     context.select((HenetworkBloc bloc) => bloc.state.status);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              const MenuItemHe()
                  .showExitConfirmationDialog(context)
                  .then((value) {
                if (value) {
                  Navigator.of(context).push(HomePage.route());
                  final sectionState = context.read<SectionBloc>().state;
                  if (sectionState.error != null) {
                    BlocProvider.of<DatabaseBloc>(context)
                        .add(const DatabaseSubDeSelected());
                    BlocProvider.of<SectionBloc>(context).add(
                        SectionFetchedError(
                            context.read<HenetworkBloc>().state.status));
                  } else {
                    context
                        .flow<NavigationState>()
                        .update((_) => NavigationState.mainScaffold);
                    BlocProvider.of<SectionBloc>(context)
                        .add(const SectionDeFetched());
                    BlocProvider.of<DatabaseBloc>(context)
                        .add(const DatabaseSubDeSelected());
                  }
                }
              });
            },
          )),
      body: _buildBody(context,course),
//endDrawer: CustomDrawer(),
    );
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
          return const Center(child: SpinKitThreeBounce(color: Colors.blue));
        }
      },
    );
  }
  Widget _buildBody(BuildContext context, Subscription course) {
    return SingleChildScrollView(
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
          BlocBuilder<SectionBloc, SectionState>(builder: (context, state) {
            if (state.error != null) {
              return const StateLoadingHe()
                  .errorWithStackT(state.error!.message);
            } else {
              var _sectionBloc = context.read<SectionBloc>();
              var _heNetwork = context.read<HenetworkBloc>().state;
              if (state.ghenetworkStatus == HenetworkStatus.loading) {
                debugPrint('SectionsPage@HenetworkStatus.loading');
                _sectionBloc.add(
                    SectionFetched(course.id.toString(), _heNetwork.gstatus));
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
                        final sectionBloc =
                        BlocProvider.of<SectionBloc>(context);
                        return GestureDetector(
                          child: SectionCard(
                              sectionName: section.name!,
                              imageUrl: course.imageUrlSmall!),
                          onTap: () {
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
    );
  }
}
