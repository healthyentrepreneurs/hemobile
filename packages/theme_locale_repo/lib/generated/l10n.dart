// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Dark theme`
  String get dark_theme {
    return Intl.message(
      'Dark theme',
      name: 'dark_theme',
      desc: '',
      args: [],
    );
  }

  /// `Light theme`
  String get light_theme {
    return Intl.message(
      'Light theme',
      name: 'light_theme',
      desc: '',
      args: [],
    );
  }

  /// `Current theme is {themeTitle}`
  String current_theme_is(String themeTitle) {
    return Intl.message(
      'Current theme is $themeTitle',
      name: 'current_theme_is',
      desc: 'theme title',
      args: [themeTitle],
    );
  }

  /// `Current language is {langName}`
  String current_language_is(Object langName) {
    return Intl.message(
      'Current language is $langName',
      name: 'current_language_is',
      desc: '',
      args: [langName],
    );
  }

  /// `Change theme successfully`
  String get change_theme_success {
    return Intl.message(
      'Change theme successfully',
      name: 'change_theme_success',
      desc: '',
      args: [],
    );
  }

  /// `Change theme failure`
  String get change_theme_failure {
    return Intl.message(
      'Change theme failure',
      name: 'change_theme_failure',
      desc: '',
      args: [],
    );
  }

  /// `Change theme failure cause by error: {error}`
  String change_theme_failure_cause_by(Object error) {
    return Intl.message(
      'Change theme failure cause by error: $error',
      name: 'change_theme_failure_cause_by',
      desc: '',
      args: [error],
    );
  }

  /// `Change locale successfully`
  String get change_language_success {
    return Intl.message(
      'Change locale successfully',
      name: 'change_language_success',
      desc: '',
      args: [],
    );
  }

  /// `Change locale failure`
  String get change_language_failure {
    return Intl.message(
      'Change locale failure',
      name: 'change_language_failure',
      desc: '',
      args: [],
    );
  }

  /// `Change locale failure cause by error: {error}`
  String change_language_failure_cause_by(Object error) {
    return Intl.message(
      'Change locale failure cause by error: $error',
      name: 'change_language_failure_cause_by',
      desc: '',
      args: [error],
    );
  }

  /// `Your balance is {amount} on {date}`
  String pageHomeBalance(Object amount, Object date) {
    return Intl.message(
      'Your balance is $amount on $date',
      name: 'pageHomeBalance',
      desc: '',
      args: [amount, date],
    );
  }

  /// `welcome english!`
  String get welcome {
    return Intl.message(
      'welcome english!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get login_welcome {
    return Intl.message(
      'Welcome',
      name: 'login_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Sign into your account`
  String get login_welcome_msg {
    return Intl.message(
      'Sign into your account',
      name: 'login_welcome_msg',
      desc: '',
      args: [],
    );
  }

  /// `username`
  String get login_username {
    return Intl.message(
      'username',
      name: 'login_username',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get login_password {
    return Intl.message(
      'password',
      name: 'login_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get login_signbutton {
    return Intl.message(
      'Sign in',
      name: 'login_signbutton',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get login_languages {
    return Intl.message(
      'Languages',
      name: 'login_languages',
      desc: '',
      args: [],
    );
  }

  /// `About HE`
  String get login_about {
    return Intl.message(
      'About HE',
      name: 'login_about',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get navbar_home {
    return Intl.message(
      'Home',
      name: 'navbar_home',
      desc: '',
      args: [],
    );
  }

  /// `Tools`
  String get navbar_tools_toolsname {
    return Intl.message(
      'Tools',
      name: 'navbar_tools_toolsname',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get navbar_tools_books {
    return Intl.message(
      'Books',
      name: 'navbar_tools_books',
      desc: '',
      args: [],
    );
  }

  /// `Quiz`
  String get navbar_tools_quiz {
    return Intl.message(
      'Quiz',
      name: 'navbar_tools_quiz',
      desc: '',
      args: [],
    );
  }

  /// `Surveys`
  String get navbar_tools_surveys {
    return Intl.message(
      'Surveys',
      name: 'navbar_tools_surveys',
      desc: '',
      args: [],
    );
  }

  /// `Offline Settings`
  String get navbar_offlinesetting {
    return Intl.message(
      'Offline Settings',
      name: 'navbar_offlinesetting',
      desc: '',
      args: [],
    );
  }

  /// `Sync Details`
  String get navbar_syncdetails {
    return Intl.message(
      'Sync Details',
      name: 'navbar_syncdetails',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get navbar_logout {
    return Intl.message(
      'Logout',
      name: 'navbar_logout',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Logout ?`
  String get logout_title {
    return Intl.message(
      'Confirm Logout ?',
      name: 'logout_title',
      desc: '',
      args: [],
    );
  }

  /// `Please fill your password to logout!`
  String get logout_logoutdetails {
    return Intl.message(
      'Please fill your password to logout!',
      name: 'logout_logoutdetails',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get logout_confirmlogout {
    return Intl.message(
      'Confirm',
      name: 'logout_confirmlogout',
      desc: '',
      args: [],
    );
  }

  /// `KLocalizations demo!`
  String get test_title {
    return Intl.message(
      'KLocalizations demo!',
      name: 'test_title',
      desc: '',
      args: [],
    );
  }

  /// `Has clicado {{count}} veces`
  String counter(Object count) {
    return Intl.message(
      'Has clicado {$count} veces',
      name: 'counter',
      desc: '',
      args: [count],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'nn'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
