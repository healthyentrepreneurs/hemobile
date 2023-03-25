import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/home/home.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:he_api/he_api.dart';
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
  late InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolUtils.whiteColor,
      appBar: _buildAppBar(),
      body: BlocBuilder<SurveyBloc, SurveyState>(
        builder: (context, state) => _buildBody(context, state),
      ),
    );
  }

  AppBar _buildAppBar() {
    final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    Subscription course = databasebloc.state.gselectedsubscription!;
    return AppBar(
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
                context.flow<NavigationState>().update((_) => NavigationState.mainScaffold);
                BlocProvider.of<SurveyBloc>(context).add(const SurveyReset());
                BlocProvider.of<DatabaseBloc>(context).add(const DatabaseSubDeSelected());
              }
            });
          },
        ));
    // return ;
  }

  Widget _buildBody(BuildContext context, SurveyState state) {
    if (state.error != null) {
      return const StateLoadingHe().errorWithStackT(state.error!.message);
    } else if (state == const SurveyState.loading()) {
      _fetchSurveyIfNecessary(context, state);
      return const StateLoadingHe().loadingData();
    } else {
      return state.gsurveyjson == null
          ? const StateLoadingHe().noDataFound('This Survey Is Empty')
          : _buildWebView(context, state);
    }
  }

  void _fetchSurveyIfNecessary(BuildContext context, SurveyState state) {
    final surveyBloc = BlocProvider.of<SurveyBloc>(context);
    final heNetworkState =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    final databasebloc = BlocProvider.of<DatabaseBloc>(context);
    Subscription course = databasebloc.state.gselectedsubscription!;
    surveyBloc.add(SurveyFetched('${course.id}', heNetworkState));
  }

  Widget _buildWebView(BuildContext context, SurveyState state) {
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
                  callback: (args) {
                    //print(">>Submit to server >${args.toString()}");
                    // ignore: deprecated_member_use
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("posting data..")));
                    // postJsonData(args[0].toString());
                    print(args[0]);
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
            onLoadStop: (InAppWebViewController controller, Uri? url) async {
              //print("onLoadStop $url");
              setState(() {
                // isLoading = false;
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

  @override
  void dispose() {
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

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
// Helper methods for WebView and other functionality
}
