import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:he/auth/login/login.dart';
import 'package:he/home/home.dart';


List<Page> onGeneratePages(
    HeAuthStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case HeAuthStatus.authenticated:
      return [HomePage.page()];
    case HeAuthStatus.unauthenticated:
      return [LoginPage.page()];
    default:
      return [LoginPage.page()];
  }
}
