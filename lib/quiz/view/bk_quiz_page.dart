// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:he/helper/toolutils.dart';
// import 'package:he/objects/objectquizcontent.dart';
// import 'package:he/quiz/quiz.dart';
//
// class QuizPage extends StatefulWidget {
//   const QuizPage({Key? key, required this.quizArray, required this.title})
//       : super(key: key);
//   final List<ObjectQuizContent>? quizArray;
//   final String title;
//   @override
//   _QuizPageState createState() => _QuizPageState();
// }
//
// class _QuizPageState extends State<QuizPage> {
//   String url = "";
//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//         useShouldOverrideUrlLoading: true,
//         mediaPlaybackRequiresUserGesture: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ));
//   late PageController pageCtrl;
//   // final GlobalKey webViewKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     pageCtrl = PageController();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style: const TextStyle(color: ToolUtils.mainPrimaryColor),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
//       ),
//       body: Stack(
//         children: [
//           InAppWebView(
//             // key: webViewKey,
//             initialFile: "assets/quiz/index.html",
//             initialOptions: options,
//             onWebViewCreated: (InAppWebViewController controller) {
//               webViewController = controller;
//               webViewController!.addJavaScriptHandler(
//                   handlerName: 'handlerNextPage',
//                   callback: (args) {
//                     // return data to JavaScript side!
//                     return {
//                       'currentpage': widget.quizArray![0].currentpage,
//                       'nextpageid': widget.quizArray![0].nextpage,
//                       'encodedString': widget.quizArray![0].html,
//                     };
//                   });
//             },
//             androidOnPermissionRequest: (controller, origin, resources) async {
//               return PermissionRequestResponse(
//                   resources: resources,
//                   action: PermissionRequestResponseAction.GRANT);
//             },
//           ),
//           QuizPagination(
//             webCtrl: webViewController,
//             itemCount: widget.quizArray,
//           )
//         ],
//       ),
//     );
//   }
// }
