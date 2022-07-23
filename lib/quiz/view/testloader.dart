import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectquizcontent.dart';
import 'package:url_launcher/url_launcher.dart';

class TestLoader extends StatefulWidget {
  const TestLoader({Key? key, required this.quizArray, required this.title})
      : super(key: key);
  final List<ObjectQuizContent>? quizArray;
  final String title;
  @override
  _TestLoader createState() => _TestLoader();
}

class _TestLoader extends State<TestLoader> {
  late InAppWebViewController _webController;
  final nextWebController = Completer<InAppWebViewController>();
  String url = "";
  late PageController pageCtrl;
  int _currentPage = 0;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      allowFileAccess: true,
      allowContentAccess: true,
    ),
  );
  @override
  void initState() {
    super.initState();
    pageCtrl = PageController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // InAppWebViewController? webController;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: ToolUtils.mainPrimaryColor),
        ),
        actions: const [
          // Menu(controller: _controller),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
      ),
      body: Stack(
        children: [
          PageView.builder(
              itemCount: widget.quizArray!.length,
              // scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              controller: pageCtrl,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, top: 0, left: 5, right: 5),
                  child: InAppWebView(
                    // key: webViewKey,
                    initialFile: "assets/quiz/index.html",
                    initialOptions: options,
                    onWebViewCreated: (InAppWebViewController controller) {
                      _webController = controller;
                      _webController.addJavaScriptHandler(
                          handlerName: 'handlerNextPage',
                          callback: (args) {
                            // return data to JavaScript side!
                            return {
                              'currentpage':
                                  widget.quizArray![index].currentpage,
                              'nextpageid': widget.quizArray![index].nextpage,
                              'encodedString': widget.quizArray![index].html,
                            };
                          });
                      nextWebController.complete(_webController);
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
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
                  ),
                );
              },
              onPageChanged: (i) {
                setState(() {
                  _currentPage = i;
                });
              }),
          // QuizPagination(
          //   webCtrl: nextWebController.future,
          //   pageCtrl: pageCtrl,
          //   itemCount: widget.quizArray!.length,
          //   activeIndex: _currentPage,
          // )
        ],
      ),
    ));
  }
}
