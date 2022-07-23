import 'package:auth_repository/auth_repository.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:he/langhe/langhe.dart';

class LangsPage extends StatelessWidget {
  const LangsPage({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LangsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('login.languages'.tr(),
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ))),
      body: BlocProvider(
        create: (_) => LangHeCubit(context.read<AuthenticationRepository>())
          ..languagesFetched(),
        // ..languageSelected(context.locale.toString()),
        child: const LangsList(),
      ),
    );
  }
}
