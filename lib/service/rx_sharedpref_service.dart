import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class RxSharedPreferencesService {
  static Future<RxSharedPreferencesService> init() async {
    RxSharedPreferences(await SharedPreferences.getInstance());
    return RxSharedPreferencesService();
  }
}
