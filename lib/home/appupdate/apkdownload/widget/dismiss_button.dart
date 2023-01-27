import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/appupdate/apkdownload/apkdownload.dart';
import 'package:he/home/appupdate/apkseen/apkseen.dart';
import 'package:he_storage/he_storage.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

class DismissButton extends StatelessWidget {
  const DismissButton({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final dataBloc = BlocProvider.of<AppudateBloc>(context);
    final apkUpdateBloc = BlocProvider.of<ApkseenBloc>(context);
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: dataBloc.state.gisButtonDisabled
          ? null
          : () async {
        // jejeBloc.add(event);
        Apkupdatestatus updateStatus=const Apkupdatestatus(seen: true, updated: false);
        apkUpdateBloc.add(UpdateSeenStatusEvent(status: updateStatus));
        debugPrint("Dismissed Now");
      },
      child: const Text(
        'DISMISS',
        style: TextStyle(color: ToolUtils.colorGreenOne),
      ),
    );
  }
}