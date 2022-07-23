import 'package:flutter/widgets.dart';
import 'package:he/app/app.dart';
import 'package:he/home/home.dart';
import 'package:he/login/login.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}