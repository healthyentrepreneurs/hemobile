import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:he/langhe/langhe.dart';

class LanguageListItem extends StatelessWidget {
  const LanguageListItem(
      {Key? key, required this.language, required this.currentLocale})
      : super(key: key);
  final Locale language;
  final Locale currentLocale;
  @override
  Widget build(BuildContext context) {
    final _bloclocalepopupmenu = BlocProvider.of<ThemeLangBloc>(context);
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
          leading: currentLocale.languageCode == language.languageCode
              ? const Icon(Icons.code, color: Colors.red)
              : const Icon(Icons.code),
          title: Text(
            language.languageCode,
            style: GoogleFonts.raleway(
              textStyle: Theme.of(context).textTheme.headline1,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          dense: false,
          subtitle: Text(language.languageCode, style: textTheme.caption),
          trailing: currentLocale.languageCode == language.languageCode
              ? const Icon(
                  Icons.select_all_outlined,
                  color: Colors.red,
                )
              : const Icon(Icons.select_all_outlined),
          onTap: () {
            debugPrint('Jaba ${language.toLanguageTag()}');
            _bloclocalepopupmenu.themeLocaleIntRepository
                .changeLocale(language);
            // context.read<LangHeCubit>().languageSelected(language.code);
          }),
    );
  }
}
