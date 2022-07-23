import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/coursedetail/coursedetail.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectbookcontent.dart';
import 'package:he/objects/objectbookquiz.dart';
import 'package:he/objects/objectcontentstructure.dart';

class BookChapters extends StatefulWidget {
  final ObjectBookQuiz? book;
  final Future<QuerySnapshot<Map<String, dynamic>>>? bookContent;
  const BookChapters({Key? key, this.book, this.bookContent}) : super(key: key);
  // const BookChapters({Key? key, required ObjectBookQuiz book, required CollectionReference<Map<String, dynamic>> chapterCollection}) : super(key: key);
  @override
  _BookChapState createState() => _BookChapState();
}

class _BookChapState extends State<BookChapters> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    // var _chapterStream = widget.chapterCollection.orderBy("id").snapshots();
    ObjectBookQuiz book = widget.book!;
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
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: widget
                .bookContent, // a previously-obtained Future<String> or null
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                List<ObjectBookContent> bookContent = [];
                var docsCollection = snapshot.data;
                for (var doc in docsCollection!.docs) {
                  // var mama=doc.data() as Map<String, dynamic>;
                  bookContent.add(ObjectBookContent.fromJson(doc.data()));
                }
                var _coursePagerList =
                    createCoursePagerFromStructure(bookContent.first.content!);
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
                            coursePage: _coursePagerList[index],
                            courseContents: bookContent,
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
                      child: DotPagination(
                        itemCount: _coursePagerList.length,
                        activeIndex: _currentPage,
                      ),
                      alignment: Alignment.bottomCenter,
                    )
                  ],
                );
                // return MyPageView();
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ],
                  ),
                );
              }
            },
          )
        ],
      ),
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
      printOnlyDebug("content module_book \n $e");
      return List.empty();
    }
  }
}
