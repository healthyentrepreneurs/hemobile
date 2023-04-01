import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he_api/he_api.dart';

import '../../../home/widgets/widgets.dart';
import 'sectionlist.dart';

class SectionsPage extends StatefulWidget {
  const SectionsPage({Key? key}) : super(key: key);

  @override
  _SectionsPageState createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  late Subscription _course;

  @override
  void initState() {
    super.initState();
    _course = context.read<DatabaseBloc>().state.gselectedsubscription!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionBloc, SectionState>(
        builder: (BuildContext context, SectionState state) {
      final sectionBloc = BlocProvider.of<SectionBloc>(context);
      final databasebloc = BlocProvider.of<DatabaseBloc>(context);
      Widget subWidget;
      if (state == const SectionState.loading()) {
        subWidget = const StateLoadingHe().loadingDataSpink();
        sectionBloc.add(SectionFetched(
            '${_course.id}', databasebloc.state.ghenetworkStatus));
      } else if (state.error != null) {
        subWidget =
            const StateLoadingHe().errorWithStackT(state.error!.message);
      } else if (state.glistofSections.isEmpty) {
        subWidget = const StateLoadingHe().noDataFound('You have no Sections');
      } else {
        subWidget = SectionList(
          course: _course,
          sections: state.glistofSections,
        );
      }
      return Scaffold(
        // resizeToAvoidBottomInset: true,
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
      );
    });
  }
}
