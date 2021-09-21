import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nl_health_app/screens/utilits/modelUtilits.dart';
import 'package:connectivity/connectivity.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/services/storage_service/storage_service.dart';

class Config {
  // static final String BASE_URL = 'https://stagingapp.healthyentrepreneurs.nl/';
  static final String BASE_URL = 'https://helper.healthyentrepreneurs.nl/';
}

class ToolsUtilities {
  static final mainBgColor = Color(0xffffffff);
  static final whiteColor = Color(0xffffffff);
  static final greenColor = Color(0xff16f16c);
  static final redColor = Color(0xffff5446);
  static final mainPrimaryColor = Color(0xff1ab394);
  static final mainLightBgColor = Color(0xfff5f5f5);
  static Widget iconTextItem(String title, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: mainPrimaryColor,
          size: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          title,
          style:
              TextStyle(color: mainPrimaryColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
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
String paragraphContent = "jeje";
FirebaseStorage storage = FirebaseStorage.instance;
// https://stackoverflow.com/questions/53513456/flutter-network-image-does-not-fit-in-circular-avatar
Future<void> tata(String url) async {
  try {
    await storage.ref(url).getDownloadURL();
    // StorageException
  } on FirebaseException catch (e) {
    print("pwawa");
    return null;
  }catch (_){
    print("jajajs");
  }
}

Widget futureBuilderFile(int picVideo, String fileUrl) {
  late Future<File> file;
  try {
    file = FirebaseCacheManager().getSingleFile(fileUrl);
  }on FirebaseException catch(e){
    print("Step 1 error");
    file = FirebaseCacheManager().getSingleFile(
        "/bookresource/app.healthyentrepreneurs.nl/theme/image.php/_s/academi/book/1631050397/placeholderimage.png");
  }catch (_){
    print("Step 2 error");
    file = FirebaseCacheManager().getSingleFile(
        "/bookresource/app.healthyentrepreneurs.nl/theme/image.php/_s/academi/book/1631050397/placeholderimage.png");
  }
  return FutureBuilder(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return snapshot.data != null
            ? CircleAvatar(
                radius: 40.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.file(
                    snapshot.data!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.fill,
                    repeat: ImageRepeat.repeat,
                    alignment: Alignment.topCenter,
                    color: Colors.red,
                    colorBlendMode: BlendMode.saturation,
                    //      scale: 4,
                  ),
                ))
            : new Container();
      });
  // Image.asset("images/schermafbeelding.png",
  //   fit: BoxFit.cover,
  //   width: MediaQuery.of(context).size.width,
  // )
}

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
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide()),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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

Widget customTextFieldv2(String hint, Icon iconName) {
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

// If Ever I need a dropdown
// https://yashodgayashan.medium.com/flutter-dropdown-button-widget-469794c886d0
// https://medium.com/flutterdevs/dropdown-in-flutter-324ae9caa743
DropdownButton customeDropBox(
    String dropdownValue, Function(String?) _onChange) {
  Function(String?) g = _onChange;
  return DropdownButton<String>(
    value: dropdownValue,
    icon: const Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: const TextStyle(color: Colors.blueGrey),
    underline: Container(
      height: 2,
      color: Colors.green,
    ),
    isExpanded: true,
    onChanged: g,
    items: <String>['English', 'Swahili', 'Luganda', 'Runyankole']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
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
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide()),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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

final preferenceUtil = getIt<StorageService>();
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
  preferenceUtil.setSurveyUploadDate(
      new DateFormat.yMMMMd('en_US').format(new DateTime.now()));
}

Future<String?> readSurveyUpload() async {
  return preferenceUtil.getSurveyUploadDate();
}

signOut(BuildContext context) async {
  preferenceUtil.clearLogin();
  // await preferences.clear();
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
