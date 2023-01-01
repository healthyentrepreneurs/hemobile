part of 'theme_lang_bloc.dart';

@immutable
abstract class ThemeLangEvent {
  const ThemeLangEvent();
}

//void Function(ThemeModel) changeTheme;
class ThemeStatusChanged extends ThemeLangEvent {
  const ThemeStatusChanged(this.themeLocale);
  // final ThemeModel theme;
  final Tuple2<ThemeModel, Locale> themeLocale;
}

// void Function(Locale) changeLocale;
class LocaleStatusChanged extends ThemeLangEvent {
  const LocaleStatusChanged(this.themeLocale);
  // final Locale locale;
  final Tuple2<ThemeModel, Locale> themeLocale;
}

// void Function(Message) onMessageChange;
class ThemeLocaleMessageChanged extends ThemeLangEvent {
  const ThemeLocaleMessageChanged(this.message);
  final ChangeThemeLocaleMessage message;

}
