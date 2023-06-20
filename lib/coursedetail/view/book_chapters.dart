import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he_api/he_api.dart';

import '../../course/section/bloc/section_bloc.dart';
import '../../home/widgets/widgets.dart';
import '../widgets/dot_pagination.dart';
import 'chapter_page.dart';

class BookChapters extends StatefulWidget {
  final BookQuiz? book;
  final String courseId;
  final String userId;
  const BookChapters(
      {Key? key, this.book, required this.courseId, required this.userId})
      : super(key: key);
  static Route<void> route(
      {required BookQuiz book,
      required String courseId,
      required String userId}) {
    return MaterialPageRoute<void>(
      builder: (_) => BookChapters(
        userId: userId,
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
  late SectionBloc _sectionBloc;
  late List<ContentStructure> _coursePagerList;
  bool _firstPagePrinted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BookQuiz book = widget.book!;
    _sectionBloc = BlocProvider.of<SectionBloc>(context);
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
          initializeCoursePagerList(_bookContent);
          //Start Here @phila two
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
                      courseModule: widget.book,
                    );
                  },
                  onPageChanged: (i) {
                    setState(() {
                      _currentPage = i;
                    });
                    saveChapterDetails(i);
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

  void saveChapterDetails(int i) {
    var courseId = widget.courseId;
    var chapterId = _coursePagerList[i].chapterId;
    var isPending = true;
    var bookId = widget.book!.instance;
    var userId = widget.userId;
    debugPrint(
        'Adding Chapter .. Mama $courseId $chapterId $isPending $bookId $userId $i \n');
    _sectionBloc
        .add(AddBookView(bookId.toString(), chapterId, courseId, userId, true));
    debugPrint('What\'sID ${_sectionBloc.state.bookSavedId} \n');
  }

  void initializeCoursePagerList(List<BookContent> bookContent) {
    _coursePagerList =
        createCoursePagerFromStructure(bookContent.first.content!);
    if (!_firstPagePrinted) {
      _firstPagePrinted = true;
      saveChapterDetails(0);
    }
  }

  //Create the Skill Card
  List<ContentStructure> createCoursePagerFromStructure(String content) {
    try {
      var courseJsonList = jsonDecode(content) as List;
      List<ContentStructure> contentArrayField = [];
      for (var i = 0; i < courseJsonList.length; i++) {
        var c = courseJsonList[i];
        contentArrayField.add(ContentStructure.fromJson(c));
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
