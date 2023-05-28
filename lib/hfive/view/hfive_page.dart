import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he_api/he_api.dart';

import '../../home/widgets/widgets.dart';

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
  @override
  Widget build(BuildContext context) {
    if (widget.hfivecontent.status == 200) {
      fofirepo.manageHelloFile(widget.hfivecontent, widget.contextid);
      debugPrint("HELLO LANISTER");
    }
    return WillPopScope(
      onWillPop: () => const MenuItemHe().showExitConfirmationDialog(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(color: ToolUtils.whiteColor),
            ),
            backgroundColor: ToolUtils.mainPrimaryColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: widget.hfivecontent.status == 200
                  ? InAppWebView(
                      key: webViewKey,
                      initialUrlRequest:
                          URLRequest(url: WebUri(widget.hfivecontent.h5p_url)),
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
                            handlerName: "getPostMessage", callback: (args) {});
                      },
                    )
                  : const Text('I am not'),
            ),
          ])),
    );
  }
}
