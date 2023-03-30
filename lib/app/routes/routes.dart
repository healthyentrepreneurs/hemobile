import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:he/auth/login/login.dart';
import 'package:he/home/home.dart';

import '../../auth/authentication/authentication.dart';

List<Page> onGeneratePages(
    AuthenticationState state, List<Page<dynamic>> pages) {
  switch (state.status) {
    case HeAuthStatus.authenticated:
      return [HomePage.page(state.user)];
    case HeAuthStatus.unauthenticated:
      return [LoginPage.page()];
    default:
      return [LoginPage.page()];
  }
}
