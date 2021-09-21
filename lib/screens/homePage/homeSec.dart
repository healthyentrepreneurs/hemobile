import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:nl_health_app/objectlist/subItems.dart';
import 'package:nl_health_app/screens/course/coursesPage.dart';
import 'package:nl_health_app/screens/login/login_logic.dart';
import 'package:nl_health_app/screens/offline/survey_data_set_sync.dart';
import 'package:nl_health_app/screens/survey/survey.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/modelfire/usersub.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';

class Homesec extends StatefulWidget {
  @override
  _HomesecState createState() => _HomesecState();
}

CollectionReference _userSub =
    FirebaseFirestore.instance.collection('userdata');

class _HomesecState extends State<Homesec> {
  bool isLoading = true;
  final stateManager = getIt<LoginManager>();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: stateManager.loginStateNotifier,
      builder: (context, _, __) {
        return ProgressWidget(
          child: _uiSetup(context),
          inAsyncCall: stateManager.loading(),
          opacity: 0.3,
        );
      },
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolsUtilities.mainLightBgColor,
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            height: 35.0,
            alignment: Alignment.center,
          ),
        ),
        backgroundColor: ToolsUtilities.whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
      ),
      endDrawer: CustomDrawer(),
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                "Hi Jax${firstName == null ? '' : ', ' + firstName!}!",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
                child: StreamBuilder<DocumentSnapshot>(
              stream: _userSub
                  .doc(id)
                  .withConverter<Mycontent>(
                    fromFirestore: (snapshot, _) =>
                        Mycontent.fromJson(snapshot.data()!),
                    toFirestore: (model, _) => model.toJson(),
                  )
                  .get()
                  .asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error 2: ${snapshot.error}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child:
                                Text('Stack trace 2: ${snapshot.stackTrace}'),
                          ),
                        ]),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final startData = snapshot.requireData;
                Mycontent? data = startData.data() as Mycontent;
                List<Subscription> mysubs = data.Subscriptions!;
                return Center(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 40),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: mysubs.length,
                      itemBuilder: (context, index) {
                        Subscription course = mysubs[index];
                        Course xcourseOld = new Course(
                            fullName: course.Fullname!,
                            source: course.Source!,
                            summaryCustom: course.SummaryCustome!,
                            nextLink: course.NextLink!,
                            imageUrlSmall: course.ImageURLSmall!,
                            imageUrl: course.ImageURL!);
                        // print("Njovu Small");
                        // print(course.ImageURLSmall);
                        return _subjectCardWidget(course.Fullname!,
                            course.SummaryCustome!, course.ImageURLSmall, () {
                          // print("Home click ${course.Source}");
                          if (course.Source == 'originalm') {
                            //Content Frorm Survey
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SurveyMainPage(course: xcourseOld)));
                          } else {
                            //Book Moodle
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CoursesPage(course: xcourseOld)));
                          }
                        });
                      }),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initApp();
  }

  String? firstName;
  late String offline;
  String? id;
  List dataSets = [];
  int count = 0;

  @override
  void dispose() {
    super.dispose();
  }

  _getPref() async {
    User? user = (await preferenceUtil.getUser());
    String? firstNameLocal = user?.firstname;
    String? offlineLocal = (await preferenceUtil.getOnline());
    setState(() {
      if (firstNameLocal != null) {
        firstName = firstNameLocal;
      }
      offline = offlineLocal;
      id = user!.id.toString();
    });
  }

  late int isNewUser;

  void checkLoginStatus(BuildContext context) async {
    isLoading = true;
    isNewUser = (await preferenceUtil.getLogin())!;
    print("Logged in user $isNewUser");
    isLoading = false;
    if (isNewUser == 2) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Homesec()));
    }
  }

  void initApp() async {
    await _getPref();
  }

  Widget _subjectCardWidget(String title, String description,
      [String? iconName, Function? onTap]) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 3.0),
              ]),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff349141)),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                futureBuilderFile(1, iconName!)
              ],
            ),
          )),
    );
  }
}
