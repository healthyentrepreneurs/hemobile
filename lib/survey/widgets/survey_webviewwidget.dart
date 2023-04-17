import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'saving_survey_widget.dart';

class SurveyWebViewWidget extends StatefulWidget {
  final String surveyid;
  const SurveyWebViewWidget(this.surveyid, {Key? key}) : super(key: key);

  @override
  _SurveyWebViewWidgetState createState() => _SurveyWebViewWidgetState();
}

class _SurveyWebViewWidgetState extends State<SurveyWebViewWidget> {
  late InAppWebViewController webView;
  late SurveyBloc _surveyBloc;
  String url = "";
  bool isLoading = true;
  bool? isSaving;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    var courseId = context
        .select((DatabaseBloc bloc) => bloc.state.gselectedsubscription!.id);
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    return SafeArea(
      child: Column(
        children: <Widget>[
          isLoading ? const LinearProgressIndicator() : const SizedBox.shrink(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Stack(
                children: [
                  InAppWebView(
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
                            setState(() {
                              isSaving = true;
                            });
                            String surveyId = widget.surveyid;
                            String surveyJson = args[0];
                            _surveyBloc.add(SurveySave(
                                surveyId,
                                '1',
                                surveyJson,
                                user.id.toString(),
                                user.country!,
                                courseId.toString(),
                                true));
                            debugPrint(
                                "SendingSurveyData  STARTAVA \n ${args[0]} \n SurveyID");
                          });
                    },
                    onLoadStart:
                        (InAppWebViewController controller, Uri? url) async {
                      setState(() {
                        this.url = url.toString();
                        isLoading = true;
                      });
                    },
                    androidOnPermissionRequest:
                        (InAppWebViewController controller, String origin,
                            List<String> resources) async {
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
                        var _url = Uri(scheme: uri.scheme, path: url);
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
                    onConsoleMessage: (controller, consoleMessage) {},
                  ),
                  isSaving != null
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: SaveSurveyWidget(
                              scaffoldContext: context,
                              showLoadingSnackBar: isSaving!,
                              onSaveSuccess: () {
                                setState(() {
                                  isSaving = null;
                                });
                              },
                              onSaveFailure: (String errorMessage) {
                                setState(() {
                                  isSaving = null;
                                });
                              }),
                        )
                      : const SizedBox.shrink(),
                ],
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
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
