import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/objects/objectcontentstructure.dart';
import 'package:he_api/he_api.dart';

import '../../course/section/bloc/section_bloc.dart';
import '../../home/widgets/widgets.dart';
import '../widgets/dot_pagination.dart';
import 'chapter_page.dart';

class BookChapters extends StatefulWidget {
  final BookQuiz? book;
  final String courseId;
  const BookChapters({Key? key, this.book, required this.courseId})
      : super(key: key);
  static Route<void> route({required BookQuiz book, required String courseId}) {
    return MaterialPageRoute<void>(
      builder: (_) => BookChapters(
        book: book,
        courseId: courseId,
      ),
    );
  }

  @override
  _BookChapState createState() => _BookChapState();
}

class _BookChapState extends State<BookChapters> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    BookQuiz book = widget.book!;
    return Scaffold(
      appBar: HeAppBar(
        course: book.name,
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
                        .add(const BookChapterDeSelected());
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
          // Njovu
          listener: (context, state) {
        if (state.glistBookChapters.isEmpty) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        // final sectionBloc = BlocProvider.of<SectionBloc>(context);
        if (state.glistBookChapters.isNotEmpty) {
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
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
