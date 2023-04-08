class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = 'http://172.20.10.2:5051';

  // receiveTimeout
  static const int receiveTimeout = 2 * 1000;

  // connectTimeout
  static const int connectionTimeout = 2 * 1000;

  static const String users = '/users';

  static const String userLoginPath = '/userlogin';

  static const int authFirebasePort = 9099;

  static const String localEmulatorIp = '172.20.10.2';

  static const String userCacheKey = '__user_cache_key__';
  static const String accountCacheKey = '__account_cache_key__';

  static const bool userEmulator = true;

  static const String bucketUrl = 'he-test-server.appspot.com';
}
