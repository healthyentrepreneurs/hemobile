window.addEventListener("flutterInAppWebViewPlatformReady", function (event) {

    Survey.StylesManager.applyTheme("modern");
    window.changeSurveyData = function changeSurveyData(d) {
        console.log('New data to pass' + d);
        var json = JSON.stringify(d);
        window.survey = new Survey.Model(d);

        survey
            .onComplete
            .add(function (result) {
                console.log(JSON.stringify(result));
                window.flutter_inappwebview.callHandler('sendResults', JSON.stringify(result.data, null, 3));
            });

        jQuery("#surveyElement").Survey({model: survey});
    };

});


//---- https://github.com/pichillilorenzo/flutter_inappwebview/issues/415
/*
I am also facing same issue.. Please help
i fix this error use this

const message = "value";
if (window.flutter_inappwebview.callHandler) {
  window.flutter_inappwebview.callHandler('handlerName', message);
} else {
/// maybe message type error in flutter, convert to string is work
   window.flutter_inappwebview._callHandler('handlerName', setTimeout(function(){}), JSON.stringify([message]));
}
 */
//---- https://github.com/pichillilorenzo/flutter_inappwebview/issues/218
/*
I solved this issue by adding these code:

...
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
  ''';
...

InAppWebView(
...
  onWebViewCreated: (controller) {
    controller.addJavaScriptHandler(
      ...
    );
  },
  onLoadStop: (controller, url) {
    controller.evaluateJavascript(source: _js);
  },
...
);
 */
