import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/langhe/langhe.dart';
import 'package:he/login/bloc/login_bloc.dart';
import 'package:theme_locale_repo/generated/l10n.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        body: const Padding(
          padding: EdgeInsets.all(8),
          child: LoginForm(),
          // BlocProvider(
          //   create: (context) {
          //     return LoginBloc(
          //       heAuthRepository:
          //           RepositoryProvider.of<HeAuthRepository>(context),
          //     );
          //   },
          //   child: const LoginForm(),
          // ),
        ),
        // const LoginForm()
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              //Nice to implement here https://api.flutter.dev/flutter/material/AboutListTile-class.html
              BottomNavigationBarItem(
                icon: const Icon(Icons.translate_sharp),
                label: s.login_languages,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.info_outline),
                label: s.login_about,
              ),
            ],
            onTap: (int index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LangsPage(),
                    fullscreenDialog: true,
                  ),
                );
                // Navigator.of(context).push<void>(LangsPage.route());
              }
            }));
  }
}

// HomePage
