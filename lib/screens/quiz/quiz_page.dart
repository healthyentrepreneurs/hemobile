import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/models/quiz_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuizPage extends StatefulWidget {
  final CourseModule module;

  const QuizPage({Key? key,required this.module}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Quiz? _quizData;
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    CourseModule cMod = widget.module;
    return Scaffold(
        backgroundColor: ToolsUtilities.mainBgColor,
        appBar: AppBar(
          title: Text(
            cMod.name!,
            style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
        ),
        body: (_quizData?.questions != null)
            ? renderHtmlGuy(
            '<html><body>${_quizData?.questions[0]?.html}</body></html>')
            : Text(''));
  }

  Widget renderHtmlGuy(String? htmlTxt) {
    return SingleChildScrollView(
      child: Column(
        children: [
          htmlTxt != null
              ? Html(
            data: htmlTxt,
            customRender: {
              "label": (context, child) {
                return Container(
                  padding: EdgeInsets.only(bottom: 13),
                  margin:EdgeInsets.only(bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tree.element!.text,
                        style: TextStyle(
                            color: ToolsUtilities.mainPrimaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            },
          )
              : Text('Loading'),
        ],
      ),
    );
  }

  void _onNavigationDelegateExample(
      WebViewController controller, String html) async {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(html));
    await controller.loadUrl('data:text/html;base64,$contentBase64');
  }

  @override
  void initState() {
    super.initState();

    loadQuizItemsData();
  }

  void loadQuizItemsData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    print('Token-->$token');

    //https://helper.healthyentrepreneurs.nl/quiz/get_quiz_em/3/0/de81bb4eb4e8303a15b00a5c61554e2a
    OpenApi().listQuizItems(widget.module.id, token!).then((t) {
      print(t.request!.url.toString());
      _processJson(t.body);
    });
  }

  _processJson(String body) {
    try {
      print(body);
      var json_ = jsonDecode(body);
      if (json_['code'] == 200) {
        var q = json_['data'];
        var quiz = Quiz.fromJson(q);
        if (quiz != null) {
          print("Quiz id -->${quiz.id}");
          setState(() {
            _quizData = quiz;
          });
          return quiz;
        }
      } else {
        showAlertDialog(context, "Quiz Loading Error!", "Failed to load quiz");
        return null;
      }
    } catch (e) {
      print('json error $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    //_controller !=null?_controller.
  }
}
