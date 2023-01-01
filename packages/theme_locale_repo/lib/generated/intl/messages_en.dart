// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Change locale failure cause by error: ${error}";

  static String m1(error) => "Change theme failure cause by error: ${error}";

  static String m2(count) => "Has clicado {${count}} veces";

  static String m3(langName) => "Current language is ${langName}";

  static String m4(themeTitle) => "Current theme is ${themeTitle}";

  static String m5(amount, date) => "Your balance is ${amount} on ${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "change_language_failure":
            MessageLookupByLibrary.simpleMessage("Change locale failure"),
        "change_language_failure_cause_by": m0,
        "change_language_success":
            MessageLookupByLibrary.simpleMessage("Change locale successfully"),
        "change_theme_failure":
            MessageLookupByLibrary.simpleMessage("Change theme failure"),
        "change_theme_failure_cause_by": m1,
        "change_theme_success":
            MessageLookupByLibrary.simpleMessage("Change theme successfully"),
        "counter": m2,
        "current_language_is": m3,
        "current_theme_is": m4,
        "dark_theme": MessageLookupByLibrary.simpleMessage("Dark theme"),
        "light_theme": MessageLookupByLibrary.simpleMessage("Light theme"),
        "login_about": MessageLookupByLibrary.simpleMessage("About HE"),
        "login_languages": MessageLookupByLibrary.simpleMessage("Languages"),
        "login_password": MessageLookupByLibrary.simpleMessage("password"),
        "login_signbutton": MessageLookupByLibrary.simpleMessage("Sign in"),
        "login_username": MessageLookupByLibrary.simpleMessage("username"),
        "login_welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "login_welcome_msg":
            MessageLookupByLibrary.simpleMessage("Sign into your account"),
        "logout_confirmlogout": MessageLookupByLibrary.simpleMessage("Confirm"),
        "logout_logoutdetails": MessageLookupByLibrary.simpleMessage(
            "Please fill your password to logout!"),
        "logout_title":
            MessageLookupByLibrary.simpleMessage("Confirm Logout ?"),
        "navbar_home": MessageLookupByLibrary.simpleMessage("Home"),
        "navbar_logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "navbar_offlinesetting":
            MessageLookupByLibrary.simpleMessage("Offline Settings"),
        "navbar_syncdetails":
            MessageLookupByLibrary.simpleMessage("Sync Details"),
        "navbar_tools_books": MessageLookupByLibrary.simpleMessage("Books"),
        "navbar_tools_quiz": MessageLookupByLibrary.simpleMessage("Quiz"),
        "navbar_tools_surveys": MessageLookupByLibrary.simpleMessage("Surveys"),
        "navbar_tools_toolsname": MessageLookupByLibrary.simpleMessage("Tools"),
        "pageHomeBalance": m5,
        "test_title":
            MessageLookupByLibrary.simpleMessage("KLocalizations demo!"),
        "welcome": MessageLookupByLibrary.simpleMessage("welcome english!")
      };
}
