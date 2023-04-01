import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectcontentstructure.dart';
import 'package:he_api/he_api.dart';

import '../../course/section/bloc/section_bloc.dart';
import '../widgets/dot_pagination.dart';
import 'chapter_page.dart';

class BookChapters extends StatefulWidget {
  final BookQuiz? book;
  final String courseId;
  const BookChapters({Key? key, this.book, required this.courseId})
      : super(key: key);
  @override
  _BookChapState createState() => _BookChapState();
}

class _BookChapState extends State<BookChapters> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    // var _chapterStream = widget.chapterCollection.orderBy("id").snapshots();
    BookQuiz book = widget.book!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.name!,
          style: const TextStyle(color: ToolUtils.mainPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
      ),
      body: BlocBuilder<SectionBloc, SectionState>(
          buildWhen: (previous, current) {
            var rebuild =
            listEquals(previous.glistBookChapters, current.glistBookChapters);
            // var rebuild = previous.glistBookChapters != current.glistBookChapters;
            debugPrint("BookChapters@rebuild@buildWhen $rebuild");
            // return previous.glistBookChapters != current.glistBookChapters;
            return rebuild;
          }, builder: (context, state) {
        // final sectionBloc = BlocProvider.of<SectionBloc>(context);
        List<BookContent> _bookContent = state.glistBookChapters;
        var _coursePagerList =
        createCoursePagerFromStructure(_bookContent.first.content!);
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: PageView.builder(
                itemCount: _coursePagerList.length,
                // controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ChapterDisplay(
                    courseId: widget.courseId,
                    coursePage: _coursePagerList[index],
                    courseContents: _bookContent,
                  );
                },
                onPageChanged: (i) {
                  setState(() {
                    _currentPage = i;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DotPagination(
                itemCount: _coursePagerList.length,
                activeIndex: _currentPage,
              ),
            )
          ],
        );
      }),
    );
  }

  //Create the Skill Card
  List<ObjectContentStructure> createCoursePagerFromStructure(String content) {
    try {
      var courseJsonList = jsonDecode(content) as List;
      List<ObjectContentStructure> contentArrayField = [];
      for (var i = 0; i < courseJsonList.length; i++) {
        var c = courseJsonList[i];
        contentArrayField.add(ObjectContentStructure.fromJson(c));
      }
      // printOnlyDebug(
      //     "Check ${contentArrayField.first.chapterId} and ${contentArrayField.first.href}");
      return contentArrayField;
    } catch (e) {
      debugPrint("content module_book \n $e");
      return List.empty();
    }
  }
}
