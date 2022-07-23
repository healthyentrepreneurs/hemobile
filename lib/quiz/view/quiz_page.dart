import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectquizcontent.dart';
import 'package:he/quiz/quiz.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.quizArray, required this.title})
      : super(key: key);
  final List<ObjectQuizContent>? quizArray;
  final String title;
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  InAppWebViewController? webView;
  Map<int, ObjectQuizContent> quizMap = {};
  int previousKey = 0;
  int currentKey = 0;
  int nextKey = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(color: ToolUtils.mainPrimaryColor),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
          ),
          body: Column(children: <Widget>[
            Expanded(
                child: InAppWebView(
              initialFile: "assets/quiz/index.html",
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      // disableHorizontalScroll: true,
                      // minimumFontSize: 10,
                      mediaPlaybackRequiresUserGesture: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      javaScriptEnabled: true),
                  android: AndroidInAppWebViewOptions(
                    disableDefaultErrorPage: true,
                    // useWideViewPort: false,
                    // builtInZoomControls: false,
                    fantasyFontFamily: "fantasy",
                    // loadWithOverviewMode: true,
                    useHybridComposition: true,
                    // supportMultipleWindows: true,
                    allowFileAccess: true,
                    allowContentAccess: true,
                  )),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
                var valCurrentPageId =
                    widget.quizArray!.first.currentpage.toString();
                var valNextPageId = widget.quizArray!.first.nextpage.toString();
                var encodedString = widget.quizArray!.first.html;
                quizMap.putIfAbsent(0, () => widget.quizArray!.first);
                setState(() {
                  previousKey = 0;
                  currentKey = widget.quizArray!.first.currentpage;
                  nextKey = widget.quizArray!.first.nextpage;
                });
                webView?.addJavaScriptHandler(
                    handlerName: 'handlerNextPage',
                    callback: (args) {
                      debugPrint(
                          "handlerNextPage previousKey $previousKey currentKey $currentKey nextKey $nextKey");
                      return {
                        'currentpage': valCurrentPageId,
                        'nextpageid': valNextPageId,
                        'encodedString': encodedString,
                      };
                    });
                webView?.addJavaScriptHandler(
                    handlerName: 'handlerNextWithArgs',
                    callback: (args) {
                      String previousString = args[0].toString();
                      var nextPageInt = args[1];
                      // setState(() {
                      //   previousKey = currentKey;
                      //   currentKey = args[0];
                      //   nextKey = args[1];
                      // });
                      debugPrint(
                          "handlerNextWithArgs previousKey $previousString nextPageInt $nextPageInt");
                      if (quizMap.containsKey(nextPageInt)) {
                        loadLocalDataSets(
                            quizMap[nextPageInt]!, previousString);
                      } else {
                        var nextQuestion = getAttemptData(nextPageInt);
                        if (nextQuestion.isNotEmpty) {
                          quizMap.putIfAbsent(
                              nextPageInt, () => nextQuestion.first);
                          loadLocalDataSets(nextQuestion.first, previousString);
                        }
                      }
                    });
                webView?.addJavaScriptHandler(
                    handlerName: 'handlerPreviousWithArgs',
                    callback: (args) {
                      var actualCurrent = args[0];
                      var nextValue = args[1];
                      var modifiedNextValue = 0;
                      var previous = 0;
                      if (actualCurrent == 1) {
                        modifiedNextValue = nextValue;
                        previous = 0;
                      } else if (actualCurrent > 1) {
                        previous = actualCurrent - 1;
                      }
                      // print("Current $actualCurrent and next $nextValue");
                      //
                      String valNextPageId = modifiedNextValue.toString();
                      String valCurrentPageId = actualCurrent.toString();
                      String previousId = previous.toString();
                      // setState(() {
                      //   previousKey = previous;
                      //   currentKey = actualCurrent;
                      //   nextKey = modifiedNextValue;
                      // });
                      setHTMLContentsPrev(
                          valCurrentPageId, valNextPageId, previousId);
                      debugPrint(
                          "handlerPreviousWithArgs previousKey $previousKey currentKey $currentKey nextKey $nextKey");
                    });
                webView?.addJavaScriptHandler(
                    handlerName: "handlerSubmitForm",
                    callback: (args) {
                      var actualCurrent = args[0];
                      debugPrint("What data is this $actualCurrent");
                    });
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                webView = controller;
                // setState(() {
                //   isLoading = false;
                //   this.url = url.toString();
                // });
                // processJsonDataContainer();
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading:
                  (controller, shouldOverrideUrlLoadingRequest) async {
                Uri? uri = shouldOverrideUrlLoadingRequest.request.url;
                var url = uri.toString();
                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri!.scheme)) {
                  if (await canLaunch(url)) {
                    // Launch the App
                    await launch(
                      url,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
            )),
            ButtonBar(
                alignment: MainAxisAlignment.center, children: bottomNav()),
            // currentKey = valCurrentPageId;
            // nextKey = valNextPageId;
            // QuizNav(
            //     contentLength: widget.quizArray!.length,
            //     controller: webView,
            //     previousKey: previousKey,
            //     currentKey: currentKey,
            //     nextKey: nextKey)
          ])),
    );
  }

  Future<void> loadLocalDataSets(
      ObjectQuizContent quiz, String previous) async {
    int modifiedCurrent = quiz.currentpage;
    String valCurrentPageId = modifiedCurrent.toString();
    String valNextPageId = quiz.nextpage.toString();
    var encodedString = quiz.html;
    // printOnlyDebug(quiz.html);
    setHTMLContents(valCurrentPageId, valNextPageId, previous, encodedString);
  }

  Future<void> setHTMLContentsPrev(
      valCurrentPageId, valNextPageId, previous) async {
    String contentId = valCurrentPageId + "_content";
    String previousIdHash = "#" + previous + "_content";
    String contentIdHash = "#" + contentId;
    webView?.evaluateJavascript(source: """
                                      document.getElementById("currentpageid").value = "$previous";
                                      document.getElementById("nextpageid").value = "$valCurrentPageId";
                             var a = document.getElementById("$contentId");
                             if(a){
                             \$("$previousIdHash").show();
                             \$("$contentIdHash").hide();
                              hidshownavbuttons("nextpageid", "currentpageid");
                             }
        """);
  }

  Future<void> setHTMLContents(
      valCurrentPageId, valNextPageId, previous, encodedString) async {
    String contentId = valCurrentPageId + "_content";
    String previousIdHash = "#" + previous + "_content";
    String contentIdHash = "#" + contentId;
    webView?.evaluateJavascript(source: """
                                      document.getElementById("currentpageid").value = "$valCurrentPageId";
                                      document.getElementById("nextpageid").value = "$valNextPageId";
                                      var a = document.getElementById("$contentId");
                             if(a){
                              \$("$previousIdHash").hide();
                              \$("$contentIdHash").show();
                              hidshownavbuttons("nextpageid", "currentpageid");
                             }else{
                                     \$("$previousIdHash").hide();
                                      newDiv = document.createElement('div');
                                      newDiv.id ="$contentId";
                                      currentDiv = document.getElementById("walahcontent");
                                      currentDiv.appendChild(newDiv);
                                      var container = document.getElementById("$contentId");
                                      container.innerHTML += Base64.decode("$encodedString")
                                      hidshownavbuttons("nextpageid", "currentpageid");
                                      removeinfodivs();
                                      style_inputfield();
                             }
                      """);
  }

  List<ObjectQuizContent> getAttemptData(var nextPageInt) {
    // widget.quizArray.where((_quiz) => false)
    var _quizContentList = widget.quizArray!
        .where((_quiz) => _quiz.currentpage == nextPageInt)
        .toList();
    if (_quizContentList.isNotEmpty) {
      return _quizContentList;
    } else {
      return List.empty();
    }
  }

  Future<void> checkThis() async {
    var result = await webView!.evaluateJavascript(
        source:
            """JSON.stringify(\$("form").find("input[name!=nextpageid][name!=currentpageid][name!=hashvalueid]").serializeArray());
    """);
    debugPrint("PAPA $result");
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // title: const Text('Are you sure ?'),
            contentPadding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            content: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(2.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.info_outline,
                      color: Colors.redAccent,
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Text('Are you sure ?',
                            style: TextStyle(fontSize: 18))),
                    Center(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text(
                                'All the data you filled in will be lost',
                                style: TextStyle(fontSize: 13)))),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Theme.of(context).primaryColor,
                ),
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Container(
                width: 5.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.redAccent,
                ),
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  List<Widget> bottomNav() {
    List<Widget> children;
    if (widget.quizArray!.length == 1 && nextKey == 0) {
      children = [
        ElevatedButton(
          child: const Icon(Icons.send),
          onPressed: () {
            checkThis();
            // controller?.goBack();
          },
        )
      ];
    } else if (widget.quizArray!.length > 1) {
      children = [
        ElevatedButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            if (quizMap.containsKey(nextKey)) {
              loadLocalDataSets(quizMap[nextKey]!, previousKey.toString());
            } else {
              var nextQuestion = getAttemptData(nextKey);
              if (nextQuestion.isNotEmpty) {
                quizMap.putIfAbsent(nextKey, () => nextQuestion.first);
                loadLocalDataSets(nextQuestion.first, previousKey.toString());
              }
            }
            // controller?.goBack();
          },
        )
      ];
    } else {
      children = [
        ElevatedButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            webView!.goBack();
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            webView!.goForward();
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.send),
          onPressed: () {
            webView!
                .evaluateJavascript(source: "1 + 1")
                .then((value) => {debugPrint("NYE $value")});
          },
        ),
      ];
    }
    return children;
  }
}
