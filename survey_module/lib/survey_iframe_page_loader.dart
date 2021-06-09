/*
class SurveyJsIframePageLoader extends StatefulWidget {
  final dynamic jsonData;
  final String jsonDataStr;

  const SurveyJsIframePageLoader({@required this.jsonData,@required this.jsonDataStr});

  @override
  _SurveyJsIframePageLoaderState createState() => _SurveyJsIframePageLoaderState();
}

class _SurveyJsIframePageLoaderState extends State<SurveyJsIframePageLoader> {
  dynamic response;
  html.IFrameElement _element;
  js.JsObject _connector;

  @override
  void initState() {
    super.initState();
    String title = widget.jsonData['title'] as String;
    processJsonDataContainer();
  }

  void jsPostMessage(){
    _element.contentWindow.postMessage({
      'id': 'test',
      'msg': 'Hello from second variant',
    }, "*");
  }
  void jsAlert(){
    _connector.callMethod('hello', ['Hello from first variant']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      */
/*appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.filter_1),
            tooltip: 'Test with connector',
            onPressed: () {
              _connector.callMethod('hello', ['Hello from first variant']);
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_2),
            tooltip: 'Test with postMessage',
            onPressed: () {
              _element.contentWindow.postMessage({
                'id': 'test',
                'msg': 'Hello from second variant',
              }, "*");
            },
          )
        ],
      ),*//*

      body: Container(
        child: HtmlElementView(viewType: 'example'),
      ),
    );
  }

  void processJsonDataContainer() {
    var jsonTxt = widget.jsonDataStr.toString();
    //print(">>json text ---"+jsonTxt);
    js.context["connect_content_to_flutter"] = (content) {
      _connector = content;
    };

    js.context["on_survey_completed_callback"] = (msg) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Completed the for well :) - "+msg)));
    };

    _element = html.IFrameElement()
      ..style.border = 'none'
      ..srcdoc = """
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

    // ignore:undefined_prefixed_name
    // ignore: avoid_web_libraries_in_flutter
    ui.platformViewRegistry.registerViewFactory(
      'example', (int viewId) => _element,
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}

*/
