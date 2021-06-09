import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nl_health_app/db2/survey_nosql_model.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../objectbox.g.dart';

class SurveyJsPageLoaderBrowser extends StatefulWidget {
  final dynamic jsonData;
  final dynamic jsonDataStr;
  final Course course;

  SurveyJsPageLoaderBrowser(
      {@required this.jsonData,
      @required this.jsonDataStr,
      @required this.course});

  @override
  _SurveyJsPageLoaderBrowserState createState() =>
      _SurveyJsPageLoaderBrowserState();
}

class _SurveyJsPageLoaderBrowserState extends State<SurveyJsPageLoaderBrowser> {
  dynamic response;
  bool isLoading = false;
  InAppWebViewController webView;
  double progress = 0;
  CookieManager _cookieManager = CookieManager.instance();
  ContextMenu contextMenu;
  String url = "";
  bool showAlert = false;
  bool status = false;
  String reportMessage = "";
  String postDataText = "";
  Store _store;
  @override
  void initState() {
    super.initState();
    //this.loadJsonText();
    //loadPerms();
    initApp();
  }

  void initApp() async {
    await _getPref();
    String title = widget.jsonData['title'] as String;
    setState(() {
      isLoading = true;
    });

    initStore();
  }

  String firstName;
  String offline;

  _getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      offline = preferences.getString("offline");
      firstName = preferences.getString("firstName");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      child: _uiSetup2(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          print(">>Submit to server >${message.message}");

          setState(() {
            postDataText = message.message;
          });
          postJsonData(message.message);
        });
  }

  /// Save the survey item locally
  Future<void> saveLocalSurveyDateSet(String txtName, String txtData) async {
    print("Save Nakiganda--- $txtName --- ");
    try {
      final box = _store.box<SurveyDataModel>();
      var person = SurveyDataModel()
        ..text = txtData
        ..name = "" + widget.course.id
        ..dateCreated = widget.course.id;
      final id = box.put(person); // Create
      print("Saved no_sql $id");
      // -----
      String txt = "";
      if (id != null) {
        txt = "Successfully saved survey locally";
        setState(() {
          showAlert = true;
          reportMessage = txt;
          status = true;
        });
      } else {
        txt = "Failed to saved survey!";
        setState(() {
          showAlert = true;
          reportMessage = txt;
          status = false;
        });
      }
    } catch (e) {
      // print("Erroror --- $e");
      setState(() {
        showAlert = true;
        reportMessage = "Error while uploaded data";
        status = false;
      });
    }
  }

  Future<void> postJsonData(String body) async {
    var connected = await isConnected();
    // print("Net work connection $connected");
    if (offline == "on" && !connected) {
      // print("is an offline server sent");
      saveLocalSurveyDateSet(widget.jsonData['title'], body);
    } else {
      // print("is an online server sent");
      postJsonDataOnline(body);
    }
  }

  Future<void> postJsonDataOnline(String body) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("id");
    Map<String, dynamic> j = new Map();
    j["userId"] = userId;
    j["surveyId"] = widget.course.id;
    // print(">> surveyId " + widget.course.id);
    Map<String, dynamic> j2 = jsonDecode(body);
    // sendImage(j2, userId.toString(), widget.course.id.toString());
    // print(image_object.runtimeType);
    j["jsondata"] = jsonEncode(j2);
    String b = jsonEncode(j);
    // print(">> customised survey " + b);
    setState(() {
      isLoading = true;
    });
    OpenApi().postSurveyJsonData(b, userId).then((data) {
      setState(() {
        isLoading = false;
      });
      //print(">> " + data?.body);
      Map<String, dynamic> x = jsonDecode(data?.body);
      if (x["code"] == 200) {
        setState(() {
          showAlert = true;
          reportMessage = "Done posting survey results!";
          status = true;
        });
      } else {
        // print(">> Failed to upload --" + x["code"]);
        setState(() {
          showAlert = true;
          reportMessage = "Failed to post survey data! - ${x["msg"]}";
          status = false;
        });
      }
    }).catchError((err) => {
          isLoading = false,
          showAlert = true,
          reportMessage = "Failed to upload survey!",
          // print("Error -- " + err.toString())
        });
  }

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
            leading: Icon(Icons.sync_rounded, color: Colors.white),
            title: Text(title, style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              reportMessage,
              style: TextStyle(color: Colors.white),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: !this.status
                ? [
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        sendNow();
                      },
                      child: const Text('TRY AGAIN'),
                    ),
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        sendLater();
                      },
                      child: const Text('SEND LATER'),
                    ),
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        this.closeAlert();
                      },
                      child: const Text('CLOSE'),
                    ),
                  ]
                : [
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        // Perform some action
                        this.closeAlertSuccess();
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
          padding: EdgeInsets.all(10.0),
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
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: false,
                    //useShouldOverrideUrlLoading: true,
                    //mediaPlaybackRequiresUserGesture: false,
                    javaScriptEnabled: true),
                android: AndroidInAppWebViewOptions(
//                    allowFileAccess: true,
//                    allowContentAccess: true,
//                    allowFileAccessFromFileURLs: true,
                    )),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
              print("onWebViewCreated");
              webView.addJavaScriptHandler(
                  handlerName: "sendResults",
                  callback: (args) {
                    //print(">>Submit to server >${args.toString()}");
                    // ignore: deprecated_member_use
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("posting data..")),
                    );
                    postJsonData(args[0].toString());
                    print(args[0]);
                  });
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              //print("onLoadStart $url");
              setState(() {
                this.url = url;
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
              var url = shouldOverrideUrlLoadingRequest.url;
              var uri = Uri.parse(url);

              //print(">> $url");
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
              ].contains(uri.scheme)) {
                if (await canLaunch(url)) {
                  // Launch the App
                  await launch(
                    url,
                  );
                  // and cancel the request
                  return ShouldOverrideUrlLoadingAction.CANCEL;
                }
              }

              return ShouldOverrideUrlLoadingAction.ALLOW;
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              //print("onLoadStop $url");
              setState(() {
                isLoading = false;
                this.url = url;
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
                String url, bool androidIsReload) {
              //print("onUpdateVisitedHistory $url");
              setState(() {
                this.url = url;
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
          ),
        ),
      ),
      status ? alertCardPopup("Upload Survey Info") : Text('')
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
    Phoenix.rebirth(context);
  }

  void sendLater() {
    saveLocalSurveyDateSet(widget.jsonData['title'], postDataText);
    closeAlert();
  }

  void sendNow() {
    postJsonDataOnline(postDataText);
    closeAlert();
  }

  void initStore() async {
    var path = await FileSystemUtil().localDocumentsPath;
    print("Paths --- $path  ---- xxdir $path'/objectbox'");
    _store = Store(getObjectBoxModel(), directory: path);
  }

  @override
  void dispose() {
    _store?.close(); // don't forget to close the store
    super.dispose();
  }

  //Now Class member

}

void sendImage(List<Object> arguments) {
  Map<String, dynamic> jTwo = arguments[0];
  String userId = arguments[1];
  String surveyId = arguments[2];
  if (jTwo.containsKey("image-upload")) {
    var imageObject = jTwo["image-upload"].elementAt(0);
    // print(image_object.runtimeType);
    String imageName = imageObject["name"];
    String cleanerImage = imageObject["content"]
        .replaceAll(RegExp('data:image/jpeg;base64,'), '');
    final decodedBytes = base64Decode(cleanerImage);
    OpenApi()
        .imageBytePost(decodedBytes, imageName, userId, surveyId)
        .then((data) {
      // print("Njovu >> " + data?.body);
    }).catchError((err) => {print("Uploading Image -- " + err.toString())});
    // j2["image-upload"] = imageName;
  }
}

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
