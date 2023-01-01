// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nn locale. All the
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
  String get localeName => 'nn';

  static String m0(error) =>
      "Change locale failure cause by error: ${error} nn";

  static String m1(error) => "Change theme failure cause by error: ${error} nn";

  static String m2(count) => "Has clicado {${count}} veces nn";

  static String m3(langName) => "Current language is ${langName} nn";

  static String m4(themeTitle) => "Current theme is ${themeTitle} nn";

  static String m5(amount, date) => "Your balance is ${amount} on ${date} nn";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "change_language_failure":
            MessageLookupByLibrary.simpleMessage("Change locale failure nn"),
        "change_language_failure_cause_by": m0,
        "change_language_success": MessageLookupByLibrary.simpleMessage(
            "Change locale successfully nn"),
        "change_theme_failure":
            MessageLookupByLibrary.simpleMessage("Change theme failure nn"),
        "change_theme_failure_cause_by": m1,
        "change_theme_success": MessageLookupByLibrary.simpleMessage(
            "Change theme successfully nn"),
        "counter": m2,
        "current_language_is": m3,
        "current_theme_is": m4,
        "dark_theme": MessageLookupByLibrary.simpleMessage("Dark theme nn"),
        "light_theme": MessageLookupByLibrary.simpleMessage("Light theme nn"),
        "login_about": MessageLookupByLibrary.simpleMessage("About HE nn"),
        "login_languages": MessageLookupByLibrary.simpleMessage("Languages nn"),
        "login_password": MessageLookupByLibrary.simpleMessage("password nn"),
        "login_signbutton": MessageLookupByLibrary.simpleMessage("Sign in nn"),
        "login_username": MessageLookupByLibrary.simpleMessage("username nn"),
        "login_welcome": MessageLookupByLibrary.simpleMessage("Welcome nn"),
        "login_welcome_msg":
            MessageLookupByLibrary.simpleMessage("Sign into your account nn"),
        "logout_confirmlogout":
            MessageLookupByLibrary.simpleMessage("Confirm nn"),
        "logout_logoutdetails": MessageLookupByLibrary.simpleMessage(
            "Please fill your password to logout! nn"),
        "logout_title":
            MessageLookupByLibrary.simpleMessage("Confirm Logout ? nn"),
        "navbar_home": MessageLookupByLibrary.simpleMessage("Home nn"),
        "navbar_logout": MessageLookupByLibrary.simpleMessage("Logout nn"),
        "navbar_offlinesetting":
            MessageLookupByLibrary.simpleMessage("Offline Settings nn"),
        "navbar_syncdetails":
            MessageLookupByLibrary.simpleMessage("Sync Details nn"),
        "navbar_tools_books": MessageLookupByLibrary.simpleMessage("Books nn"),
        "navbar_tools_quiz": MessageLookupByLibrary.simpleMessage("Quiz nn"),
        "navbar_tools_surveys":
            MessageLookupByLibrary.simpleMessage("Surveys nn"),
        "navbar_tools_toolsname":
            MessageLookupByLibrary.simpleMessage("Tools nn"),
        "pageHomeBalance": m5,
        "test_title":
            MessageLookupByLibrary.simpleMessage("KLocalizations demo! nn"),
        "welcome": MessageLookupByLibrary.simpleMessage("welcome english! nn")
      };
}
