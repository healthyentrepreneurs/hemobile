import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template password}
/// Form input for an password input.
/// {@contemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([String value = '']) : super.dirty(value);

  // static final _passwordRegExp =RegExp(r'^\S{10,}$');
  static final _passwordRegExp = RegExp(r'^(123456|\S{10,})$');
  // RegExp(r'^(?=.*![A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }
}