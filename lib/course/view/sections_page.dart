import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/course/course.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectsection.dart';
import 'package:he/objects/objectsubscription.dart';

class SectionsPage extends StatefulWidget {
  final ObjectSubscription course;
  const SectionsPage({Key? key, required this.course}) : super(key: key);
  @override
  _SectionsPageState createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('source_one_course_3').snapshots();
  @override
  Widget build(BuildContext context) {
    // widget.course
    String courseCollectionString =
        "source_one_course_" + widget.course.id.toString();
    var courseCollection =
        FirebaseFirestore.instance.collection(courseCollectionString);
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: ToolUtils.whiteColor,
      appBar: AppBar(
        title: Text(
          widget.course.fullname!,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SectionIcon()
                              .sectionTitle(widget.course.summaryCustome!),
                        ]
                        // ,
                        ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: courseCollection.snapshots(),
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
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.size,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.6),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var subCourse = snapshot.data!.docs[index].data();
                        ObjectSection datasection = ObjectSection.fromJson(
                            subCourse as Map<String, dynamic>);
                        var booksCollection = courseCollection
                            .doc(datasection.section.toString())
                            .collection("modulescollection");
                        // printOnlyDebug(
                        //     "Size Of Chapters ${booksCollection.}");
                        return GestureDetector(
                          child: _sectionCard(datasection),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      BookQuizPage(
                                          sectionname: datasection.name!,
                                          bookcollection: booksCollection)),
                            );
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
      //endDrawer: CustomDrawer(),
    );
  }

  Widget _sectionCard(ObjectSection section) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(
        children: [
          SectionIcon(photo: widget.course.imageUrlSmall),
          Flexible(
            child: Column(children: [
              Text(
                section.name!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
