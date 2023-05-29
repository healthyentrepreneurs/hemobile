function applyJqueryMobileStyling() {
    const inputs = document.querySelectorAll('input[type="text"]');

    inputs.forEach(input => {
        const wrapper = document.createElement('div');
        wrapper.setAttribute('data-role', 'fieldcontain');

        const label = document.createElement('label');
        label.setAttribute('for', input.id);
        label.textContent = input.getAttribute('placeholder') || 'Label';

        input.parentElement.insertBefore(wrapper, input);
        wrapper.appendChild(label);
        wrapper.appendChild(input);
    });
}
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
applyJqueryMobileStyling();
});

$(document).on('vmousedown', function(event) {
  // Your custom logic for handling vmousedown events
});

$(document).on('vmousemove', function(event) {
  // Your custom logic for handling vmousemove events
});

document.addEventListener('wheel', function(event) {
  // Your custom logic for handling wheel events
}, { passive: true });