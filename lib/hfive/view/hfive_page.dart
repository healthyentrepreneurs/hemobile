import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he_api/he_api.dart';

import '../../home/widgets/widgets.dart';

enum ProgressIndicatorType { circular, linear }

class HfivePage extends StatefulWidget {
  const HfivePage(
      {Key? key,
      required this.hfivecontent,
      required this.title,
      required this.contextid})
      : super(key: key);
  final HfiveContent hfivecontent;
  final String title;
  final int contextid;

  @override
  _HfivePageState createState() => _HfivePageState();
}

class _HfivePageState extends State<HfivePage> {
  InAppWebViewController? webView;
  final GlobalKey webViewKey = GlobalKey();
  final FoFiRepository fofirepo = FoFiRepository();
  double progress = 0;
  ProgressIndicatorType type = ProgressIndicatorType.linear;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "URL NEEDED ${widget.hfivecontent.h5p_url} and status ${widget.hfivecontent.status}");
    return Scaffold(
      backgroundColor: ToolUtils.whiteColor,
      appBar: HeAppBar(
        course: widget.title,
        appbarwidget: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                const MenuItemHe()
                    .showExitConfirmationDialog(context)
                    .then((value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                });
              },
            );
          },
        ),
        transparentBackground: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                widget.hfivecontent.status == 1
                    ? InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(
                            url: WebUri(widget.hfivecontent.h5p_url)),
                        initialSettings: InAppWebViewSettings(
                          preferredContentMode: UserPreferredContentMode.MOBILE,
                          disableDefaultErrorPage: true,
                          useShouldOverrideUrlLoading: true,
                          mediaPlaybackRequiresUserGesture: false,
                          javaScriptCanOpenWindowsAutomatically: true,
                          javaScriptEnabled: true,
                          useHybridComposition: true,
                          allowFileAccess: true,
                          allowContentAccess: true,
                          userAgent:
                              "Mozilla/5.0 (Linux; Android 10; Pixel 3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Mobile Safari/537.36",
                        ),
                        onWebViewCreated:
                            (InAppWebViewController webViewController) {
                          webView = webViewController;
                          webViewController.addJavaScriptHandler(
                              handlerName: "getPostMessage",
                              callback: (args) {});
                        },
                        onProgressChanged: (controller, progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                      )
                    : const Text('In Progress ..'),
                progress < 1.0 ? getProgressIndicator(type) : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getProgressIndicator(ProgressIndicatorType type) {
    switch (type) {
      case ProgressIndicatorType.circular:
        return Center(
          child: CircularProgressIndicator(
            value: progress,
          ),
        );
      case ProgressIndicatorType.linear:
      default:
        return LinearProgressIndicator(
          value: progress,
        );
    }
  }
}
