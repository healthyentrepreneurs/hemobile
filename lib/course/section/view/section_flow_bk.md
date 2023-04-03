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
  void handleStateChange(BuildContext context, DatabaseState state) {
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
      MaterialPage<void>(
          child: NetworkStatusListener(
            onStateChange: handleStateChange,
            child: const SectionsPage(),
          ),
          name: '/sectionlist'),
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
      MaterialPage<void>(
          child: NetworkStatusListener(
            onStateChange: handleStateChange,
            child: const SectionsPage(),
          ),
          name: '/sectionlist')
    ];
  }
}

class SectionsFlow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final databaseBloc = BlocProvider.of<DatabaseBloc>(context);
    // final sectionBloc = BlocProvider.of<SectionBloc>(context);
    return FlowBuilder<SectionState>(
      state: context.select((SectionBloc sectionBloc) => sectionBloc.state),
      onGeneratePages: (SectionState state, List<Page<dynamic>> pages) {
        final course = databaseBloc.state.gselectedsubscription!;
        return onGenerateSectionPages(course, state, context);
      },
    );
  }
}
