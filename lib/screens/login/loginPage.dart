import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/forgetPassword/forgetPasswordPage.dart';
import 'package:nl_health_app/screens/homePage/homePage.dart';
import 'package:nl_health_app/screens/register/registerPage.dart';
import 'package:nl_health_app/screens/utilits/PreferenceUtils.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { loading, notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  String? password;
  String? email;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      child: _uiLoginSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiLoginSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login',
          style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    color: ToolsUtilities.redColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: ExactAssetImage("assets/images/logo.png"),
                        fit: BoxFit.contain),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Welcome!',
                    style: TextStyle(
                        color: ToolsUtilities.mainPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign into your account',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 17),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      customTextField('Username', false, (v) => {email = v}),
                      SizedBox(
                        height: 10,
                      ),
                      customTextField('Password', true, (v) => {password = v}),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordPage()));
                            },
                            child: Text(
                              'Forget your password?',
                              style: TextStyle(
                                  color: ToolsUtilities.mainPrimaryColor),
                              textAlign: TextAlign.right,
                            )),
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: RaisedButton(
                          onPressed: () {
                            loginCall();

                            /*Navigator.push(context,MaterialPageRoute(
                                    builder: (context) => Homepage()));*/
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Need an Account?',
                            style: TextStyle(color: Colors.blueGrey),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: Text(
                                'Click Here',
                                style: TextStyle(color: Colors.green),
                                textAlign: TextAlign.start,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  loginCall() {
    //'megasega91@gmail.com', 'Mega1java123!@#')
    //Mega1java123!@#
    if (email == null || password == null) {
      showAlertDialog(context, "Login Alert", "All fields are required");
      return;
    }
    print("username $email passs =$password");
    setState(() {
      isLoading = true;
    });
    OpenApi()
        .login(email!, password!)
        .then((data) => {
              setState(() {
                isLoading = false;
              }),
              // print(">> " + data.body),
              processJson(data.body)
            })
        .catchError((err) => {
              setState(() {
                isLoading = false;
              }),
              print("Error -- " + err.toString())
            });
  }

  processJson(String body) {
    var json = jsonDecode(body);
    if (json['code'] == 200) {
      var user = User.fromJson(json['data']);
      PreferenceUtils.setUser(user);
      PreferenceUtils.setLogin(true);
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Homepage()));
      return user;
    } else {
      showAlertDialog(context, "Login Error!", json['msg']);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    initApp();
    checkLoginStatus(context);
  }

  void checkLoginStatus(BuildContext context) async {
    isLoading = true;
    setState(() {
      isLoading = false;
    });
    PreferenceUtils.getLogin().then((value) => {
          if (value)
            {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => Homepage()))
            }
        });
  }

  Future<void> initApp() async {
    createDownloadFile();
    setOfflineByDefault();
  }
}
