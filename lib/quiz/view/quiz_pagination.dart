import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/helper/toolutils.dart';

class QuizPagination extends StatefulWidget {
  const QuizPagination(
      {Key? key,
      this.webCtrl,
      required this.pageCtrl,
      required this.itemCount,
      required this.activeIndex})
      : assert(activeIndex >= 0),
        assert(activeIndex < itemCount),
        super(key: key);
  final InAppWebViewController? webCtrl;
  final int itemCount;
  final int activeIndex;
  final PageController pageCtrl;
  @override
  _QuizPagination createState() => _QuizPagination();
}

class _QuizPagination extends State<QuizPagination> {
// class QuizPagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: _actionState(),
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  _actionState() {
    List<Widget> children;
    int indexedCurrent = widget.itemCount - 1;
    if (widget.itemCount == 1) {
      children = <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width / 1.41),
        ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
            child: const Text('Submit'),
            onPressed: () {
              checkJavaScript();
            })
      ];
      return children;
    } else if (widget.activeIndex == indexedCurrent) {
      children = <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          child: const Text('Previous'),
          onPressed: () {
            int p = widget.pageCtrl.page!.toInt();
            widget.pageCtrl.jumpToPage(p - 1);
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width / 2.3),
        //Container(width: 15.0,)
        ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
            child: const Text('Submit'),
            onPressed: () {
              checkJavaScript();
            })
      ];
      return children;
    } else if (widget.activeIndex == 0) {
      children = <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width / 1.35),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ToolUtils.colorBlueOne),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          child: const Text('Next'),
          onPressed: () {
            int p = widget.pageCtrl.page!.toInt();
            widget.pageCtrl.jumpToPage(p + 1);
            // pageCtrl.animateTo(MediaQuery.of(context).size.width,
            //     duration: const Duration(seconds: 1), curve: Curves.easeIn);
          },
        ),
      ];
      // debugPrint("Start of Quiz Babe");
      return children;
    } else {
      children = <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          child: const Text('Previous'),
          onPressed: () {
            int p = widget.pageCtrl.page!.toInt();
            widget.pageCtrl.jumpToPage(p - 1);
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width / 2.1),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          child: const Text('Next'),
          onPressed: () {
            int p = widget.pageCtrl.page!.toInt();
            widget.pageCtrl.jumpToPage(p + 1);
          },
        ),
      ];
      // debugPrint("Ride Babe of Quiz Babe");
      return children;
    }
  }

  Future<void> checkJavaScript() async {
    // var result = nwebCtrl.evaluateJavascript(source: "1 + 1");
    // // var result = await webctrl?.evaluateJavascript(source: "1 + 1");
    // debugPrint("What is here ? $result");
  }
}
