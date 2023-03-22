import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:he/auth/login/bloc/bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failure'),
                  duration: const Duration(seconds: 10),
                  action: SnackBarAction(
                    label: 'dismiss',
                    onPressed: () {},
                  )),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LoginLogo(),
              const SizedBox(height: 16),
              _UsernameInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              // const SizedBox(height: 8),
              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(children: [
      Container(
        width: 100,
        height: 150,
        decoration: const BoxDecoration(
          color: ToolUtils.redColor,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: ExactAssetImage('assets/images/logo.png'),
              fit: BoxFit.contain),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          s.login_welcome,
          style: const TextStyle(
              color: ToolUtils.mainPrimaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(s.login_welcome_msg,
          style: const TextStyle(color: Colors.blueGrey, fontSize: 18),
        ),
      )
    ]);
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: s.login_username,
            helperText: '',
            errorText: state.username.invalid ? 'invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: s.login_password,
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}
// Now
class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: state.status.isValidated
                    ? () =>
                        context.read<LoginBloc>().add(const LoginSubmitted())
                    : null,
                child: Text(
                  s.login_signbutton,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              );
      },
    );
  }
}
