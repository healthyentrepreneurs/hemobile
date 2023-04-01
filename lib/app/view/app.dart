import 'package:auth_repo/auth_repo.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/app/app.dart';
import 'package:he/home/datawidgets/main_scaffold.dart';
import 'package:he/injection.dart';
import 'package:he/langhe/langhe.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:he/objects/blocs/apkupdate/bloc/apk_bloc.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/repo/apk_repo.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he_storage/he_storage.dart';
import 'package:theme_locale_repo/generated/l10n.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';

import '../../auth/auth.dart';
import '../../course/section/bloc/section_bloc.dart';
import '../../home/appupdate/appupdate.dart';
import '../../objects/blocs/appcycle/bloc/appcycle_bloc.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../../survey/bloc/survey_bloc.dart';

class App extends StatelessWidget {
  App(
      {Key? key,
      required HeAuthRepository heAuthRepository,
      required ThemeLocaleIntRepository themeLocaleIntRepository})
      : _heAuthRepository = heAuthRepository,
        _themeLocaleIntRepository = themeLocaleIntRepository,
        super(key: key);
  final HeAuthRepository _heAuthRepository;
  final ThemeLocaleIntRepository _themeLocaleIntRepository;
  final LogRepository _logRepository = getIt<LogRepository>();
  final ApkupdateRepository _gsApkUpdateApi = getIt<ApkupdateRepository>();
  final DatabaseRepository _databaseRepository = getIt<DatabaseRepository>();

  // final storage = getIt<FirebaseStorage>();

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
        RepositoryProvider<LogRepository>(
          create: (context) => _logRepository,
        ),
        RepositoryProvider<ApkupdateRepository>(
          create: (context) => _gsApkUpdateApi,
        ),
        RepositoryProvider<DatabaseRepository>(
          create: (context) => _databaseRepository,
        ),
      ],
      // dddd
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeLangBloc>(
              create: (_) => ThemeLangBloc(
                    themeLocaleIntRepository: _themeLocaleIntRepository,
                  )),
          BlocProvider<LoginBloc>(
              create: (_) => LoginBloc(
                    heAuthRepository: _heAuthRepository,
                  )),
          BlocProvider<AuthenticationBloc>(
              create: (_) => AuthenticationBloc(
                    heAuthRepository: _heAuthRepository,
                  )),
          BlocProvider<ApkBloc>(
              create: (_) => ApkBloc(
                    repository: _logRepository,
                  )),
          BlocProvider<AppudateBloc>(create: (_) => AppudateBloc()),
          BlocProvider<ApkseenBloc>(
              create: (_) => ApkseenBloc(repository: _gsApkUpdateApi)),
          BlocProvider<DatabaseBloc>(
              create: (_) => DatabaseBloc(repository: _databaseRepository)),
          // BlocProvider<SectionBloc>(
          //     create: (_) => SectionBloc(repository: _databaseRepository)),
          // BlocProvider<SurveyBloc>(
          //     create: (_) => SurveyBloc(repository: _databaseRepository)),
          BlocProvider<HenetworkBloc>(create: (_) => HenetworkBloc()),
          BlocProvider<AppLifecycleStateBloc>(
              create: (_) => AppLifecycleStateBloc()),
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
          scaffoldMessengerKey: scaffoldKey,
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
          home: FlowBuilder<AuthenticationState>(
            state: context.select((AuthenticationBloc bloc) => bloc.state),
            onGeneratePages: onGeneratePages,
          ),
        );
      },
    );
  }
}
