import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/course/course.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/coursedetail/view/book_chapters.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/hfive/hfive.dart';
import 'package:he_api/he_api.dart';

import '../../home/widgets/widgets.dart';
//Step 3 Joash
class BookQuizPage extends StatelessWidget {
  const BookQuizPage({
    Key? key,
    required String sectionName,
    required String courseId,
    required String sectionId,
    required String sectionSection,
  })  : _sectionname = sectionName,
        _courseid = courseId,
        _sectionId = sectionId,
        _sectionsection = sectionSection,
        super(key: key);
  final String _sectionname;
  final String _courseid;
  final String _sectionsection;
  final String _sectionId;

  static Route<void> route(
      {required String section_name,
      required String courseId,
      required String sectionId,
      required String section_section}) {
    return MaterialPageRoute<void>(
      builder: (_) => BookQuizPage(
        sectionName: section_name,
        courseId: courseId,
        sectionId: sectionId,
        sectionSection: section_section,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolUtils.mainBgColor,
      appBar: HeAppBar(
        course: _sectionname,
        appbarwidget: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                const MenuItemHe()
                    .showExitConfirmationDialog(context)
                    .then((value) {
                  if (value) {
                    BlocProvider.of<SectionBloc>(context)
                        .add(const BookQuizDeselected());
                    // context.flow<SectionState>().complete();
                  }
                });
              },
            );
          },
        ),
        transparentBackground: true,
      ),
      body: BlocConsumer<SectionBloc, SectionState>(
        listener: (context, state) {
          if (state.glistBookQuiz.isEmpty) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final sectionBloc = BlocProvider.of<SectionBloc>(context);
          final userId =
              context.select((AuthenticationBloc bloc) => bloc.state.user).id;
          List<BookQuiz?> _listBookQuiz = state.glistBookQuiz;
          // debugPrint(
          //     'WHATSHERE ${_listBookQuiz.map((bookQuiz) => bookQuiz?.toJson().toString()).join('\n')}');
          return GridView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _listBookQuiz.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                BookQuiz _bookquiz = _listBookQuiz[index]!;
                //Start Here @phila one
                return GestureDetector(
                  child: _bookQuizModuleCard(_bookquiz, context),
                  onTap: () {
                    if (_bookquiz.modname == "book") {
                      sectionBloc.add(BookChapterSelected(_courseid, _sectionId,
                          _sectionsection, _bookquiz, index));
                      Navigator.push(
                        context,
                        BookChapters.route(
                          userId: userId.toString(),
                          book: _bookquiz,
                          courseId: _courseid,
                        ),
                      );
                    }
                    if (_bookquiz.modname == "h5pactivity") {
                      final HfiveContent hfive_content = HfiveContent.fromJson(
                          jsonDecode(_bookquiz.customdata!));
                      // final _quizArray =
                      //     objectQuizContentFromJson(_bookquiz.customdata!);
                      // debugPrint("MAMA-PHILA ${hfive_content.toJson()}");
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => HfivePage(
                                    contextid: _bookquiz.contextid!,
                                    title: _bookquiz.name!,
                                    hfivecontent: hfive_content,
                                  )));
                    }
                  },
                );
              });
        },
      ),
    );
  }

  Widget _bookQuizModuleCard(BookQuiz bookQuizModule, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.21,
        width: MediaQuery.of(context).size.width * 0.43,
        decoration: BoxDecoration(
            color: ToolUtils.mainPrimaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                // offset: const Offset(0, 3),
              ),
            ]),
        child: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            bookQuizModule.modname == "book"
                ? const Text('Book')
                : const Text('Interactive'),
            // const SectionIcon().bookIcon(bookQuizModule.modicon!)
            BookIcon(icon: bookQuizModule.modicon!),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 5.0, right: 5.0),
              child: Text(
                "${bookQuizModule.name}",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
