import 'package:flutter/material.dart';
import 'package:survey_module/survey_json_schema.dart';

class SinglePage extends StatefulWidget {
  final String text;
  final dynamic pageItem;

  SinglePage({this.text, this.pageItem});

  @override
  _SinglePageState createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  dynamic response;

  @override
  Widget build(BuildContext context) {
    var pageItem = this.widget.pageItem;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SurveyJsonSchema(
              form: pageItem,
              onChanged: (dynamic response) {
                this.response = response;
              },
              actionSave: (data) {
                print(data);
              },
              buttonSave: new Container(
                height: 40.0,
                color: Colors.white,
                child: Center(
                  child: Text("Save Survey",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 60.0,)
          ]),
    );
  }
}
