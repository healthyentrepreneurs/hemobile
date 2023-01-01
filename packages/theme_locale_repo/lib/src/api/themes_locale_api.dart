import 'package:flutter/material.dart';
import 'package:theme_locale_repo/generated/l10n.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'package:tuple/tuple.dart';

class ThemesLocalesApi {
  factory ThemesLocalesApi() {
    final themes = <ThemeModel>[
      ThemeModel(
        HeTheme.dark,
        'dark_theme',
        (s) => s.dark_theme,
      ),
      ThemeModel(
        HeTheme.light,
        'light_theme',
        (s) => s.light_theme,
      ),
      ThemeModel(
        HeTheme.light_one,
        'light_one',
        (s) => s.light_theme,
      ),
    ];

    const supportedLocaleNames = <String, String>{
      'en': 'English',
      'vi': 'Tiếng Việt'
    };

    return ThemesLocalesApi._(
      themes,
      (title) => themes.firstWhere(
        (theme) => theme.themeId == title,
      ),
      S.delegate.supportedLocales,
      (code) => S.delegate.supportedLocales.firstWhere(
        (locale) => locale.languageCode == code,
      ),
      (code) => supportedLocaleNames[code]!,
      () => Tuple2(
        themes.first,
        S.delegate.supportedLocales.first,
      ),
    );
  }

  const ThemesLocalesApi._(
    this.themes,
    this.findThemeByTitle,
    this.supportedLocales,
    this.findLocaleByLanguageCode,
    this.getLanguageNameStringByLanguageCode,
    this.defaultThemeAndLocale,
  );
  final List<ThemeModel> themes;
  final List<Locale> supportedLocales;
  final ThemeModel Function(String) findThemeByTitle;
  final Locale Function(String) findLocaleByLanguageCode;
  final String Function(String) getLanguageNameStringByLanguageCode;
  //change defaultThemeAndLocale be static const
  final Tuple2<ThemeModel, Locale> Function() defaultThemeAndLocale;

  static Tuple2<ThemeModel, Locale> get defaultThemeAndLocaleGetter =>
      ThemesLocalesApi.instance.defaultThemeAndLocale();
  static final ThemesLocalesApi instance = ThemesLocalesApi();
}
