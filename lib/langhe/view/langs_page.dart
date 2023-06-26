import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';
import 'package:he/langhe/langhe.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

class LangsPage extends StatelessWidget {
  const LangsPage({Key? key}) : super(key: key);
  //coming back here
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LangsPage());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: ToolUtils.whiteColor,
      appBar: HeAppBar(
        course: s.login_languages,
        appbarwidget: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            );
          },
        ),
        transparentBackground: false,
      ),
      body: const LangsList(),
    );
  }
}
