import 'package:flutter/material.dart';
import 'package:he/langhe/bloc/theme_lang_bloc.dart';
import 'package:theme_locale_repo/generated/l10n.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';

@immutable
class LangSnackMsg extends StatelessWidget {
  const LangSnackMsg({Key? key, required this.message}) : super(key: key);
  final ThemeLangStatus message;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    String _stringMessage;
    if (message==ThemeLangStatus.changethemesuccess) {
      _stringMessage = s.change_theme_success;
    }
    else if (message is ChangeThemeFailure) {
      var _message_mctf = message as ChangeThemeFailure;
      if (_message_mctf.error != null) {
        _stringMessage =
            s.change_theme_failure_cause_by(_message_mctf.error.toString());
      } else {
        _stringMessage = s.change_theme_failure;
      }
    } else if (message is ChangeLocaleSuccess) {
      _stringMessage = s.change_language_success;
    } else if (message is ChangeLocaleFailure) {
      var _message_mccf = message as ChangeLocaleFailure;
      if (_message_mccf.error != null) {
        _stringMessage =
            s.change_language_failure_cause_by(_message_mccf.error.toString());
      } else {
        _stringMessage = s.change_language_failure;
      }
    } else {
      _stringMessage = 'Nop';
    }
    // Scaffold(
    //   body: showSnackBar(_stringMessage,context),
    // );
    return showSnackBar(_stringMessage, context);
  }

  showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
