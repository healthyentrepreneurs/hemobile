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
  void initState() {
    super.initState();
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   printOnlyDebug("Jeje Changed");
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangHeCubit, LangHeState>(
      builder: (context, state) {
        switch (state.status) {
          case LangHeStatus.failure:
            return const Center(child: Text('failed to fetch languages'));
          case LangHeStatus.success:
            if (state.languages.isEmpty) {
              return const Center(child: Text('no languages'));
            }
            return ListView.builder(
              itemCount: state.languages.length,
              itemBuilder: (BuildContext context, int index) {
                return LanguageListItem(language: state.languages[index]);
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
