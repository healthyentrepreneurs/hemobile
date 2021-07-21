import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/homePage/homePage.dart';
import 'package:nl_health_app/screens/login/loginPage.dart';
import 'package:nl_health_app/screens/offline/offline_activation_page.dart';
import 'package:nl_health_app/screens/offline/survey_data_set_sync.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'PreferenceUtils.dart';
import 'file_system_utill.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    //getPref();

    return Drawer(
      child: Container(
        color: ToolsUtilities.mainPrimaryColor,
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  offline == "off"
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.grey,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: offline != "off"
                                    ? AssetImage(
                                            'assets/images/schermafbeelding.png')
                                        as ImageProvider
                                    : NetworkImage(profileImage == null
                                        ? 'https://i.imgur.com/zsMvHeF.jpg'
                                        : profileImage!),
                              )),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          child: FutureBuilder(
                              future: FileSystemUtil().getLocalFile(
                                  profileImage == null
                                      ? 'https://i.imgur.com/zsMvHeF.jpg'
                                      : profileImage!),
                              builder: (BuildContext context,
                                  AsyncSnapshot<File> snapshot) {
                                return snapshot.data != null
                                    ? new Image.file(snapshot.data!)
                                    : new Container();
                              }),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.grey),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${firstName == null ? '' : firstName} ${lastName == null ? '' : lastName}',
                    style: TextStyle(color: ToolsUtilities.whiteColor),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
              child: ListTile(
                title: _menuItem('Home', FontAwesomeIcons.home),
              ),
            ),
            isNewUser
                ? InkWell(
                    onTap: () {
                      signOut(context);
                    },
                    child: ListTile(
                      title: _menuItem('Logout', FontAwesomeIcons.signInAlt),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: ListTile(
                      title: _menuItem('Login', FontAwesomeIcons.signInAlt),
                    ),
                  ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
              child: ListTile(
                title: _menuItem('Courses', FontAwesomeIcons.bookReader),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OfflineModulePage()));
              },
              child: ListTile(
                title: _menuItem('Offline Settings', FontAwesomeIcons.sync),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocalSurveySyncPage()));
              },
              child: ListTile(
                title: _menuItem(
                    'Upload Survey Data', FontAwesomeIcons.cloudUploadAlt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ToolsUtilities.whiteColor,
            size: 20,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: TextStyle(
                color: ToolsUtilities.whiteColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getPref();
    checkLoginStatus(context);
  }

  var value;
  late String firstName;
  late String lastName;
  late String email;
  late String? profileImage;

  late String username;
  late String offline;

  getPref() async {
    firstName = PreferenceUtils.getUser().firstname;
    lastName = PreferenceUtils.getUser().lastname;
    email = PreferenceUtils.getUser().email;
    profileImage =PreferenceUtils.getUser().profileimageurlsmall;
    username = PreferenceUtils.getUser().username;
    setState(() {
      offline = PreferenceUtils.getOnline();
      firstName = PreferenceUtils.getUser().firstname;
    });

    print("$firstName $profileImage");
  }

  signOut(BuildContext context) async {
    PreferenceUtils.init().then((value) => value.clear());
    // await preferences.setBool("loginFlag", null);
    // await preferences.setString("firstName", null);
    // await preferences.setString("lastName", null);
    // await preferences.setString("email", null);
    // await preferences.setInt("id", null);
    // await preferences.setString("profileImage", null);
    // await preferences.setString("token", null);
    // await preferences.setString("privatetoken", null);
    // await preferences.setString("username", null);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  bool isNewUser = false;

  void checkLoginStatus(BuildContext context) async {
    PreferenceUtils.getLogin().then((value) => {
      if (value)
        {
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => Homepage()))
        }
    });
  }
}
