abstract class ChangeThemeLocaleMessage {}

class ChangeThemeSuccess implements ChangeThemeLocaleMessage {
  const ChangeThemeSuccess();
}

class ChangeThemeFailure implements ChangeThemeLocaleMessage {
  /// Nullable
  final error;

  const ChangeThemeFailure([this.error]);
}

class ChangeLocaleSuccess implements ChangeThemeLocaleMessage {
  const ChangeLocaleSuccess();
}

class ChangeLocaleFailure implements ChangeThemeLocaleMessage {
  /// Nullable
  final error;

  const ChangeLocaleFailure([this.error]);
}
