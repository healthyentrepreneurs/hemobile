import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:he/langhe/langhe.dart';

class LanguageListItem extends StatelessWidget {
  const LanguageListItem({Key? key, required this.language}) : super(key: key);
  final Lang language;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        // autofocus: true,
        leading: context.locale.languageCode == language.code
            ? const Icon(Icons.code, color: Colors.red)
            : const Icon(Icons.code),
        title: Text(
          language.name,
          style: GoogleFonts.raleway(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        dense: false,
        subtitle: Text(language.country, style: textTheme.caption),
        trailing: context.locale.languageCode == language.code
            ? const Icon(
                Icons.select_all_outlined,
                color: Colors.red,
              )
            : const Icon(Icons.select_all_outlined),
        onTap: () {
          context.read<LangHeCubit>().languageSelected(language.code);
          language.code == 'en'
              ? context.setLocale(Locale(language.code, language.country))
              : context.setLocale(Locale(language.code, ''));
        },
      ),
    );
  }
}
