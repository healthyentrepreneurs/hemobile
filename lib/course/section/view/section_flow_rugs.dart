import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/coursedetail/view/book_chapters.dart';
import 'package:he_api/he_api.dart';

import '../../../objects/blocs/hedata/bloc/database_bloc.dart';
import '../../view/bookquiz_page.dart';
import 'section_page.dart';

List<Page<dynamic>> onGenerateSectionPages(
  Subscription course,
  SectionState state,
) {
  if (state.glistBookChapters.isNotEmpty && state.bookquiz != null) {
    return [
      const MaterialPage<void>(child: SectionsPage(), name: '/sectionlist'),
      MaterialPage<void>(
        child: BookChapters(
          book: state.bookquiz,
          courseId: course.id.toString(),
        ),
        name: '/bookChapters',
      ),
    ];
  }
  if (state.glistBookQuiz.isNotEmpty && state.section != null) {
    return [
      const MaterialPage<void>(child: SectionsPage(), name: '/sectionlist'),
      MaterialPage<void>(
        child: BookQuizPage(
          sectionName: state.section!.name!,
          courseId: course.id.toString(),
          sectionSection: state.section!.section.toString(),
        ),
        name: '/bookQuiz',
      ),
    ];
  } else {
    return [
      const MaterialPage<void>(child: SectionsPage(), name: '/sectionlist')
    ];
  }
}

class SectionsFlow extends StatefulWidget {
  const SectionsFlow._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const SectionsFlow._(),
    );
  }

  @override
  _SectionsFlowState createState() => _SectionsFlowState();
}

class _SectionsFlowState extends State<SectionsFlow> {
  late final SectionBloc _sectionBloc;
  late final DatabaseBloc _databaseBloc;

  @override
  void initState() {
    super.initState();
    _sectionBloc = BlocProvider.of<SectionBloc>(context);
    _databaseBloc = BlocProvider.of<DatabaseBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseBloc, DatabaseState>(
      listenWhen: (previous, current) {
        return previous.ghenetworkStatus != current.ghenetworkStatus;
      },
      listener: (context, state) {
        if (state.ghenetworkStatus != _sectionBloc.state.ghenetworkStatus) {
          context.flow<SectionState>().complete();
        }
      },
      child: FlowBuilder<SectionState>(
        state: _sectionBloc.state,
        onGeneratePages: (SectionState state, List<Page<dynamic>> pages) {
          final course = _databaseBloc.state.gselectedsubscription!;
          return onGenerateSectionPages(course, state);
        },
      ),
    );
  }
}
