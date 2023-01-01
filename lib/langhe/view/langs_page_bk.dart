import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:he/langhe/langhe.dart';
import 'package:theme_locale_repo/generated/l10n.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';

class LangsPage extends StatelessWidget {
  const LangsPage({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LangsPage());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(s.login_languages,
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ))),
      body: BlocProvider(
        create: (_) => ThemeLangBloc(themeLocaleIntRepository: context.read<ThemeLocaleIntRepository>())
          ..themeLocaleIntRepository,
        // ..languageSelected(context.locale.toString()),
        child: const LangsList(),
      ),
    );
  }
}
