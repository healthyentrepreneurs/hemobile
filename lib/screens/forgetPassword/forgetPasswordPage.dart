import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/login/loginPage.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolsUtilities.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Forget Password',
          style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
        ),
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 30.0),
        children: [
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
                    'Check your inbox after sending to your Email',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      customTextField('Enter your Email'),
                      SizedBox(
                        height: 10,
                      ),
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
                          onPressed: () {},
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          child: Text(
                            'Send',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have Account?',
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
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                'Login here',
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
          )
        ],
      )
    );
  }
}
