import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/appupdate/apkdownload/apkdownload.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

class UpdateButton extends StatelessWidget {
  final String url;
  const UpdateButton({Key? key, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final dataBloc = BlocProvider.of<AppudateBloc>(context);
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: dataBloc.state.gisDownloading
          ? null
          : () async {
        dataBloc.add(StartDownloading(url));
      },
      child:
      const Text('UPDATE', style: TextStyle(color: ToolUtils.colorBlueOne)),
    );
  }
}