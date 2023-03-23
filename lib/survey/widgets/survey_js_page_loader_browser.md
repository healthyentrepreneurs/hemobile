import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/survey/widgets/progresswidget.dart';
import 'package:he_api/he_api.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyJsPageLoaderBrowser extends StatefulWidget {
  final dynamic jsonData;
  final dynamic jsonDataStr;
  // final Course course;
  final Subscription course;

  const SurveyJsPageLoaderBrowser(
      {super.key, required this.jsonData,
      required this.jsonDataStr,
      required this.course});

  @override
  _SurveyJsPageLoaderBrowserState createState() =>
      _SurveyJsPageLoaderBrowserState();
}

class _SurveyJsPageLoaderBrowserState extends State<SurveyJsPageLoaderBrowser> {
  dynamic response;
  bool isLoading = false;
  late InAppWebViewController webView;
  double progress = 0;
  late ContextMenu contextMenu;
  String url = "";
  bool showAlert = false;
  bool status = false;
  String reportMessage = "";
  String postDataText = "";
  // final storeHelper = getIt<HomeHelper>();
  @override
  void initState() {
    super.initState();
    //this.loadJsonText();
    //loadPerms();
    initApp();
  }

  void initApp() async {
    // await _getPref();
    // String title = widget.jsonData['title'] as String;
    setState(() {
      isLoading = true;
    });
  }

  late String firstName;
  late String offline;

  // _getPref() async {
  //   String? firstNameLocal = (await preferenceUtil.getUser())?.firstname;
  //   String? offlineLocal = (await preferenceUtil.getOnline());
  //   setState(() {
  //     if (firstNameLocal != null) {
  //       firstName = firstNameLocal;
  //     }
  //     offline = offlineLocal;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      inAsyncCall: isLoading,
      opacity: 0.3,
      child: _uiSetup2(context),
    );
  }

  /// Save the survey item locally
  Future<void> saveLocalSurveyDateSet(String txtName, String txtData) async {
    print("Save Pewa--- $txtName --- ");
    try {
      // SurveyDataModel survey = SurveyDataModel()
      //   ..text = txtData
      //   ..name = widget.course.id.toString()
      //   ..dateCreated = widget.course.id.toString();
      // int? id = await storeHelper.saveSurveyLocal(survey); // Create
      // print("Saved no_sql $id");
      // -----
      String txt = "";
      // if (id != null) {
      //   txt = "Successfully saved survey locally";
      //   setState(() {
      //     showAlert = true;
      //     reportMessage = txt;
      //     status = true;
      //   });
      // }
      // else {
      //   txt = "Failed to saved survey!";
      //   setState(() {
      //     showAlert = true;
      //     reportMessage = txt;
      //     status = false;
      //   });
      // }
    } catch (e) {
      print("Papawemba --- $e");
      // setState(() {
      //   showAlert = true;
      //   reportMessage = "Error while uploaded data";
      //   status = false;
      // });
    }
  }

  // Future<void> postJsonData(String body) async {
  //   var connected = await isConnected();
  //   // print("Net work connection $connected");
  //   if (offline == "on" && !connected) {
  //     // print("is an offline server sent");
  //     String? titleOptional=widget.jsonData['title'];
  //     titleOptional==null?saveLocalSurveyDateSet("notitle",body):saveLocalSurveyDateSet(titleOptional,body);
  //     // saveLocalSurveyDateSet(, body);
  //   } else {
  //     // print("is an online server sent");
  //     postJsonDataOnline(body);
  //   }
  // }

  // Future<void> postJsonDataOnline(String body) async {
  //   int? userId = (await preferenceUtil.getUser())?.id;
  //   Map<String, dynamic> j = new Map();
  //   j["userId"] = userId;
  //   j["surveyId"] = widget.course.id;
  //   // print(">> surveyId " + widget.course.id);
  //   Map<String, dynamic> j2 = jsonDecode(body);
  //   if (j2.containsKey("image-upload")) {
  //     print("Jiamy Lanister A");
  //     var imageObject = j2["image-upload"].elementAt(0);
  //     // print(image_object.runtimeType);
  //     String imageName = imageObject["name"];
  //     String cleanerImage = imageObject["content"]
  //         .replaceAll(RegExp('data:image/jpeg;base64,'), '');
  //     final decodedBytes = base64Decode(cleanerImage);
  //     OpenApi()
  //         .imageBytePost(decodedBytes, imageName, userId.toString(),
  //         widget.course.id.toString())
  //         .then((data) {
  //       // print("Njovu >> " + data?.body);
  //     }).catchError((err) => {print("Uploading Image -- " + err.toString())});
  //     j2["image-upload"] = imageName;
  //   }
  //   // print(image_object.runtimeType);
  //   j["jsondata"] = jsonEncode(j2);
  //   String b = jsonEncode(j);
  //   // print(">> customised survey " + b);
  //   setState(() {
  //     isLoading = true;
  //   });
  //   OpenApi().postSurveyJsonData(b, userId!).then((data) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     //print(">> " + data?.body);
  //     Map<String, dynamic> x = jsonDecode(data.body);
  //     if (x["code"] == 200) {
  //       setState(() {
  //         showAlert = true;
  //         reportMessage = "Done posting survey results!";
  //         status = true;
  //       });
  //     } else {
  //       // print(">> Failed to upload --" + x["code"]);
  //       setState(() {
  //         showAlert = true;
  //         reportMessage = "Failed to post survey data! - ${x["msg"]}";
  //         status = false;
  //       });
  //     }
  //   }).catchError((err) => {
  //     isLoading = false,
  //     showAlert = true,
  //     reportMessage = "Failed to upload survey!",
  //     // print("Error -- " + err.toString())
  //   });
  // }

  void processJsonDataContainer() {
    var jsonTxt = widget.jsonDataStr.toString();
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

  Widget alertCardPopup(String title) {
    return Card(
      color: status ? Colors.green : Colors.red,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.sync_rounded, color: Colors.white),
            title: Text(title, style: const TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              reportMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: !status
                ? [
                    MaterialButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        sendNow();
                      },
                      child: const Text('TRY AGAIN'),
                    ),
                    MaterialButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        sendLater();
                      },
                      child: const Text('SEND LATER'),
                    ),
                    MaterialButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        closeAlert();
                      },
                      child: const Text('CLOSE'),
                    ),
                  ]
                : [
                    MaterialButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        closeAlertSuccess();
                      },
                      child: const Text('CLOSE'),
                    )
                  ],
          ),
        ],
      ),
    );
  }

  Widget _uiSetup2(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
            onUpdateVisitedHistory: (InAppWebViewController controller,
                Uri? url, bool? androidIsReload) {
              //print("onUpdateVisitedHistory $url");
              setState(() {
                this.url = url.toString();
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
          ),
        ),
      ),
      status ? alertCardPopup("Upload Survey Info") : const Text('')
    ])));
  }

  void closeAlert() {
    setState(() {
      showAlert = false;
      status = false;
    });
  }

  void closeAlertSuccess() {
    setState(() {
      showAlert = false;
      status = false;
    });
    // Phoenix.rebirth(context);
  }

  void sendLater() {
    saveLocalSurveyDateSet(widget.jsonData['title'], postDataText);
    closeAlert();
  }

  void sendNow() {
    // postJsonDataOnline(postDataText);
    closeAlert();
  }

  @override
  void dispose() {
    // To Be Revisited
    // storeHelper.closeDb();
    super.dispose();
  }

//Now Class member

}

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
