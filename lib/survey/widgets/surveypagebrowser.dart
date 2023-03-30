import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:he_api/he_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home/home.dart';
import '../../objects/blocs/hedata/bloc/database_bloc.dart';

class SurveyPageBrowser extends StatefulWidget {
  const SurveyPageBrowser._();
  static Route<SurveyState> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => SurveyBloc(repository: getIt<DatabaseRepository>()),
        child: const SurveyPageBrowser._(),
      ),
    );
  }

  @override
  _SurveyPageBrowser createState() => _SurveyPageBrowser();
}

class _SurveyPageBrowser extends State<SurveyPageBrowser> {
  String url = "";
  late InAppWebViewController webView;
  @override
  Widget build(BuildContext context) {
    final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    Subscription course = databasebloc.state.gselectedsubscription!;
    return BlocBuilder<SurveyBloc, SurveyState>(
      builder: (context, state) {
        if (state == const SurveyState.loading()) {
          debugPrint("Loading-Still A");
          final surveyBloc = BlocProvider.of<SurveyBloc>(context);
          surveyBloc.add(SurveyFetched(
              '${course.id}', databasebloc.state.ghenetworkStatus));
        }
        return FlowBuilder<SurveyState>(
          state: context.select((SurveyBloc surveyBloc) => surveyBloc.state),
          onGeneratePages: (SurveyState state, List<Page<dynamic>> pages) {
            Widget subWidget;
            if (state == const SurveyState.loading()) {
              debugPrint("Loading-Still");
              subWidget = const StateLoadingHe().loadingDataSpink();
              final surveyBloc = BlocProvider.of<SurveyBloc>(context);
              surveyBloc.add(SurveyFetched(
                  '${course.id}', databasebloc.state.ghenetworkStatus));
            } else if (state.error != null) {
              subWidget =
                  const StateLoadingHe().errorWithStackT(state.error!.message);
            } else if (state.gsurveyjson == null) {
              subWidget =
                  const StateLoadingHe().noDataFound('This Survey Is Empty');
              // return [NoneKang.page()];
            } else {
              subWidget = _buildWebView(context, state);
            }
            return [
              MaterialPage<void>(
                  child: SurveyScaf(
                      subwidget: Center(child: subWidget), course: course)),
            ];
          },
        );
      },
    );
  }

  Widget _buildWebView(BuildContext context, SurveyState state) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          state == const SurveyState.loading()
              ? const LinearProgressIndicator()
              : const SizedBox.shrink(),
          Expanded(
            child: state == const SurveyState.loading()
                ? const SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: InAppWebView(
                      // contextMenu: contextMenu,
                      //initialUrl: "https://github.com/flutter",
                      initialFile: "assets/survey/index.html",
                      initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                              useShouldOverrideUrlLoading: true,
                              //mediaPlaybackRequiresUserGesture: false,
                              javaScriptCanOpenWindowsAutomatically: true,
                              javaScriptEnabled: true),
                          android: AndroidInAppWebViewOptions(
                            disableDefaultErrorPage: true,
                            useHybridComposition: true,
                            supportMultipleWindows: true,
                            allowFileAccess: true,
                            allowContentAccess: true,
                            // allowFileAccessFromFileURLs: true,
                          )),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                        webView.addJavaScriptHandler(
                            handlerName: "sendResults",
                            callback: (args) async {
                              if (!mounted) return;
                              //print(">>Submit to server >${args.toString()}");
                              // ignore: deprecated_member_use
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("posting data..")));
                              // postJsonData(args[0].toString());
                              debugPrint("SendingSurveyData ${args[0]}");
                            });
                      },
                      onLoadStart:
                          (InAppWebViewController controller, Uri? url) {
                        //print("onLoadStart $url");
                        setState(() {
                          this.url = url.toString();
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
                        // print(">> $url");
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
                            // Launch the App
                            await launchUrl(
                              _url,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }
                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop:
                          (InAppWebViewController controller, Uri? url) async {
                        //print("onLoadStop $url");
                        setState(() {
                          // isLoading = false;
                          this.url = url.toString();
                        });
                        processJsonDataContainer();
                      },
                      onUpdateVisitedHistory:
                          (InAppWebViewController controller, Uri? url,
                              bool? androidIsReload) {
                        //print("onUpdateVisitedHistory $url");
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

  Widget _buildWebViewnn(BuildContext context, SurveyState state) {
    return SafeArea(
        child: Column(children: <Widget>[
      //Text("The loader offline $offline"),
      Expanded(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          child: InAppWebView(
            // contextMenu: contextMenu,
            //initialUrl: "https://github.com/flutter",
            initialFile: "assets/survey/index.html",
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    //mediaPlaybackRequiresUserGesture: false,
                    javaScriptCanOpenWindowsAutomatically: true,
                    javaScriptEnabled: true),
                android: AndroidInAppWebViewOptions(
                  disableDefaultErrorPage: true,
                  useHybridComposition: true,
                  supportMultipleWindows: true,
                  allowFileAccess: true,
                  allowContentAccess: true,
                  // allowFileAccessFromFileURLs: true,
                )),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
              webView.addJavaScriptHandler(
                  handlerName: "sendResults",
                  callback: (args) async {
                    if (!mounted) return;
                    //print(">>Submit to server >${args.toString()}");
                    // ignore: deprecated_member_use
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("posting data..")));
                    // postJsonData(args[0].toString());
                    debugPrint("SendingSurveyData ${args[0]}");
                  });
            },
            onLoadStart: (InAppWebViewController controller, Uri? url) {
              //print("onLoadStart $url");
              setState(() {
                this.url = url.toString();
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
              // print(">> $url");
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
                  // Launch the App
                  await launchUrl(
                    _url,
                  );
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (InAppWebViewController controller, Uri? url) async {
              //print("onLoadStop $url");
              setState(() {
                // isLoading = false;
                this.url = url.toString();
              });
              processJsonDataContainer();
            },
            onUpdateVisitedHistory: (InAppWebViewController controller,
                Uri? url, bool? androidIsReload) {
              //print("onUpdateVisitedHistory $url");
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
      // status ? alertCardPopup("Upload Survey Info") : const Text('')
    ]));
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

class SurveyScaf extends StatelessWidget {
  const SurveyScaf({Key? key, required this.course, required this.subwidget})
      : super(key: key);
  final Subscription course;
  final Widget subwidget;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolUtils.whiteColor,
      appBar: AppBar(
          title: Text(
            course.fullname!,
            style: const TextStyle(color: ToolUtils.mainPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              const MenuItemHe()
                  .showExitConfirmationDialog(context)
                  .then((value) {
                if (value) {
                  context.flow<SurveyState>().complete();
                }
              });
            },
          )),
      body: subwidget,
    );
  }
}
