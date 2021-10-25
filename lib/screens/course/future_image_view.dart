import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nl_health_app/models/utils.dart';

class FutureImageView extends StatelessWidget {
  final String path;
  final String courseId;
  const FutureImageView({Key? key, required this.path, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return FutureBuilder(
        future: getFirebaseFile(path, courseId),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          //print("${courseModule['Modicon']}");
          return snapshot.data != null
              ? new Image.file(
            snapshot.data!,
            height: 50.0,
            width: 50.0,
            errorBuilder: (a, b, c) {
              return Image.asset("assets/images/default.png",height: 50, width: 50);
            },
          )
              : new Image.asset("assets/images/default.png",height: 50, width: 50);
        });
  }
}
