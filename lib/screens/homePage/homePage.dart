import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/models/utils.dart';
import 'package:nl_health_app/screens/chapterDetails/image_display_widget.dart';
import 'package:nl_health_app/screens/course/coursesPage.dart';
import 'package:nl_health_app/screens/course/future_image_view.dart';
import 'package:nl_health_app/screens/login/login_logic.dart';
import 'package:nl_health_app/screens/offline/survey_data_set_sync.dart';
import 'package:nl_health_app/screens/survey/survey.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/home_helper.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/screens/utilits/utils.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'package:nl_health_app/widgets/commons_widget.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  final storeHelper = getIt<HomeHelper>();
  final stateManager = getIt<LoginManager>();

  Stream<DocumentSnapshot>? _userdataStream;

  Future<void> initUserDataHomePage() async {
    User? user = (await preferenceUtil.getUser());
    if (user == null) {
      print("User is null");
      return;
    }

    downloadBundle("${user.id}", "survey");
    downloadBundle("${user.id}", "books");

    _userdataStream = FirebaseFirestore.instance
        .collection('userdata')
        .doc("${user.id}")
        .snapshots();

    if (_userdataStream != null)
      _userdataStream!.forEach((t) {
        print("User data .... " + t.data().toString());
      });
  }

  void initState() {
    super.initState();
    initApp();
    // initStore();
    initUserDataHomePage();
  }

  @override
  Widget build(BuildContext context) {
    // Phoenix.rebirth(context);
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
    // return ProgressWidget(
    //   child: _uiSetup(context),
    //   inAsyncCall: isLoading,
    //   opacity: 0.3,
    // );
  }

  Uint8List loadData(String imagePath) {
    File file = File(imagePath);
    Uint8List bytes = file.readAsBytesSync();
    return bytes;
  }

  Widget _iconTextItem(String title, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: ToolsUtilities.mainPrimaryColor,
          size: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: TextStyle(
              color: ToolsUtilities.mainPrimaryColor,
              fontWeight: FontWeight.bold),
        ),
      ],
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
      //drawer: CustomDrawer(),
      endDrawer: CustomDrawer(),
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 50.0),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                "Hi${firstName == null ? '' : ', ' + firstName!}!",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: double.infinity,
              child: count < 1
                  ? Text('')
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocalSurveySyncPage()));
                      },
                      child: ListTile(
                        title: _iconTextItem('You have $count unsent surveys',
                            FontAwesomeIcons.sync),
                      ),
                    ),
            ),

            appTitle("What do you need?"),
            //----
            // const FileImageDisplay("/bookresource/app.healthyentrepreneurs.nl/webservice/pluginfile.php/148/mod_book/chapter/10/HIV1.png"),

            if (_userdataStream != null)
              Center(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _userdataStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    final data1 =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    if (data1 != null) {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 40),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data1['Subscriptions'].length,
                        itemBuilder: (context, index) {
                          var data = data1['Subscriptions'][index];
                          return _subjectCardWidget(
                              "${data['Fullname']}",
                              "${data['SummaryCustome']}",
                              "${data['ID']}",
                              "${data['ImageURLSmall']}",
                                  () {
                            //Content Form Survey
                            Course c = Course(
                                id: "${data['ID']}",
                                fullName: "${data['Fullname']}",
                                source: "${data['Source']}",
                                summaryCustom: "${data['SummaryCustome']}",
                                nextLink: "${data['nextLink']}",
                                imageUrlSmall: "${data['ImageURLSmall']}",
                                imageUrl: "${data['ImageUrl']}");

                            print("Clicked --- ${data['Source']}");
                            if ("${data['Source']}" == 'originalm') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SurveyMainPage(course: c),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CoursesPage(course: c),
                                  ));
                            }
                          });
                        },
                      );
                    } else {
                      return SizedBox(height: 10);
                    }
                  },
                ),
              ),
            //----
          ],
        ),
      ),
    );
  }

  Widget _subjectCardWidget(String title, String description,String courseId,
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
                            color: color1),
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
                FutureImageView(
                  path: "$iconName",
                  courseId: "0",
                ),

               /* FutureBuilder(
                    future: getFirebaseFile(iconName!),
                    builder:
                        (BuildContext context, AsyncSnapshot<File> snapshot) {

                      return snapshot.data != null
                          ? new Image.file(
                              snapshot.data!,
                              height: 50.0,
                              width: 50.0,
                              errorBuilder: (a, b, c) {
                                //addFileToFirebaseCache(iconName,courseId);
                                return Image.asset("assets/images/default.png",height: 50, width: 50);
                              },
                            )
                          : new Container();
                    }),*/
              ],
            ),
          )),
    );
  }

  String? firstName;
  late String offline;

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
    print("Are you online $offlineLocal");
    setState(() {
      if (firstNameLocal != null) {
        firstName = firstNameLocal;
      }
      offline = offlineLocal;
    });

    await switchMode(offlineLocal);
  }

  late int isNewUser;

  void checkLoginStatus(BuildContext context) async {
    isLoading = true;
    // isNewUser = PreferenceUtils.getLoginNow();
    isNewUser = (await preferenceUtil.getLogin())!;
    print("Logged in user $isNewUser");
    isLoading = false;
    if (isNewUser == 2) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  void initApp() async {
    await _getPref();
  }
}
