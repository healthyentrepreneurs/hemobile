import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/course.dart';
import 'package:he/course/section/bloc/section_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he_api/he_api.dart';

class BookQuizPageOffline extends StatelessWidget {
  const BookQuizPageOffline(
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
    debugPrint("JejePaPa");
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 6.0, left: 5.0, right: 5.0),
            child: Text(
              "HAHHA",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
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
