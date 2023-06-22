import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he_api/he_api.dart';
import 'package:path/path.dart' as p;

class HfivePage extends StatefulWidget {
  const HfivePage(
      {Key? key,
      required this.hfivecontent,
      required this.title,
      required this.contextid})
      : super(key: key);
  final HfiveContent hfivecontent;
  final String title;
  final int contextid;
  @override
  _HfivePageState createState() => _HfivePageState();
}

class _HfivePageState extends State<HfivePage> {
  late final HttpServer server;
  final FoFiRepository _fofi = FoFiRepository();
  @override
  void initState() {
    setInit();
    super.initState();
    setupServer();
  }

  setInit() async {
    if (widget.hfivecontent.status == 200) {
      fofirepo.manageHelloFile(widget.hfivecontent, widget.contextid);
      debugPrint("HELLO LANISTER");
    }
  }

  Future<void> setupServer() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    print('Server running on IP: ${server.address} on PORT: ${server.port}');

    final Map<String, ContentType> mimeTypes = {
      '.html': ContentType.html,
      '.js': ContentType('application', 'javascript'),
      '.css': ContentType('text', 'css'),
      '.mp3': ContentType('audio', 'mpeg'),
      '.mp4': ContentType('video', 'mp4'),
      '.png': ContentType('image', 'png'),
      '.jpg': ContentType('image', 'jpeg'),
      '.woff': ContentType('font', 'woff'),
      '.woff2': ContentType('font', 'woff2'),
      '.ttf': ContentType('font', 'ttf'),
      // Add other file types if needed
    };

    server.listen((HttpRequest request) async {
      String dir = _fofi.getLocalHttpServiceIndex().path;
      debugPrint('BOBIWINEURL $dir');
      String requestPath = request.uri.path == '/'
          ? '/index.html'
          : request.uri.path; // Default to '/index.html' if root is requested
      final File file = File('$dir$requestPath');

      if (await file.exists()) {
        try {
          // Determine the Content-Type based on the file extension
          final String extension = p.extension(file.path);
          final ContentType contentType =
              mimeTypes[extension] ?? ContentType.binary;
          request.response.headers.contentType = contentType;

          await request.response.addStream(file.openRead());
        } catch (e) {
          print("Couldn't read file: $e");
          exit(-1);
        }
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('Not found');
      }
      await request.response.close();
    });
  }

  InAppWebViewController? webView;
  final GlobalKey webViewKey = GlobalKey();
  final FoFiRepository fofirepo = FoFiRepository();
  @override
  Widget build(BuildContext context) {
    // if (widget.hfivecontent.status == 200) {
    //   fofirepo.manageHelloFile(widget.hfivecontent, widget.contextid);
    //   debugPrint("HELLO LANISTER");
    // }
    String pageHtmlData = """
        <!doctype html>
<html lang="en">
<head>
    <title>Interactive Content</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <script type="text/javascript" src="../dist/main.bundle.js"></script>
    <style>
        html,
        body,
        #h5p-container-window {
            height: 100%;
            margin: 0;
            padding: 10px 1px 0px 1px;
            /* top padding is 10px, right, bottom and left are 1px */
        }
    </style>
</head>

<body>
    <div id="h5p-container-window"></div>
    <script type="text/javascript">
        const el = document.getElementById("h5p-container-window");
        const options = {
            h5pJsonPath: "find-the-words-7-7",
            frameJs: "../dist/frame.bundle.js",
            frameCss: "../dist/styles/h5p.css",
            librariesPath: "../sharedlibraries"
        }
        new H5PStandalone.H5P(el, options);
    </script>
</body>

</html>
          
          """;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: ToolUtils.mainPrimaryColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: widget.hfivecontent.status == 200
                ? InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(
                        url: WebUri('http://localhost:8080/index.html')),
                    // initialUrlRequest: URLRequest(
                    //     url: WebUri(
                    //         'file://${FoFiRepository.urlH5p(widget.contextid).path}')),
                    // initialData: InAppWebViewInitialData(
                    //   data: pageHtmlData,
                    //   baseUrl: WebUri(
                    //       'file://${FoFiRepository.urlH5p(widget.contextid).path}'),
                    // ),
                    initialSettings: InAppWebViewSettings(
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                      javaScriptCanOpenWindowsAutomatically: true,
                      javaScriptEnabled: true,
                      useHybridComposition: true,
                      // clearCache: true,
                    ),
                    onWebViewCreated:
                        (InAppWebViewController webViewController) {
                      webView = webViewController;
                      webViewController.addJavaScriptHandler(
                          handlerName: "getPostMessage", callback: (args) {});
                    },
                  )
                : const Text('I am not'),
          ),
        ]));
  }

  @override
  void dispose() {
    server.close();
    super.dispose();
  }
}
