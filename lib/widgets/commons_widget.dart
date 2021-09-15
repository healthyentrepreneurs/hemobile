import 'package:flutter/material.dart';

Widget appTitle(String t) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    child: Text(t,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
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
