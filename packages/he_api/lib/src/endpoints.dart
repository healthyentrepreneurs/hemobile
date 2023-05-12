class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = 'https://3bc2-105-163-0-75.ngrok-free.app';

  // receiveTimeout
  static const int receiveTimeout = 5 * 1000;

  // connectTimeout
  static const int connectionTimeout = 5 * 1000;

  static const String users = '/users';

  static const String userLoginPath = '/userlogin';

  static const int authFirebasePort = 9099;

  static const String localEmulatorIp = '192.168.100.4';

  static const String userCacheKey = '__user_cache_key__';
  static const String updateuploadCacheKey = '__updateupload_cache_key__';
  static const String accountCacheKey = '__account_cache_key__';

  static const bool userEmulator = true;

  static const String bucketUrl = 'he-test-server.appspot.com';
}
