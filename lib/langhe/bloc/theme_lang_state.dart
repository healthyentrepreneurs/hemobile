part of 'theme_lang_bloc.dart';

// implement THEME AND LANGUAGE STATE
enum ThemeLangStatus implements ChangeThemeLocaleMessage {
  loading,
  changelocalesuccess,
  changelocalefailure,
  changethemesuccess,
  changethemefailure
}

class ThemeLangState extends Equatable {
  const ThemeLangState._({
    Tuple2<ThemeModel, Locale>? themeLocale,
    this.status = ThemeLangStatus.loading,
  }) : _themeandlocalestate = themeLocale;
  final ThemeLangStatus status;
  final Tuple2<ThemeModel, Locale>? _themeandlocalestate;

  Tuple2<ThemeModel, Locale> get themeandlocalestate => _themeandlocalestate!;

  const ThemeLangState.loading({Tuple2<ThemeModel, Locale>? inThemeLocale})
      : this._(themeLocale: inThemeLocale);

  factory ThemeLangState.fromJson(Map<String, dynamic> json) {
    return ThemeLangState._(
        themeLocale: Tuple2<ThemeModel, Locale>(
            ThemeLocaleIntRepository.getThemeByTitle(json['theme']),
            Locale(
                json['locale']['languageCode'], json['locale']['countryCode'])),
        status: ThemeLangStatus.values[json['status']]);
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': themeandlocalestate.item1.themeId,
      'locale': {
        'languageCode': themeandlocalestate.item2.languageCode,
        'countryCode': themeandlocalestate.item2.countryCode
      },
      'status': status.index
    };
  }

  ThemeLangState copyWith(
      {Tuple2<ThemeModel, Locale>? themeLocale,
      ThemeLangStatus? status,
      ThemeModel? thememodel,
      Locale? locale}) {
    return ThemeLangState._(
        themeLocale: themeLocale ?? themeandlocalestate,
        status: status ?? this.status);
  }

  @override
  String toString() {
    return '''ThemeLangState { status: $status, current language ${themeandlocalestate.item2.toString()} , current theme: ${themeandlocalestate.item1.toString()} }''';
  }

  @override
  List<Object> get props => [status, themeandlocalestate];
}
