import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/login/loginPage.dart';
import 'package:nl_health_app/screens/utilits/open_api.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Create Account',
          style: TextStyle(color: ToolsUtilities.whiteColor),
        ),
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Register!',
                    style: TextStyle(
                        color: ToolsUtilities.mainPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Create new account to get started!',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 17),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: customTextField('First name',false, (v) => {firstName = v})),
                      Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: customTextField('Last name',false, (v) => {lastName = v}))
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 7.0, right: 10, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      customTextField('Enter your Email',false, (v) => {email = v}),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),


                Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10,top: 30.0),
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: RaisedButton(
                          onPressed: () {
                            registerCall();
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Theme.of(context).primaryColor)),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have Account?',
                            style: TextStyle(color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                'Login',
                                style:
                                    TextStyle(color: ToolsUtilities.mainPrimaryColor),
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
        ),
      ),
    );
  }


  String? email;
  String? firstName;
  String? lastName;
  registerCall() {
    //'megasega91@gmail.com', 'Mega1java123!@#')
    if (email==null || firstName ==null|| lastName==null) {
      showAlertDialog(context, "Register Alert", "All fields are required");
      return;
    }
    print("email $email $firstName $lastName");
    //{"code":200,"msg":"New User Successfully Created","data":[{"id":16,"username":"clare_atwine"}]}
    new OpenApi()
        .register(email!, firstName!,lastName!)
        .then((data) => {print(">> " + data.body), processJson(data.body)})
        .catchError((err) => {print("Error -->> " + err.toString())});
  }

  processJson(String body) {
    var json = jsonDecode(body);
    print(json['code']);
    if (json['code'] == 200) {
      var user = json['data'][0];
      showAlertDialog(
          context, "Success", "Successfully Registered in");

      /*setState(() {
        _loginStatus = LoginStatus.signIn;
      });*/

      return user;
    } else {
      showAlertDialog(
          context, "Registration Error!", json['msg']);
      return null;
    }
  }

}
