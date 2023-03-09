import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/course/course.dart';
import 'package:he/coursedetail/coursedetail.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectbookcontent.dart';
import 'package:he/objects/objectbookquiz.dart';
import 'package:he/objects/objectquizcontent.dart';
import 'package:he/quiz/quiz.dart';

class BookQuizPage extends StatelessWidget {
  const BookQuizPage(
      {Key? key,
      required CollectionReference<Map<String, dynamic>> bookcollection,
      required String sectionname})
      : _bookcollection = bookcollection,
        _sectionname = sectionname,
        super(key: key);
  final CollectionReference<Map<String, dynamic>> _bookcollection;
  final String _sectionname;
  @override
  Widget build(BuildContext context) {
    // final _booksStream = _bookcollection.snapshots();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _bookcollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                if (snapshot.hasData) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      // ignore: unnecessary_null_comparison
                      itemCount: snapshot.data!.size,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var _datamodule = snapshot.data!.docs[index].data();
                        // var _module = _datamodule as Map<String, dynamic>;
                        ObjectBookQuiz _bookquiz = ObjectBookQuiz.fromJson(
                            _datamodule as Map<String, dynamic>);
                        return GestureDetector(
                          child: _bookQuizModuleCard(_bookquiz, context),
                          onTap: () {
                            if (_bookquiz.modname == "book") {
                              var _chapterCollection = _bookcollection
                                  .doc(_bookquiz.contextid.toString())
                                  .collection("contentscollection");
                              // List<ObjectBookContent> bookContent = [];
                              // _chapterCollection
                              //     .orderBy("id")
                              //     .get()
                              //     .then((QuerySnapshot querySnapshot) {
                              //   for (var doc in querySnapshot.docs) {
                              //     bookContent.add(ObjectBookContent.fromJson(
                              //         doc.data()! as Map<String, dynamic>));
                              //   }
                              // });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          BookChapters(
                                            bookContent: contentPerBook(
                                                _chapterCollection),
                                            book: _bookquiz,
                                          )));
                            }
                            if (_bookquiz.modname == "quiz") {
                              final _quizArray = objectQuizContentFromJson(
                                  _bookquiz.customdata!);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          QuizPage(
                                            title: _bookquiz.name!,
                                            quizArray: _quizArray,
                                          )));
                              // printOnlyDebug("quiz Clicked ${quiz.first.nextpage}");
                            }
                          },
                        );
                      });
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> contentPerBook(
      CollectionReference<Map<String, dynamic>> chapterCollection) async {
    // List<ObjectBookContent> bookContent = [];
    var collectionOfDoc = await chapterCollection.orderBy("id").get();
    return collectionOfDoc;
    // for (var element in collectionOfDoc.docs) {}
    // chapterCollection
    //     .orderBy("id")
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   for (var doc in querySnapshot.docs) {
    //     bookContent.add(ObjectBookContent.fromJson(
    //         doc.data()! as Map<String, dynamic>));
    //   }
    // });
  }

  Future<void> readContentFile(List<ObjectBookContent> coursePagerList) async {}
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
