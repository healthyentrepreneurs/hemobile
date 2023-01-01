import 'package:auth_repo/auth_repo.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/app/app.dart';
import 'package:he/langhe/langhe.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:he/login/login.dart';
import 'package:theme_locale_repo/generated/l10n.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required HeAuthRepository heAuthRepository,
    required ThemeLocaleIntRepository themeLocaleIntRepository,
  })  : _heAuthRepository = heAuthRepository,
        _themeLocaleIntRepository = themeLocaleIntRepository,
        super(key: key);
  final HeAuthRepository _heAuthRepository;
  final ThemeLocaleIntRepository _themeLocaleIntRepository;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ThemeLocaleIntRepository>(
          create: (context) => _themeLocaleIntRepository,
        ),
        RepositoryProvider<HeAuthRepository>(
          create: (context) => _heAuthRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeLangBloc>(
              create: (_) => ThemeLangBloc(
                    themeLocaleIntRepository: _themeLocaleIntRepository,
                  )
              ),
          BlocProvider<LoginBloc>(
              create: (_) => LoginBloc(
                heAuthRepository: _heAuthRepository,
              )
          ),
          BlocProvider<AppBloc>(
              create: (_) => AppBloc(
                heAuthRepository: _heAuthRepository,
              )
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);
  @override
  _AppView createState() => _AppView();
}

class _AppView extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeLangBloc, ThemeLangState>(
      buildWhen: (previous, current) => previous.props != current.props,
      builder: (context, state) {
        return MaterialApp(
          title: 'HE Health',
          debugShowCheckedModeBanner: true,
          theme: state.themeandlocalestate.item1.themeData,
          // darkTheme: FlutterTodosTheme.dark,
          locale: state.themeandlocalestate.item2,
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: FlowBuilder<HeAuthStatus>(
            state: context.select((AppBloc bloc) => bloc.state.status),
            onGeneratePages: onGenerateAppViewPages,
          ),
        );
      },
    );
  }
}
