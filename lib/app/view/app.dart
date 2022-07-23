import 'package:auth_repository/auth_repository.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/app/app.dart';
import 'package:he/langhe/langhe.dart';
import 'package:he/nn_intl.dart';
import 'package:he/theme.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(key: key);
  final AuthenticationRepository _authenticationRepository;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider<LangHeCubit>(
              create: (BuildContext context) =>
                  LangHeCubit(_authenticationRepository)..languagesFetched()
              // ..languageSelected(context.locale.toString()),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    rebuildAllChildren(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HE Health',
      debugShowCheckedModeBanner: true,
      theme: theme,
      localizationsDelegates: context.localizationDelegates
        ..add(NnMaterialLocalizations.delegate),
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}
