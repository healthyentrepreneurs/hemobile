import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/home/widgets/statuswidgets/state_loading_he.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:he_api/he_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/toolutils.dart';
import '../../objects/blocs/hedata/bloc/database_bloc.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

class SurveyPageBrowser extends StatefulWidget {
  const SurveyPageBrowser({
    Key? key,
  }) : super(key: key);
  static Page page() => const MaterialPage<void>(child: SurveyPageBrowser());
  @override
  _SurveyPageBrowser createState() => _SurveyPageBrowser();
}

class _SurveyPageBrowser extends State<SurveyPageBrowser> {
  String url = "";
  double progress = 0;
  bool isLoading = false;
  late InAppWebViewController webView;
  @override
  Widget build(BuildContext context) {
    final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    Subscription course = databasebloc.state.gselectedsubscription!;
    return Scaffold(
        backgroundColor: ToolUtils.whiteColor,
        appBar: AppBar(
            title: Text(
              course!.fullname!,
              style: const TextStyle(color: ToolUtils.mainPrimaryColor),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                BlocProvider.of<SurveyBloc>(context).add(const SurveyReset());
              },
            )),
        body: BlocListener<HenetworkBloc, HenetworkState>(
          listenWhen: (previous, current) {
            var netState = previous.gstatus != current.gstatus;
            if (netState) {
              Navigator.pop(context);
              return false;
            }
            return false;
          },
          listener: (context, state) {
// BlocProvider.of<SurveyBloc>(context)
//     .add(SurveyFetched('${course.id}', state.status));
            debugPrint("CallMe  ${state.gstatus} ");
          },
          child:
              BlocBuilder<SurveyBloc, SurveyState>(builder: (context, state) {
            final surveyBloc = BlocProvider.of<SurveyBloc>(context);
            if (state.error != null) {
              return const StateLoadingHe()
                  .errorWithStackT(state.error!.message);
            } else {
              if (state == const SurveyState.loading()) {
                final heNetworkState =
                    context.select((HenetworkBloc bloc) => bloc.state.status);
                debugPrint(
                    "SurveyPage@SurveyState.loading()  $heNetworkState and ${state.ghenetworkStatus}");
                surveyBloc.add(SurveyFetched('${course.id}', heNetworkState));
                return const StateLoadingHe().loadingData();
              } else {
                if (state.gsurveyjson == null) {
                  return const StateLoadingHe()
                      .noDataFound('This Survey Is Empty');
                }
                return SafeArea(
                    child: Column(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: progress < 1.0
                          ? LinearProgressIndicator(value: progress)
                          : Container()),
                  //Text("The loader offline $offline"),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
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
                              callback: (args) {
                                //print(">>Submit to server >${args.toString()}");
                                // ignore: deprecated_member_use
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("posting data..")));
                                // postJsonData(args[0].toString());
                                print(args[0]);
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
                        shouldOverrideUrlLoading: (controller,
                            shouldOverrideUrlLoadingRequest) async {
                          Uri? uri =
                              shouldOverrideUrlLoadingRequest.request.url;
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
                        onLoadStop: (InAppWebViewController controller,
                            Uri? url) async {
                          //print("onLoadStop $url");
                          setState(() {
                            isLoading = false;
                            this.url = url.toString();
                          });
                          processJsonDataContainer();
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
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
                  // status ? alertCardPopup("Upload Survey Info") : const Text('')
                ]));
              }
            }
          }),
        ));
  }

  @override
  void dispose() {
    // To Be Revisited
    // databasebloc.close();
    super.dispose();
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

  @override
  void initState() {
    super.initState();
    loadPerms();
  }

  Future<void> loadPerms() async {
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus == PermissionStatus.denied) {
      await requestPermission(Permission.storage);
    }

    var permissionStatus2 = await Permission.camera.status;
    if (permissionStatus2 == PermissionStatus.denied) {
      await requestPermission(Permission.camera);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }
}

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
