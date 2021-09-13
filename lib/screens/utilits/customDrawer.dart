import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nl_health_app/screens/homePage/homePage.dart';
import 'package:nl_health_app/screens/login/loginPage.dart';
import 'package:nl_health_app/screens/offline/offline_activation_page.dart';
import 'package:nl_health_app/screens/offline/survey_data_set_sync.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/services/storage_service/storage_service.dart';

import 'file_system_utill.dart';
import 'models/user_model.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final preferenceUtil = getIt<StorageService>();
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
                                  image: offline == "off"
                                      ? NetworkImage(profileImage == null
                                          ? 'https://i.imgur.com/zsMvHeF.jpg'
                                          : profileImage!)
                                      : AssetImage(
                                              'assets/images/grid.png')
                                          as ImageProvider)),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          child: FutureBuilder(
                              //To Be Revisited #Njovu
                              future: FileSystemUtil().getLocalFile(
                                  profileImage == null
                                      ? "/images/59small_loginimage.png"
                                      :"/images/$userId"+"small_loginimage.png"),
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
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
              child: ListTile(
                title: _menuItem('Test Books', FontAwesomeIcons.addressCard),
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
            const SizedBox(
              height: 16,
            ),
            Divider(
              color: Colors.white70,
            ),
            isNewUser == 2
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
  }

  var value;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  int? isNewUser;
  String? username;
  String? offline;
  int? userId;
  getPref() async {
    User? user = (await preferenceUtil.getUser());
    isNewUser = (await preferenceUtil.getLogin())!;
    if (user != null) {
      userId=user.id;
      firstName = user.firstname;
      lastName = user.lastname;
      email = user.email;
      profileImage = user.profileimageurlsmall;
      username = user.username;
      setState(() {
        preferenceUtil.getOnline().then((value) => {offline = value});
        firstName = user.firstname;
      });
    }
    print("$firstName $profileImage");
  }

  signOut(BuildContext context) async {
    _openDialog(context);
  }

  void _openDialog(ctx) {
    showCupertinoDialog(
        context: ctx,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Are you sure ?"),
              content: Text("Click 'I agree' if you want to logout"),
              actions: [
                // Close the dialog
                // You can use the CupertinoDialogAction widget instead
                CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
                CupertinoButton(
                  child: Text('I agree'),
                  onPressed: () {
                    preferenceUtil.clearLogin();
                    Navigator.of(ctx).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    Phoenix.rebirth(context);
                    // Then close the dialog
                  },
                )
              ],
            ));
  }
}
//For Images When They Come
//https://stackoverflow.com/questions/66561177/the-argument-type-object-cant-be-assigned-to-the-parameter-type-imageprovide
