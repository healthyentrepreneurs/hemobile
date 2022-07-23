import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class QuizNav extends StatefulWidget {
  // currentKey = valCurrentPageId;
  // nextKey = valNextPageId;
  const QuizNav(
      {Key? key,
      this.controller,
      this.contentLength,
      this.previousKey,
      this.currentKey,
      this.nextKey})
      : super(key: key);
  final InAppWebViewController? controller;
  final dynamic previousKey;
  final dynamic contentLength;
  final dynamic currentKey;
  final dynamic nextKey;
  @override
  _QuizNav createState() => _QuizNav();
}

class _QuizNav extends State<QuizNav> {
  @override
  Widget build(BuildContext context) {
    debugPrint(
        "joash  length ${widget.contentLength} previous ${widget.previousKey} currentKey ${widget.currentKey} and nextKey ${widget.nextKey}");
    var controller = widget.controller;
    List<Widget> children;

    if (widget.contentLength == 1) {
      children = [
        ElevatedButton(
          child: const Icon(Icons.send),
          onPressed: () {
            checkThis();
            // controller?.goBack();
          },
        )
      ];
    } else {
      children = [
        ElevatedButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            controller?.goBack();
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            controller?.goForward();
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.send),
          onPressed: () {
            controller
                ?.evaluateJavascript(source: "1 + 1")
                .then((value) => {debugPrint("NYE $value")});
          },
        ),
      ];
    }
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Future<void> checkThis() async {
    var result = await widget.controller!.evaluateJavascript(
        source:
            """JSON.stringify(\$("form").find("input[name!=nextpageid][name!=currentpageid][name!=hashvalueid]").serializeArray());
    """);
    debugPrint("PAPA $result");
  }

  // void checkJavaScript() async {
  //   var result = await controller?.evaluateJavascript(source: "1 + 1");
  //   debugPrint("What is here ? $result");
  // }
}
