import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolsUtilities.mainBgColor,
      appBar: AppBar(
        title: Text(
          'My Account',
          style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
        ),
        backgroundColor: ToolsUtilities.whiteColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),

      ),
      body: Container(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.grey,
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(imageUrls[0])),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Bahaa Ehab Taha ',
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              _alertChangeEmailDialog(context);
                            },
                            child: _infoEditCard(
                                'Email', FontAwesomeIcons.envelope)),
                        InkWell(
                            onTap: () {
                              _alertChangePasswordDialog(context);
                            },
                            child: _infoEditCard(
                                'Password', FontAwesomeIcons.lock)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              _alertChangepersonalInfoDialog(context);
                            },
                            child: _infoEditCard(
                                'Personal Info', FontAwesomeIcons.user)),
                        InkWell(
                            onTap: () {
                              _alertChangeImageDialog(context);
                            },
                            child:
                                _infoEditCard('Image', FontAwesomeIcons.image)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Create the Info Edit Card

  Widget _infoEditCard(String title, IconData myIcon) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: ToolsUtilities.mainBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Icon(
                        myIcon,
                        color: ToolsUtilities.mainPrimaryColor,
                        size: 50,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Icon(
                                    FontAwesomeIcons.solidEdit,
                                    color: ToolsUtilities.whiteColor,
                                    size: 16,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: ToolsUtilities.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _alertChangePasswordDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Change your Password',
              style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
            ),
            content: Container(
              child: Column(
                children: [
                  customTextField('Enter your New Password'),
                  SizedBox(
                    height: 8,
                  ),
                  customTextField('Confirm your New Password'),
                ],
              ),
            ),
            actions: [
              FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.save,
                    color: ToolsUtilities.mainPrimaryColor,
                  ),
                  label: Text(
                    'Save',
                    style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
                  ))
            ],
          );
        });
  }

  Future _alertChangeEmailDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Change your Email',
              style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
            ),
            content: Container(
              child: Column(
                children: [
                  customTextField('Enter your Email'),
                ],
              ),
            ),
            actions: [
              FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.save,
                    color: ToolsUtilities.mainPrimaryColor,
                  ),
                  label: Text(
                    'Save',
                    style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
                  ))
            ],
          );
        });
  }

  Future _alertChangepersonalInfoDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Change your Personal Information',
              textAlign: TextAlign.center,
              style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
            ),
            content: Container(
              child: Column(
                children: [
                  customTextField('Edit your Name'),
                  SizedBox(
                    height: 5,
                  ),
                  customTextField('Edit Your Username'),
                ],
              ),
            ),
            actions: [
              FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.save,
                    color: ToolsUtilities.mainPrimaryColor,
                  ),
                  label: Text(
                    'Save',
                    style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
                  ))
            ],
          );
        });
  }

  Future _alertChangeImageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Change your Image',
              style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
            ),
            content: Container(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.grey,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(imageUrls[0])),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.save,
                    color: ToolsUtilities.mainPrimaryColor,
                  ),
                  label: Text(
                    'Save',
                    style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
                  ))
            ],
          );
        });
  }
}
