import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';

class LoginSecOne extends StatelessWidget {
  const LoginSecOne({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
          )
        ],
      ),
    );
  }
}
