import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nl_health_app/db2/survey_nosql_model.dart';
import 'package:nl_health_app/screens/course/coursesPage.dart';
import 'package:nl_health_app/screens/login/login_logic.dart';
import 'package:nl_health_app/screens/offline/survey_data_set_sync.dart';
import 'package:nl_health_app/screens/survey/survey.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/home_helper.dart';
import 'package:nl_health_app/screens/utilits/models/courses_model.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'package:tuple/tuple.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  final storeHelper = getIt<HomeHelper>();
  final stateManager = getIt<LoginManager>();
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

            /* mainOfflinePath!=null?
            fileImageBuilder(context,File("$mainOfflinePath/images/survey/3big_loginimage.png"))
                :SizedBox()
            ,*/
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text('What do you need?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ),
            Center(
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 40),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _courseList == null ? 0 : _courseList.length,
                  itemBuilder: (context, index) {
                    Course course = _courseList[index];
                    return _subjectCardWidget(course.fullName,
                        course.summaryCustom, course.imageUrlSmall, () {
                      print("Home click ${course.source}");
                      if (course.source == 'originalm') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SurveyMainPage(course: course)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CoursesPage(course: course)));
                      }
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  //You can edit the Custom Input Text Field from Here
  Widget customTextField(String hint, Icon iconName) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: TextField(
            style: TextStyle(color: Colors.grey),
            cursorColor: Colors.blueGrey,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.grey),
                suffixIcon: iconName),
          ),
        ),
      ],
    );
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
                offline == 'off'
                    ? CircleAvatar(
                        radius: 35.0,
                        backgroundColor: ToolsUtilities.mainBgColor,
                        backgroundImage:
                            offline == 'off' ? NetworkImage(iconName!) : null)
                    : FutureBuilder(
                        future: _getLocalFile(iconName!),
                        builder: (BuildContext context,
                            AsyncSnapshot<File> snapshot) {
                          return snapshot.data != null
                              ? new Image.file(
                                  snapshot.data!,
                                  height: 50.0,
                                  width: 50.0,
                                )
                              : new Container();
                        }),
              ],
            ),
          )),
    );
  }

  Future<File> _getLocalFile(String filename) async {
    String dir = await FileSystemUtil().extDownloadsPath + "/HE Health";
    File f = new File('$dir$filename');
    return f;
  }

  @override
  void initState() {
    super.initState();
    initApp();
    _checkPermissions();
    loadLocalDataSets();
    // initStore();
  }

  String? firstName;
  late String offline;

  List dataSets = [];
  int count = 0;

  Future<void> loadLocalDataSets() async {
    Tuple2<List<SurveyDataModel>, int> newBlood =
        await storeHelper.getTotalCount();
    final c = newBlood.item2;
    final notesWithNullText =
        newBlood.item1; // executes the query, returns List<Note>
    //var list = await LocalSurvey().select().toList();
    setState(() {
      dataSets = notesWithNullText;
      count = c;
    });
    await readSurveyUpload();
    for (var l in notesWithNullText) {
      print("--- ${l.id} - ${l.text}");
      //box.remove(l.id);
    }
  }

  @override
  void dispose() {
    // storeHelper.closeDb();
    // _store.getStore().close();
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
  }

  ///Load courses data list and encode it to
  _loadCourseData() async {
    late String token;
    late int userId;
    setState(() {
      isLoading = true;
    });
    User? user = (await preferenceUtil.getUser());
    if (user != null) {
      token = user.token;
      userId = user.id;
    } else {
      return;
    }
    OpenApi()
        .listCoursesWithToken(token, userId)
        .then((data) => {
              //isLoading = false,
              setState(() {
                isLoading = false;
              }),
              //print(">> " + data?.body),
              _processJson(data.body)
            })
        .catchError(
            (err) => {isLoading = false, print("Error -- " + err.toString())});
  }

  List<Course> _courseList = [];

  _processJson(String body) {
    //print(body);
    var courseJsonList = jsonDecode(body) as List;
    List<Course> coursesObjs =
        courseJsonList.map((tagJson) => Course.fromJson(tagJson)).toList();

    if (coursesObjs != null) {
      //print("Got courses -->${coursesObjs.length}");
      setState(() {
        _courseList = coursesObjs;
      });
      return coursesObjs;
    } else {
      showAlertDialog(
          context, "Courses Loading Error!", "Failed to load courses");
      return null;
    }
  }

  late int isNewUser;
  late String mainOfflinePath;

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

  void _checkPermissions() async {}

  Future<String?> _loadOfflineCourseData() async {
    mainOfflinePath = await FileSystemUtil().extDownloadsPath + "/HE Health";
    String p = await FileSystemUtil().extDownloadsPath + "/HE Health/";
    try {
      final file = File("${p}get_moodle_courses.json");
      // Read the file.
      String contents = await file.readAsString();
      isLoading = false;
      //print(">> " + data?.body),
      _processJson(contents);
      return contents;
    } catch (e) {
      isLoading = false;
      // If encountering an error, return 0.
      return null;
    }
  }

  void initApp() async {
    await _getPref();
    if (offline == "on") {
      _loadOfflineCourseData();
    } else {
      _loadCourseData();
    }
  }
}
