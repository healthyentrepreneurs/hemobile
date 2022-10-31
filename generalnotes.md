Tools Used:
https://pub.dev/packages/very_good_cli
https://pub.dev/packages/very_good_analysis

Trans
https://pub.dev/packages/klocalizations_flutter
https://abcdevops.com/blog/2019/07/01/Flutter-Internationalization-with-Manual-Locale-switch.html
https://medium.com/@devexps/localization-switching-locales-in-flutter-c42cf203602d



Alternative Security Config:
android:networkSecurityConfig="@xml/network_security_config"

Running Tests:
flutter pub run test --chain-stack-traces
flutter test test/models/user_test.dart

flutter test --coverage
genhtml coverage/lcov.info -o coverage
open coverage/index.html

Code Generation:
flutter packages pub run build_runner build

https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

Firebase Products:
https://firebase.flutter.dev/docs/ui/widgets

Firebase App Gallery:
https://gallery.flutter.dev/#/demo/nav_drawer and 
https://api.flutter.dev/ (fine tuned)

Material Design:
https://material.io/components/

Config App Translation:
https://pub.dev/packages/i18n_remote_config

Flutter Commands:

flutter build apk || flutter build apk --debug
flutter install
flutter clean && flutter run
flutter pub get
flutter pub cache clean

## Start Debugging 
flutter pub upgrade --dry-run
dart pub upgrade
flutter pub outdated
flutter pub upgrade --major-versions
flutter pub outdated
## End Debugging

build/app/outputs/flutter-apk/app-release.apk

