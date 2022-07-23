window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
window.flutter_inappwebview.callHandler('handlerNextPage')
                  .then(function(result) {
                  document.getElementById('currentpageid').value = result.currentpage;
                  document.getElementById('nextpageid').value = result.nextpageid;
                  document.getElementById('hashvalueid').value = result.encodedString;
                  var val_current = parseInt($('#currentpageid').val());
                   if ($("#" + val_current + "_content").length == 0) {
//                        var encordedstring = $('#hashvalueid').val();
                        const newDiv = document.createElement('div');
                        newDiv.id = val_current + "_content";
                        const currentDiv = document.getElementById("walahcontent");
                        currentDiv.appendChild(newDiv);
                        var container = document.getElementById(val_current + "_content");
                        container.innerHTML += Base64.decode(result.encodedString)
                        hidshownavbuttons("nextpageid", "currentpageid");
                        removeinfodivs();
                        style_inputfield();
                   }
                });
            });