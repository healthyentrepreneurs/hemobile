import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class RxSharedPreferencesService {
  static Future<RxSharedPreferencesService> init() async {
    // await GetStorage.init();
    RxSharedPreferences(await SharedPreferences.getInstance());
    return RxSharedPreferencesService();
  }
}
