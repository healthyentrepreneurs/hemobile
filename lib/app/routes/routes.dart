import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:he/home_old/home.dart';
import 'package:he/login_old/login.dart';

List<Page> onGenerateAppViewPages(HeAuthStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case HeAuthStatus.authenticated:
      return [HomePage.page()];
    case HeAuthStatus.unauthenticated:
      return [LoginPage.page()];
    default:
      return [LoginPage.page()];
  }
}