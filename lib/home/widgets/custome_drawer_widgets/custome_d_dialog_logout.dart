import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../appupdate/apkseen/apkseen.dart';

class CusomeLogout extends StatelessWidget {
  const CusomeLogout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final apkUpdateBloc = BlocProvider.of<ApkseenBloc>(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
      // insetPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(2.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.info_outline,
                color: Colors.blueAccent,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Text(s.logout_title,
                      style: const TextStyle(fontSize: 18))),
              Center(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(s.logout_logoutdetails,
                          style: const TextStyle(fontSize: 13)))),
              TextField(
                key: const Key('re_passwordInput_textField'),
                obscureText: true,
                decoration: InputDecoration(
                    labelText: s.login_password,
                    // errorText: 'invalid password',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)))),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          key: const Key('confirm_logout_raisedButton'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(s.logout_confirmlogout),
          onPressed: () {
            // Apkupdatestatus updateStatus =
            // const Apkupdatestatus(
            //     seen: false, updated: false);
            // apkUpdateBloc.add(
            //     UpdateSeenStatusEvent(status: updateStatus));
            context.read<AppBloc>().add(AuthenticationLogoutRequested());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
