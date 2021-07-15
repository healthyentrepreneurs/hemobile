import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nl_health_app/screens/utilits/modelUtilits.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class Config {
  // static final String BASE_URL = 'http://34.71.189.106/';
  static final String BASE_URL = 'https://helper.healthyentrepreneurs.nl/';
}

class ToolsUtilities {
  static final mainBgColor = Color(0xffffffff);
  static final whiteColor = Color(0xffffffff);
  static final greenColor = Color(0xff16f16c);
  static final redColor = Color(0xffff5446);
  static final mainPrimaryColor = Color(0xff349141);
  static final mainLightBgColor = Color(0xfff5f5f5);
}

List<ModelUtilities> imgUtilits = [
  ModelUtilities('', 'assets/images/logo.png'),
  ModelUtilities('', 'assets/images/logo.png'),
  ModelUtilities('', 'assets/images/logo.png'),
  ModelUtilities('', 'assets/images/logo.png'),
  ModelUtilities('', 'assets/images/logo.png'),
  ModelUtilities('', 'assets/images/logo.png'),
];

List<String> imageUrls = [
  'https://mrbebo.com/wp-content/uploads/2020/07/placeholder.png',
  'https://mrbebo.com/wp-content/uploads/2020/07/placeholder.png',
  'https://mrbebo.com/wp-content/uploads/2020/07/placeholder.png',
];

List<String> imageThumbnails = [
  'assets/images/placeHolder.png',
  'assets/images/placeHolder.png',
];
List<String> skillNames = [
  'Computer',
  'Adobe',
  'English',
  'Art',
  'Arabic',
  'History',
  'Math',
  'new',
];

String paragraphContent =
    "  Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with v Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins withIt usually begins withLorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with";

/// The custom entry text filed
TextField customTextField(String hint,
    [bool isPassword = false, Function? _onChange]) {
  return TextField(
    onChanged: (value) {
      _onChange!(value);
    },
    obscureText: isPassword,
    style: TextStyle(color: Colors.blueGrey),
    cursorColor: Colors.green,
    enableInteractiveSelection: false,
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide()),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.green, width: 1.0),
        ),
        errorBorder: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.green),
        labelStyle: TextStyle(color: ToolsUtilities.greenColor)),
  );
}

Widget customCheckbox(String txt, bool val, [Function? _onChange]) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          child: Checkbox(
            value: val,
            onChanged: (bool? value) {
              _onChange!(value);
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 14.3, left: 10),
                child: Text(
                  txt,
                  style: TextStyle(
                      color: ToolsUtilities.mainPrimaryColor,
                      fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ],
    ),
  );
}

TextField customPasswordTextField(String hint) {
  return TextField(
    style: TextStyle(color: Colors.blueGrey),
    cursorColor: Colors.green,
    enableInteractiveSelection: false,
    obscureText: true,
    //This will obscure text dynamically
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide()),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.green, width: 1.0),
        ),
        errorBorder: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.green),
        labelStyle: TextStyle(color: ToolsUtilities.greenColor)),
  );
}

showAlertDialog(BuildContext context, String title, String msg,
    [Function? _onPressed]) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: [
      TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
          // https://stackoverflow.com/questions/64278595/null-check-operator-used-on-a-null-value
          if (_onPressed != null) {
            _onPressed();
          }
        },
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

savePref(
    bool loginFlag,
    String email,
    String firstName,
    String lastName,
    int id,
    String profileImage,
    String token,
    String privatetoken,
    String username) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setBool("loginFlag", loginFlag);
  await preferences.setString("firstName", firstName);
  await preferences.setString("lastName", lastName);
  await preferences.setString("email", email);
  await preferences.setInt("id", id);
  await preferences.setString("offline", "off");
  await preferences.setString("profileImage", profileImage);
  await preferences.setString("token", token);
  await preferences.setString("privatetoken", privatetoken);
  await preferences.setString("username", username);
}

saveOfflineStatusPref(String offline) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("offline", offline);
}

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    return true;
  } else {
    return false;
  }
}

saveUploadDatesPref() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("survey_upload_date",
      new DateFormat.yMMMMd('en_US').format(new DateTime.now()));
}

Future<String?> readSurveyUpload() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("survey_upload_date");
}

Future<void> setOfflineByDefault() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var x = preferences.getString("offline");
  if (x == null) {
    saveOfflineStatusPref("on");
  }
}

signOut(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  // await preferences.setInt("loginFlag", null);
  // await preferences.setString("firstName", null);
  // await preferences.setString("lastName", null);
  // await preferences.setString("email", null);
  // await preferences.setInt("id", null);
}

showToast(String msg, [MaterialColor color = Colors.blueGrey]) {
  /*Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);*/
}

toast_(String msg, [MaterialColor color = Colors.blueGrey]) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.blueGrey,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
