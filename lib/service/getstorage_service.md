import 'package:get_storage/get_storage.dart';

class GetStorageService {
  static Future<GetStorageService> init() async {
    await GetStorage.init();
    return GetStorageService();
  }
}
