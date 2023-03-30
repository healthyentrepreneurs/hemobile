window.addEventListener("flutterInAppWebViewPlatformReady", function (event) {
    Survey.StylesManager.applyTheme("modern");
    window.changeSurveyData = function changeSurveyData(d) {
        console.log('New data to pass' + d);
        //Passed Here dynamically
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
