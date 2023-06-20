class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = 'https://he-test-server.uc.r.appspot.com';

  // receiveTimeout
  static const int receiveTimeout = 10 * 1000;

  // connectTimeout
  static const int connectionTimeout = 10 * 1000;

  static const String users = '/users';

  static const String userLoginPath = '/userlogin';
  static const String localEmulatorIp = '192.168.100.4';
  static const String userCacheKey = '__user_cache_key__';
  static const String updateuploadCacheKey = '__updateupload_cache_key__';
  static const String accountCacheKey = '__account_cache_key__';

  static const bool userEmulator = false;

  static const String bucketUrl = 'he-test-server.appspot.com';
}
