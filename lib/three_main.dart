import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:he/simple_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:theme_locale_repo/generated/l10n.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'package:path_provider/path_provider.dart';

import 'langhe/langhe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  Bloc.observer = SimpleBlocObserver();
  final themeLocaleIntRepository = ThemeLocaleIntRepository();
  // userEmulator(true);
  runApp(MyApp(themeLocaleIntRepository: themeLocaleIntRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required ThemeLocaleIntRepository themeLocaleIntRepository,
  })  : _themeLocaleIntRepository = themeLocaleIntRepository,
        super(key: key);
  final ThemeLocaleIntRepository _themeLocaleIntRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _themeLocaleIntRepository,
      child: BlocProvider<ThemeLangBloc>(
        create: (_) => ThemeLangBloc(
          themeLocaleIntRepository: _themeLocaleIntRepository,
        ),
        child: BlocBuilder<ThemeLangBloc, ThemeLangState>(
          buildWhen: (previous, current) => previous.props != current.props,
          builder: (context, state) {
            return MaterialApp(
              title: 'Flutter change theme',
              theme: state.themeandlocalestate.item1.themeData,
              locale: state.themeandlocalestate.item2,
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const MyHomePage(),
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final themeLangBloc = BlocProvider.of<ThemeLangBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: BlocListener<ThemeLangBloc, ThemeLangState>(
          listener: (context, state) {
            final snackBar = SnackBar(
              content: Text(state.status.name),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          },
          child: BlocBuilder<ThemeLangBloc, ThemeLangState>(
              buildWhen: (previous, current) =>
              previous.themeandlocalestate != current.themeandlocalestate,
              builder: (context, state) {
                // loading,
                // changelocalesuccess,
                // changelocalefailure,
                // changethemesuccess,
                // changethemefailure
                if (state.status.name == 'loading') {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status.name == "changelocalefailure" ||
                    state.status.name == "changethemefailure") {
                  return const Center(child: Text('Success'));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 8),
                              blurRadius: 16,
                              spreadRadius: 0,
                              color: Theme.of(context).backgroundColor,
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: LocalePopupMenu(
                                  locale: state.themeandlocalestate.item2),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: ThemePopupMenu(
                                  themeModel: state.themeandlocalestate.item1),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 8),
                              blurRadius: 16,
                              spreadRadius: 0,
                              color: Theme.of(context).backgroundColor,
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              s.current_theme_is(
                                state.themeandlocalestate.item1.themeTitle(s),
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              s.current_language_is(
                                themeLangBloc
                                    .themeLocaleIntRepository.getLocalsApi$
                                    .getLanguageNameStringByLanguageCode(
                                  state.themeandlocalestate.item2.languageCode,
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              })),
    );
  }
}

class ThemePopupMenu extends StatelessWidget {
  const ThemePopupMenu({Key? key, required this.themeModel}) : super(key: key);

  final ThemeModel themeModel;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PopupMenuButton<ThemeModel>(
      initialValue: themeModel,
      onSelected:
      context.read<ThemeLangBloc>().themeLocaleIntRepository.changeTheme,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              themeModel.themeTitle(s),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return context
            .read<ThemeLangBloc>()
            .themeLocaleIntRepository
            .getLocalsApi$
            .themes
            .map((theme) {
          return PopupMenuItem<ThemeModel>(
            value: theme,
            child: Text(theme.themeTitle(s)),
          );
        }).toList(growable: false);
      },
    );
  }
}

class LocalePopupMenu extends StatelessWidget {
  const LocalePopupMenu({
    Key? key,
    required this.locale,
  }) : super(key: key);

  final Locale locale;
  @override
  Widget build(BuildContext context) {
    final _bloclocalepopupmenu = BlocProvider.of<ThemeLangBloc>(context);
    return PopupMenuButton<Locale>(
      initialValue: locale,
      onSelected: _bloclocalepopupmenu.themeLocaleIntRepository.changeLocale
      //     (Locale _mamaLocale) {
      //   debugPrint('Sweet Locale ${_mamaLocale}');
      //   _bloclocalepopupmenu.add(LocaleStatusChanged(_mamaLocale));
      // }
      ,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _bloclocalepopupmenu.themeLocaleIntRepository.getLocalsApi$
                  .getLanguageNameStringByLanguageCode(locale.languageCode),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return _bloclocalepopupmenu
            .themeLocaleIntRepository.getLocalsApi$.supportedLocales
            .map((locale) {
          return PopupMenuItem<Locale>(
            value: locale,
            child: Text(
              _bloclocalepopupmenu.themeLocaleIntRepository.getLocalsApi$
                  .getLanguageNameStringByLanguageCode(locale.languageCode),
            ),
          );
        }).toList(growable: false);
      },
    );
  }
}
