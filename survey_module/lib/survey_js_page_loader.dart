import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    String title = widget.jsonData['title'] as String;
    processJsonDataContainer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20),
              Text("Value xxx"),
              Center(
                  child: Text("This is it")
              )
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        iconSize: 20,
                        icon: Icon(
                          FontAwesomeIcons.angleLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),


                  Column(children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        iconSize: 20,
                        icon: Icon(
                          FontAwesomeIcons.angleRight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void processJsonDataContainer() {
    var jsonTxt = widget.jsonDataStr.toString();
    print(">>json text" + jsonTxt);
    var htmlString = """
        <!DOCTYPE html>
          <head>
          <meta name="viewport" content="width=device-width"/>
          <link href="https://surveyjs.azureedge.net/1.8.14/modern.css" type="text/css" rel="stylesheet"/>
          <script src="https://unpkg.com/jquery"></script>
          <script src="https://surveyjs.azureedge.net/1.8.14/survey.jquery.min.js"></script>

            <script>
              // variant 1
              parent.connect_content_to_flutter && parent.connect_content_to_flutter(window)
              function hello(msg) {
                alert(msg)
              }

              // variant 2
              window.addEventListener("message", (message) => {
                if (message.data.id === "test") {
                  alert(message.data.msg)
                }
              })
            </script>

          </head>
          <body>
            <div id="surveyElement" style="display:inline-block;width:100%;"></div>
            <div id="surveyResult" style="width:100%;color:'green';"></div>


            <script>
            Survey.StylesManager.applyTheme("modern");
            var json = $jsonTxt;

            window.survey = new Survey.Model(json);

            survey
                .onComplete
                .add(function (result) {
                    document
                        .querySelector('#surveyResult')
                        .textContent = "Result JSON:" + JSON.stringify(result.data, null, 3);
                        parent.on_survey_completed_callback(JSON.stringify(result.data, null, 3));
                });

              \$("#surveyElement").Survey({model: survey});
            </script>
          </body>
        </html>
        """;
  }
}


