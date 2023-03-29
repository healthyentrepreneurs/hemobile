import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/course.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/coursedetail/view/book_chapters.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectquizcontent.dart';
import 'package:he/quiz/quiz.dart';
import 'package:he_api/he_api.dart';

// import '../../objects/objectbookquiz.dart';

class BookQuizPage extends StatelessWidget {
  const BookQuizPage(
      {Key? key,
      required String sectionName,
      required String courseId,
      required String sectionSection})
      : _sectionname = sectionName,
        _courseid = courseId,
        _sectionsection = sectionSection,
        super(key: key);
  final String _sectionname;
  final String _courseid;
  final String _sectionsection;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolUtils.mainBgColor,
      appBar: AppBar(
        title: Text(
          _sectionname,
          style: const TextStyle(color: ToolUtils.mainPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
      ),
      body: BlocBuilder<SectionBloc, SectionState>(
        buildWhen: (previous, current) {
          var _one_listbook_quiz = previous.glistBookQuiz
              .map((bookquiz) => bookquiz?.toJson() ?? 'null')
              .join(', ');
          var _two_listbook_quiz = current.glistBookQuiz
              .map((bookquiz) => bookquiz?.toJson() ?? 'null')
              .join(', ');
          var rebuild = _one_listbook_quiz != _two_listbook_quiz;
          // return  previous.glistBookQuiz != current.glistBookQuiz;
          return rebuild;
        },
        builder: (context, state) {
          final sectionBloc = BlocProvider.of<SectionBloc>(context);
          List<BookQuiz?> _listBookQuiz = state.glistBookQuiz;
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
                return GestureDetector(
                  child: _bookQuizModuleCard(_bookquiz, context),
                  onTap: () {
                    if (_bookquiz.modname == "book") {
                      sectionBloc.add(BookChapterSelected(
                          _courseid,
                          _sectionsection,
                          _bookquiz.contextid.toString(),
                          index));
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => BookChapters(
                                    book: _bookquiz,
                                    courseId: _courseid,
                                  )));
                    }
                    if (_bookquiz.modname == "quiz") {
                      final _quizArray =
                          objectQuizContentFromJson(_bookquiz.customdata!);
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => QuizPage(
                                    title: _bookquiz.name!,
                                    quizArray: _quizArray,
                                  )));
                      // printOnlyDebug("quiz Clicked ${quiz.first.nextpage}");
                    }
                  },
                );
              });
          // debugPrint("DataHereOwi ${state.glistBookQuiz.toString()}");
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            bookQuizModule.modname == "book"
                ? const Text('Book')
                : const Text('Quiz'),
            const SectionIcon().bookIcon(bookQuizModule.modicon!),
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
