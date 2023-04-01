import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyWebViewWidget extends StatefulWidget {
  const SurveyWebViewWidget({Key? key}) : super(key: key);

  @override
  _SurveyWebViewWidgetState createState() => _SurveyWebViewWidgetState();
}

class _SurveyWebViewWidgetState extends State<SurveyWebViewWidget> {
  late InAppWebViewController webView;
  String url = "";
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          isLoading ? const LinearProgressIndicator() : const SizedBox.shrink(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: InAppWebView(
                initialFile: "assets/survey/index.html",
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        javaScriptEnabled: true),
                    android: AndroidInAppWebViewOptions(
                      disableDefaultErrorPage: true,
                      useHybridComposition: true,
                      supportMultipleWindows: true,
                      allowFileAccess: true,
                      allowContentAccess: true,
                    )),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                  webView.addJavaScriptHandler(
                      handlerName: "sendResults",
                      callback: (args) async {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("posting data..")));
                        debugPrint("SendingSurveyData ${args[0]}");
                      });
                },
                onLoadStart:
                    (InAppWebViewController controller, Uri? url) async {
                  setState(() {
                    this.url = url.toString();
                    isLoading = true;
                  });
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
                  if (url.startsWith("tel:")) {
                    _makePhoneCall(url);
                  }
                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri!.scheme)) {
                    var _url = Uri(scheme: uri!.scheme, path: url);
                    if (await canLaunchUrl(_url)) {
                      await launchUrl(_url);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop:
                    (InAppWebViewController controller, Uri? url) async {
                  setState(() {
                    isLoading = false;
                    this.url = url.toString();
                  });
                  processJsonDataContainer();
                },
                onUpdateVisitedHistory: (InAppWebViewController controller,
                    Uri? url, bool? androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  // print(consoleMessage);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void processJsonDataContainer() {
    var jsonTxt = BlocProvider.of<SurveyBloc>(context).state.gsurveyjson;
    String _js = '''
    if (!window.flutter_inappwebview.callHandler) {
    window.flutter_inappwebview.callHandler = function () {
        var _callHandlerID = setTimeout(function () { });
        window.flutter_inappwebview._callHandler(arguments[0], _callHandlerID, JSON.stringify(Array.prototype.slice.call(arguments, 1)));
        return new Promise(function (resolve, reject) {
            window.flutter_inappwebview[_callHandlerID] = resolve;
        });
    };
}
  window.changeSurveyData($jsonTxt)
  ''';
    webView.evaluateJavascript(source: _js);
    //webView.evaluateJavascript(source: "window.changeSurveyData($jsonTxt)");
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
