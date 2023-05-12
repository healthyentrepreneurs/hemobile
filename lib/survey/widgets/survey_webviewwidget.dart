import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // late SurveyBloc _surveyBloc;
  String url = "";
  bool isLoading = true;
  bool? isSaving;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    var courseId = context
        .select((DatabaseBloc bloc) => bloc.state.gselectedsubscription!.id);
    final _surveyBloc = BlocProvider.of<SurveyBloc>(context);
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
                            preferredContentMode: UserPreferredContentMode.MOBILE,
                            supportZoom:false,
                            cacheEnabled:true,
                            transparentBackground:true,
                            minimumFontSize: 14,
                            // disableVerticalScroll: true,
                            disableHorizontalScroll: true,
                            userAgent:
                                'Mozilla/5.0 (Linux; Android 9; app.healthyentrepreneurs.nl.he 1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Mobile Safari/537.36',
                            useShouldOverrideUrlLoading: true,
                            javaScriptCanOpenWindowsAutomatically: true,
                            javaScriptEnabled: true),
                        android: AndroidInAppWebViewOptions(
                          disableDefaultErrorPage: true,
                          useHybridComposition: true,
                          supportMultipleWindows: false,
                          allowFileAccess: true,
                          allowContentAccess: true,
                          builtInZoomControls: false,
                          displayZoomControls: false,
                        )),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                      webView.addJavaScriptHandler(
                          handlerName: "sendResults",
                          callback: (args) async {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blue.shade300,
                                behavior: SnackBarBehavior.floating,
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.file_copy,
                                            color: Colors.white),
                                        const SizedBox(
                                            width:
                                                8), // Add a little space between the icon and the text
                                        Text(
                                          'saving survey',
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SpinKitWave(
                                        color: Colors.green, size: 15),
                                  ],
                                ),
                              ),
                            );
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
