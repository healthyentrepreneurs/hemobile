// ignore_for_file: omit_local_variable_types

import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'package:tuple/tuple.dart';

/// A class that manages the theme and locale
class ThemeLocaleIntRepository {
  /// [provider] is the provider of the themes and [rxSharedPrefs] is the
  /// reactive shared preferences
  factory ThemeLocaleIntRepository({
    ThemesLocalesApi? provider,
    RxSharedPreferences? rxSharedPrefs,
  }) {
    /// initialize the repository parameters if they are null
    // ignore: no_leading_underscores_for_local_identifiers
    final ThemesLocalesApi _provider = provider ?? ThemesLocalesApi();
    // ignore: no_leading_underscores_for_local_identifiers, prefer_final_locals
    RxSharedPreferences _rxSharedPrefs =
        rxSharedPrefs ?? RxSharedPreferences(SharedPreferences.getInstance());

    // Subjects
    final changeThemeSubject = PublishSubject<ThemeModel>();
    final changeLocaleSubject = PublishSubject<Locale>();
    //create a stream to hold the theme
    final Stream<ThemeModel> theme$ =
        _rxSharedPrefs.getStringStream(_themeKey).map(
      (title) {
        // To come back changed from themes[0]
        return title != null
            ? _provider.findThemeByTitle(title)
            : _provider.themes[1];
      },
    );
    //create a stream to hold the locale
    final Stream<Locale> locale$ =
        _rxSharedPrefs.getStringStream(_localeKey).map(
      (locale) {
        return locale != null
            ? _provider.findLocaleByLanguageCode(locale)
            : _provider.supportedLocales[0];
      },
    );
    final themeAndLocale$ = Rx.combineLatest2(
      theme$,
      locale$,
      // ignore: unnecessary_lambdas
      (ThemeModel theme, Locale locale) => Tuple2(theme, locale),
    ).distinct().publishValue();

    Stream<ChangeThemeLocaleMessage> changeTheme(ThemeModel theme) async* {
      try {
        await _rxSharedPrefs.setString(_themeKey, theme.themeId);
        yield const ChangeThemeSuccess();
      } catch (e) {
        yield ChangeThemeFailure(e);
      }
    }

    /*Stream<ChangeThemeLocaleMessage> changeLocale(Locale locale) async* {
      try {
        await rxSharedPrefs.setString(_localeKey, locale.languageCode);
        yield const ChangeLocaleSuccess();
      } catch (e) {
        yield ChangeLocaleFailure(e);
      }
    }*/

    Stream<ChangeThemeLocaleMessage> changeLocale(Locale locale) {
      return Rx.defer(() async* {
        try {
          await _rxSharedPrefs.setString(_localeKey, locale.languageCode);
          yield const ChangeLocaleSuccess();
        } catch (e) {
          yield ChangeLocaleFailure(e);
        }
      });
    }

    //create a stream to hold the messages
    final message$ = Rx.merge([
      changeThemeSubject.distinct().switchMap(changeTheme),
      changeLocaleSubject.distinct().switchMap(changeLocale),
    ]).publish();
    //create a dispose bag to dispose of all the streams
    // final bag = DisposeBag();
    final bag = DisposeBag([
      //Listen streams
      message$.listen((message) => debugPrint('[THEME_BLOC] message=$message')),
      themeAndLocale$.listen(
        (tuple) => debugPrint(
          '[THEME_BLOC] theme=${tuple.item1.themeId}, locale=${tuple.item2}',
        ),
      ),
      message$.connect(),
      themeAndLocale$.connect(),
      changeThemeSubject,
      changeLocaleSubject,
    ]);
    return ThemeLocaleIntRepository._(
      dispose: bag.dispose,
      changeLocale: changeLocaleSubject.add,
      changeTheme: changeThemeSubject.add,
      themeAndLocale$: themeAndLocale$,
      message$: message$,
      getLocalsApi$: _provider,
    );
  }

  ThemeLocaleIntRepository._({
    required this.dispose,
    required this.changeTheme,
    required this.changeLocale,
    required this.themeAndLocale$,
    required this.message$,
    required this.getLocalsApi$,
  });
  static const _themeKey = 'app.healthyentrepreneurs.nl.he.theme';
  static const _localeKey = 'app.healthyentrepreneurs.nl.he.locale';

  ///
  /// Input
  ///
  Future<void> Function() dispose;
  final void Function(ThemeModel) changeTheme;
  final void Function(Locale) changeLocale;
  Tuple2<ThemeModel, Locale> defaultThemeAndLocale =
      ThemesLocalesApi.defaultThemeAndLocaleGetter;

  ///
  /// Output
  ///
  final ValueStream<Tuple2<ThemeModel, Locale>> themeAndLocale$;
  final Stream<ChangeThemeLocaleMessage> message$;
  final ThemesLocalesApi getLocalsApi$;
  //create a static method which returns ThemeModel using findThemeByTitle methos of ThemesLocalesApi
  static ThemeModel getThemeByTitle(String title) {
    return ThemesLocalesApi().findThemeByTitle(title);
  }
}
