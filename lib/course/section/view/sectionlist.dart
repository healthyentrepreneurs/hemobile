import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/course/view/bookquiz_page.dart';
import 'package:he_api/he_api.dart';

import 'sectioncard.dart';

class SectionList extends StatelessWidget {
  final Subscription course;
  final List<Section?> sections;
  const SectionList({
    Key? key,
    required this.course,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sectionBloc = BlocProvider.of<SectionBloc>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(20),
            physics: const ClampingScrollPhysics(),
            itemCount: sections.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.6),
            ),
            itemBuilder: (BuildContext context, int index) {
              var section = sections[index]!;
              return GestureDetector(
                key: ValueKey(section.id),
                child: SectionCard(
                  sectionName: section.name!,
                  imageUrl: course.imageUrlSmall!,
                ),
                onTap: () {
                  sectionBloc.add(BookQuizSelected(
                    course.id.toString(),
                    section,
                  ));
                  Navigator.push(
                    context,
                    BookQuizPage.route(
                      sectionName: section.name!,
                      courseId: course.id.toString(),
                      sectionSection: section.id.toString(),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
