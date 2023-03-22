import 'package:flutter/widgets.dart';
import 'package:he/app/app.dart';
import 'package:he/auth/login/login.dart';
import 'package:he/course/section/view/section_page.dart';
import 'package:he/home/home.dart';
import 'package:he/survey/widgets/surveypagebrowser.dart';

// List<Page> onGeneratePages(
//     HeAuthStatus state, List<Page<dynamic>> pages) {
//   switch (state) {
//     case HeAuthStatus.authenticated:
//       return [HomePage.page()];
//     case HeAuthStatus.unauthenticated:
//       return [LoginPage.page()];
//     default:
//       return [LoginPage.page()];
//   }
// }

List<Page> onGeneratePages(AppState state, List<Page<dynamic>> pages) {
  switch (state.status) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.userProfile:
      // return [UserProfile.page(userid: userid)];
      // return [UserProfile.page(userid: state.user!.id.toString(), flowController: )];
      return [
        ...pages,
        UserProfile.page(
          userid: state.user?.id.toString() ?? '',
          flowController: state.flowController!,
        ),
      ];
    case AppStatus.surveyPageBrowser:
      return [SurveyPageBrowser.page()];
    case AppStatus.sectionsPage:
      return [SectionsPage.page()];
    default:
      return [LoginPage.page()];
  }
}
