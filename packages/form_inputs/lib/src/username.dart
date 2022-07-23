import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum UserValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template password}
/// Form input for an username input.
/// {@contemplate}
class Username extends FormzInput<String, UserValidationError> {
  /// {@macro username}
  const Username.pure() : super.pure('');

  /// {@macro password}
  const Username.dirty([String value = '']) : super.dirty(value);
  // https://stackoverflow.com/questions/12018245/regular-expression-to-validate-username
  static final _usernameRegExp =
      RegExp(r'^(?=[a-zA-Z0-9._]{4,12}$)(?!.*[_.]{2})[^_.].*[^_.]$');
  @override
  UserValidationError? validator(String? value) {
    return _usernameRegExp.hasMatch(value ?? '')
        ? null
        : UserValidationError.invalid;
  }
}
