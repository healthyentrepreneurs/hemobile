import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:survey_module/single_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SurveyPageLoader extends StatefulWidget {
  final dynamic pages;

  const SurveyPageLoader({@required this.pages});

  @override
  _SurveyPageLoaderState createState() => _SurveyPageLoaderState();
}

class _SurveyPageLoaderState extends State<SurveyPageLoader> {
  dynamic response;

  PageController controller = PageController();
  List<Widget> _list = [];
  int _curr = 0;

  @override
  void initState() {
    super.initState();

    String title = widget.pages['title'] as String;
    widget.pages['pages'].forEach((v) {
      _list.add(SinglePage(text: title ?? "", pageItem: v));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      /*appBar: AppBar(
        backgroundColor: Colors.green,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Page: " + (_curr + 1).toString() + "/" + _list.length.toString(),
              textScaleFactor: 1.4,
            ),
          )
        ],
      )*/
      body: Stack(
        children: [
          PageView(
            children: _list,
            scrollDirection: Axis.horizontal,

            // reverse: true,
            // physics: BouncingScrollPhysics(),
            controller: controller,
            onPageChanged: (num) {
              setState(() {
                _curr = num;
              });
            },
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
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
                          int p = controller.page.toInt();
                          if (p < _list.length && (p - 1) >= 0) {
                            controller.jumpToPage(p - 1);
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
                          int p = controller.page.toInt();
                          if (p < _list.length &&
                              (p + 1) != _list.length) {
                            controller.jumpToPage(p + 1);
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
          )
        ],
      ),
    );
  }
}
