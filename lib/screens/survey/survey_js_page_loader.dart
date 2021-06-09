import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class SurveyJsPageLoader extends StatefulWidget {
  final dynamic jsonData;
  final dynamic jsonDataStr;

  const SurveyJsPageLoader(
      {@required this.jsonData, @required this.jsonDataStr});

  @override
  _SurveyJsPageLoaderState createState() => _SurveyJsPageLoaderState();
}

class _SurveyJsPageLoaderState extends State<SurveyJsPageLoader> {
  dynamic response;
  WebViewPlusController _controller;
  double _height = 1000;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    String title = widget.jsonData['title'] as String;
    //processJsonDataContainer();
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Builder(builder: (context) {
        return WebViewPlus(
          initialUrl: 'assets/survey/index.html',
          debuggingEnabled: false,
          onWebViewCreated: (controller) {
            this._controller = controller;
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
            _controller.getHeight().then((double height) {
              print("Height: " + height.toString());
              setState(() {
                _height = height;
                //MediaQuery.of(context).size.height*.8;
              });
            });
            processJsonDataContainer();
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (request) {
            print(">> ${request.url}");
            if (request.url.startsWith("tel:")) {
              _makePhoneCall(request.url);
            }
            return Future.value(NavigationDecision.prevent);
          },
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          print(">>Submit to server >${message.message}");
          // ignore: deprecated_member_use
          /*Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );*/
          postJsonData(message.message);
        });
  }

  Future<void> postJsonData(String body) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("id");

    Map<String, dynamic> j = jsonDecode(body);
    j["userId"] = userId;

    String b = jsonEncode(j);
    //print(">> " + b);

    OpenApi().postSurveyJsonData(b, userId).then((data) {
      isLoading = false;
      print(">> " + data?.body);

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Done posting survey results",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError(
        (err) => {isLoading = false, print("Error -- " + err.toString())});
  }

  void processJsonDataContainer() {
    var jsonTxt = widget.jsonDataStr.toString();
    _controller.evaluateJavascript("window.changeSurveyData($jsonTxt)");
  }

}

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
