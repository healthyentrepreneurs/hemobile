[Test Library](https://ricardo-castellanos-herreros.medium.com/unit-widget-and-integration-testing-in-flutter-14-best-packages-for-testing-386930b8e2a8)

Tools Used:
https://pub.dev/packages/very_good_cli | very_good_analysis

Trans
https://pub.dev/packages/klocalizations_flutter
https://abcdevops.com/blog/2019/07/01/Flutter-Internationalization-with-Manual-Locale-switch.html
https://medium.com/@devexps/localization-switching-locales-in-flutter-c42cf203602d



Alternative Security Config:
android:networkSecurityConfig="@xml/network_security_config"

Running Tests:
flutter pub run test --chain-stack-traces
flutter test test/models/user_test.dart
flutter test test/src/tlcl_stg_account_api_test.dart --plain-name 'deleteAccount'

flutter test --coverage 
genhtml coverage/lcov.info -o coverage
open coverage/index.html

https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

Firebase Products:
https://firebase.flutter.dev/docs/ui/widgets

Firebase App Gallery:
https://gallery.flutter.dev/#/demo/nav_drawer and 
https://api.flutter.dev/ (fine tuned)

Material Design:
https://material.io/components

Config App Translation:
https://pub.dev/packages/i18n_remote_config

Flutter Commands:

flutter build apk || flutter build apk --debug | --release | --profile
flutter install
flutter clean && flutter run
flutter pub get
flutter pub cache clean

## Start Debugging Steps
flutter pub upgrade --dry-run
dart pub upgrade
flutter pub outdated
flutter pub upgrade --major-versions
flutter pub outdated
## End Debugging

## Create / Test Packages
flutter create --template=package open_meteo_api
very_good create firebase_repository -o packages -t dart_pkg --desc "Channel Data Sources From Repo"

## Blocs Info
https://bloclibrary.dev/#/coreconcepts?id=observing-a-bloc
https://verygood.ventures/blog/how-to-use-bloc-with-streams-and-concurrency

build/app/outputs/flutter-apk/app-release.apk

## Flutter Downloader
https://pub.dev/packages/flutter_downloader

### JSON and SERIALIZATION:
> https://docs.flutter.dev/development/data-and-backend/json
(Naming Convention)[https://bloclibrary.dev/#/blocnamingconventions?id=subclasses-1]

[zsh: command not found: very_good](https://bytemeta.vip/repo/VeryGoodOpenSource/very_good_cli/issues/100)

create package:datalayer under packages/datalayer

very_good create local_storage_todos_api -o packages -t flutter_pkg --desc "A Flutter implementation of the TodosApi that uses local storage."

very_good packages get --recursive

flutter run --flavor development --target lib/main_development.dart

