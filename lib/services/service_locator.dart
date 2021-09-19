import 'package:get_it/get_it.dart';
import 'package:nl_health_app/screens/login/login_logic.dart';
import 'package:nl_health_app/screens/utilits/home_helper.dart';
import 'package:nl_health_app/services/storage_service/shared_preferences_storage.dart';
import 'package:nl_health_app/services/storage_service/storage_service.dart';

final getIt = GetIt.instance;
void setupGetIt() {
  // state management layer
  getIt.registerLazySingleton<LoginManager>(() => LoginManager());
  // service layer
  getIt.registerLazySingleton<StorageService>(() => SharedPreferencesStorage());
  // getIt.registerLazySingleton<BoxStore>(() => BoxStore());
  getIt.registerLazySingleton<HomeHelper>(() => HomeHelper());
}



