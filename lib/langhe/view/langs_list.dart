import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/langhe/langhe.dart';

class LangsList extends StatefulWidget {
  const LangsList({Key? key}) : super(key: key);
  @override
  _LangsListState createState() => _LangsListState();
}

class _LangsListState extends State<LangsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeLangBloc, ThemeLangState>(
      builder: (context, state) {
        final _bloclocalepopupmenu = BlocProvider.of<ThemeLangBloc>(context);

        switch (state.status) {
          case ThemeLangStatus.changelocalefailure:
            return const Center(child: Text('failed to fetch languages'));
          case ThemeLangStatus.changelocalesuccess:
            return ListView.builder(
              itemCount: _bloclocalepopupmenu.themeLocaleIntRepository
                  .getLocalsApi$.supportedLocales.length,
              itemBuilder: (BuildContext context, int index) {
                return LanguageListItem(
                    language: _bloclocalepopupmenu.themeLocaleIntRepository
                        .getLocalsApi$.supportedLocales[index],
                    currentLocale: state.themeandlocalestate.item2);
              },
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
