// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:http_server/http_server.dart';
// import 'dart:io';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: MyHomePage());
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final webViewController = InAppWebViewController();
//   HttpServer? server;
//
//   @override
//   void initState() {
//     super.initState();
//     startServer();
//   }
//
//   startServer() async {
//     var staticFiles = VirtualDirectory('/path_to_your_directory');
//     staticFiles.allowDirectoryListing = true;
//     server = await HttpServer.bind('localhost', 0);
//     server!.listen(staticFiles.serveRequest);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('InAppWebView Example')),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: Uri.parse('http://localhost:${server?.port}/index.html')),
//         initialOptions: InAppWebViewGroupOptions(
//           crossPlatform: InAppWebViewOptions(
//             useShouldOverrideUrlLoading: true,
//             mediaPlaybackRequiresUserGesture: false,
//           ),
//         ),
//         onWebViewCreated: (controller) {
//           webViewController = controller;
//         },
//       ),
//     );
//   }
// }
