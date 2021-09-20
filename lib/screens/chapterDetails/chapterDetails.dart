import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/course_model.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/widgets/dot_pagination.dart';
import 'package:nl_health_app/widgets/dots_indicator_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'course_element_widget.dart';

class ChapterDetails extends StatefulWidget {
  // final CourseModule? courseModule;
  final dynamic courseModule;
  final Course? course;
  final FileSystemUtil? fileSystemUtil;

  ChapterDetails({this.courseModule, this.fileSystemUtil, this.course});

  @override
  _ChapterDetailsState createState() => _ChapterDetailsState();
}

class _ChapterDetailsState extends State<ChapterDetails> {
  late List<ContentStructure> _coursePagerList;
  late PageController _pageController;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    dynamic cMod = widget.courseModule!;
    //_coursePagerList = this.createCoursePagerFromStructure();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${cMod['Name']}",
            style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
        ),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.only(bottom: 85),
            child: PageView.builder(
              itemCount: _coursePagerList.length,
              itemBuilder: (context, index) {
                return CourseElementDisplay(
                  coursePage: _coursePagerList[index],
                  courseContents:
                      widget.courseModule['Contents'] as List<dynamic>,
                  courseModule: widget.courseModule,
                  course: widget.course,
                );
                //return bookHtmlPagerUi(index);
                //return coursePagerUi(contentObj);
              },
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (i){
                setState(() {
                  currentIndex = i;
                });
              },
            ),
          ),

          Align(
            child: DotPagination(
              itemCount: _coursePagerList.length,
              activeIndex: currentIndex,
            ),
            alignment: Alignment.bottomCenter,
          ),

         /* Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          int p = _pageController.page!.toInt();
                          if (p < _coursePagerList.length && (p - 1) >= 0) {
                            _pageController.jumpToPage(p - 1);
                          }
                        },
                        iconSize: 20,
                        icon: Icon(
                          FontAwesomeIcons.angleLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                  new Center(
                    child: new DotsIndicator(
                      controller: _pageController,
                      itemCount: _coursePagerList.length,
                      color: Theme.of(context).primaryColor,
                      onPageSelected: (int page) {
                        _pageController.animateToPage(
                          page,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                      },
                    ),
                  ),
                  Column(children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          int p = _pageController.page!.toInt();
                          if (p < _coursePagerList.length &&
                              (p + 1) != _coursePagerList.length) {
                            _pageController.jumpToPage(p + 1);
                          }
                        },
                        iconSize: 20,
                        icon: Icon(
                          FontAwesomeIcons.angleRight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),*/
        ]));
  }

  Widget coursePagerUi(ContentStructure contentObj, [int? index]) {
    return Scaffold(
      backgroundColor: ToolsUtilities.mainBgColor,
      body: ListView(children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 5, bottom: 20),
                child: Text(
                  contentObj.title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                    itemCount: 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return _videoCard();
                    }),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 20),
          child: Text(
            'PDF Files:',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Text(paragraphContent,
              style: TextStyle(color: Colors.black87, fontSize: 15)),
        )
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _coursePagerList = this.createCoursePagerFromStructure();
    contentText = [];
    this.readContentFile(_coursePagerList);
  } //Create the Skill Card

  Widget _videoCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 3),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://i.postimg.cc/G2wqwpwR/courseintroimage.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChapterDetails()));
                },
                icon: Icon(
                  FontAwesomeIcons.playCircle,
                  color: ToolsUtilities.whiteColor,
                  size: 50,
                ),
                label: Text(''))
          ],
        ),
      ),
    );
  }

  List<ContentStructure> createCoursePagerFromStructure() {
    try {
      var contentsList = widget.courseModule['Contents'];
      print("ccc ${contentsList!.length}");
      var index_ = contentsList.indexWhere((elm) => elm['Type'] == 'content');
      var courseJsonList = jsonDecode(contentsList[index_]['Content']) as List;
      List<ContentStructure> coursesObjs = [];

      for (var i = 0; i < courseJsonList.length; i++) {
        var c = courseJsonList[i];
        c['index'] = i;
        coursesObjs.add(ContentStructure.fromJson2(c, i));
      }
      return coursesObjs;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }


  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var privateToken = "";

  List<String> contentText = <String>[];
  List<PageItem> contentPages = <PageItem>[];

  Future<void> readContentFile(List<ContentStructure> coursePagerList) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      privateToken = preferences.getString("privatetoken")!;

      /*for (int x = 0; x < coursePagerList.length; x++) {
        contentText.add("");
      }*/
      //coursePagerList.sort((a, b) => a.index.compareTo(b.index));
      List<PageItem> cp = <PageItem>[];

      coursePagerList.forEach((e) async {
        //final fileUrl = 'https://app.healthyentrepreneurs.nl/webservice/pluginfile.php/78/mod_book/chapter/${e.href}?token=f84bf33b56e86a4664284d8a3dfb5280';
        final fileUrl = e.filefullpath;
        print(">>>File download link Index ${e.index} title ${e.title}");
        String contentTxt =
            await widget.fileSystemUtil!.readFileContentLink(fileUrl);
        cp.add(PageItem(contentTxt, e.index, e.title));
        // ignore: unnecessary_null_comparison
        if (contentText != null) {
          setState(() {
            contentText.add(contentTxt);
          });
        } else {
          contentText.removeAt(e.index);
        }
      });
      cp.sort((a, b) => a.index.compareTo(b.index));
      setState(() {
        contentPages = cp;
      });
    } catch (e) {
      print(e);
    }
  }
}

class PageItem {
  String contentText;
  late int index;
  late String title;

  PageItem(this.contentText, this.index, this.title);
}
