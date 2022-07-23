import 'package:flutter/material.dart';
import 'package:he/formsapi/view/questioninstance.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/googleforms/gform.dart';
import 'package:he/objects/objectform.dart';
import 'package:http/http.dart' as http;

class FormWidget extends StatefulWidget {
  final ObjectForm? webobject;
  const FormWidget({Key? key, this.webobject}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  Future<http.Response> getFormDetails(urlCall) {
    debugPrint("WHAT URL $urlCall");
    // printOnlyDebug("WHAT URL $urlCall");
    return http.get(
      Uri.parse(urlCall),
    );
  }

  @override
  Widget build(BuildContext context) {
    String urlCall =
        'https://script.google.com/macros/s/AKfycbwLCoJE-ntHek03xrMrTabFEQd2eOGjZ4hZzZoXidHOERVSvYJEJ6PujtpSn55R63k/exec?action=getForm&formid=${widget.webobject?.formid}';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.webobject!.name,
          style: const TextStyle(color: ToolUtils.mainPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
      ),
      body: Stack(
        children: [
          FutureBuilder<http.Response>(
              future: getFormDetails.call(urlCall),
              builder: (BuildContext context,
                  AsyncSnapshot<http.Response> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  final _questionObject = gformFromJson(snapshot.data!.body);
                  final itemsQuiz = _questionObject.items;
                  return Column(
                    children: [
                      ListTile(
                          title: Text(_questionObject.info.title),
                          subtitle: _questionObject.info.description != null
                              ? Text(_questionObject.info.description!)
                              : Container()),
                      Flexible(
                          child: SizedBox(
                              // padding: EdgeInsets.all(5),
                              width: double.infinity,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 20),
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: itemsQuiz.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var question = itemsQuiz[index];
                                    return QuestionInstance(item: question);
                                  }))),
                    ],
                  );
                } else {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ];
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                }
              })
          // widget.webobject!.formurl
        ],
      ),
    );
  }
}
