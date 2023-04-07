import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/coursedetail/view/book_chapters.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he_api/he_api.dart';

import '../../../objects/blocs/hedata/bloc/database_bloc.dart';
import '../../view/bookquiz_page.dart';
import 'network_status_listener.dart';
import 'section_page.dart';

List<Page<dynamic>> onGenerateSectionPages(
    Subscription course, SectionState state, BuildContext context) {
  Future<void> handleStateChange(
      BuildContext context, DatabaseState state) async {
    final sectionBloc = BlocProvider.of<SectionBloc>(context);
    if (state.ghenetworkStatus != sectionBloc.state.ghenetworkStatus) {
      context.flow<SectionState>().complete();
    }
  }

  if (state.glistBookChapters.isNotEmpty && state.bookquiz != null) {
    return [
      MaterialPage<void>(
          child: NetworkStatusListener(
            onStateChange: handleStateChange,
            child: const SectionsPage(),
          ),
          name: '/sectionlist'),
      MaterialPage<void>(
        child: NetworkStatusListener(
          onStateChange: handleStateChange,
          child: BookChapters(
            book: state.bookquiz,
            courseId: course.id.toString(),
          ),
        ),
        name: '/bookChapters',
      ),
    ];
  }
  if (state.glistBookQuiz.isNotEmpty && state.section != null) {
    return [
      MaterialPage<void>(
          child: NetworkStatusListener(
            onStateChange: handleStateChange,
            child: const SectionsPage(),
          ),
          name: '/sectionlist'),
      MaterialPage<void>(
        child: NetworkStatusListener(
          onStateChange: handleStateChange,
          child: BookQuizPage(
            sectionName: state.section!.name!,
            courseId: course.id.toString(),
            sectionSection: state.section!.section.toString(),
          ),
        ),
        name: '/bookQuiz',
      ),
    ];
  } else {
    return [
      MaterialPage<void>(
          child: NetworkStatusListener(
            onStateChange: handleStateChange,
            child: const SectionsPage(),
          ),
          name: '/sectionlist')
    ];
  }
}

class SectionsFlow extends StatefulWidget {
  const SectionsFlow._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => SectionBloc(repository: getIt<DatabaseRepository>()),
        child: const SectionsFlow._(),
      ),
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
    return FlowBuilder<SectionState>(
      state: _sectionBloc.state,
      onGeneratePages: (SectionState state, List<Page<dynamic>> pages) {
        final course = _databaseBloc.state.gselectedsubscription!;
        return onGenerateSectionPages(course, state, context);
      },
    );
  }
}
