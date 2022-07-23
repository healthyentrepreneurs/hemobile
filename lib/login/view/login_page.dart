import 'package:auth_repository/auth_repository.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/langhe/langhe.dart';
import 'package:he/login/cubit/login_cubit.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocProvider(
            create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
            child: const LoginForm(),
          ),
        ),
        // const LoginForm()
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.translate_sharp),
                label: 'login.languages'.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.info_outline),
                label: 'login.about'.tr(),
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
