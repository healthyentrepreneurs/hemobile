import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectsubscription.dart';
import 'package:he/objects/objectsurvey.dart';
import 'package:he/survey/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class SurveyPage extends StatefulWidget {
  final ObjectSubscription course;
  const SurveyPage({Key? key, required this.course}) : super(key: key);
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  dynamic surveyData;
  late String surveyDataString;
  // bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // var surveyCollection =
    //     FirebaseFirestore.instance.collection(surveyCollectionString);
    return ProgressWidget(
      child: _uiSetup(context),
      inAsyncCall: false,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
        backgroundColor: ToolUtils.whiteColor,
        appBar: AppBar(
          title: Text(
            widget.course.fullname!,
            style: const TextStyle(color: ToolUtils.mainPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
        ),
        body: (
            // QuerySnapshot
            // DocumentSnapshot
            StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('surveys')
              .doc(widget.course.id.toString())
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              //To be refactored
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ],
                ),
              );
            } else {
              if (!snapshot.hasData) {
                var children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting bids...'),
                  ),
                ];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
                // return const CircularProgressIndicator();
              } else {
                var surveyData = snapshot.data?.data();
                ObjectSurvey dataSurvey =
                    ObjectSurvey.fromJson(surveyData as Map<String, dynamic>);
                // return Text("data");
                return SurveyPageBrowser(
                  surveyobject: dataSurvey,
                );
              }
              // isLoading=true; needs to be set
            }
          },
        )));
  }

  @override
  void initState() {
    super.initState();
    loadPerms();
  }

  Future<void> loadPerms() async {
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus == PermissionStatus.denied) {
      await requestPermission(Permission.storage);
    }

    var permissionStatus2 = await Permission.camera.status;
    if (permissionStatus2 == PermissionStatus.denied) {
      await requestPermission(Permission.camera);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }
}
