import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/course.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectquizcontent.dart';
import 'package:he/quiz/quiz.dart';

import '../../objects/objectbookquiz.dart';

class BookQuizPage extends StatelessWidget {
  const BookQuizPage({Key? key, required String sectionname})
      : _sectionname = sectionname,
        super(key: key);
  final String _sectionname;
  @override
  Widget build(BuildContext context) {
    // final dataBloc = BlocProvider.of<DatabaseBloc>(context);
    // final _booksStream = _bookcollection.snapshots();
    // debugPrint("Data Here ${dataBloc.state.glistBookQuiz.toString()}");
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
        builder: (context, state) {
          List<ObjectBookQuiz?> _listBookQuiz = state.glistBookQuiz;
          // print all _listBookQuiz using for loop
          return GridView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              // ignore: unnecessary_null_comparison
              itemCount: _listBookQuiz.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                // var _module = _datamodule as Map<String, dynamic>;
                ObjectBookQuiz _bookquiz = _listBookQuiz[index]!;
                return GestureDetector(
                  child: _bookQuizModuleCard(_bookquiz, context),
                  onTap: () {
                    if (_bookquiz.modname == "book") {
                      // var _chapterCollection = _bookcollection
                      //     .doc(_bookquiz.contextid.toString())
                      //     .collection("contentscollection");
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute<void>(
                      //         builder: (BuildContext context) =>
                      //             BookChapters(
                      //               bookContent: contentPerBook(
                      //                   _chapterCollection),
                      //               book: _bookquiz,
                      //             )));
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

  Widget _bookQuizModuleCard(
      ObjectBookQuiz bookQuizModule, BuildContext context) {
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
