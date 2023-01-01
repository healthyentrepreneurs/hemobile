import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:he_api/he_api.dart';

///DataCodeApiClient
class DataCodeApiClient {
  ///DataCodeApiClient Constructor
  DataCodeApiClient({Dio? dio}) : _dio = dio ?? dioInit();
  final Dio _dio;

  // ignore: public_member_api_docs
  static Dio dioInit() {
    final options = BaseOptions(
      baseUrl: Endpoints.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Endpoints.connectionTimeout, // 60 seconds
      receiveTimeout: Endpoints.receiveTimeout, // 60 seconds
    );
    final dio = Dio(options);
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 2,
        retryDelays: const [
          Duration(seconds: 2),
          Duration(seconds: 2),
        ],
      ),
    );
    return dio;
  }

  Future<DataCode?> userLogin(String username, String password) async {
    final token = CancelToken();
    try {
      // final logRes = await _dio.post(
      //   Endpoints.userLoginPath,
      //   cancelToken: token,
      //   data: {'username': username, 'password': password},
      //   options: Options(contentType: Headers.formUrlEncodedContentType),
      // );
      final logRes = await _dio.post(Endpoints.userLoginPath,
          data: FormData.fromMap({'username': username,
          'password': password}),);
      return DataCode.fromJson(logRes.data as Map<String, dynamic>);
    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        print('Namu ${ex.error.toString()}');
        token.cancel('Connection timeout');
        return DataCode.fromJson(<String, dynamic>{
          'code': 403,
          'msg': 'No Internet connection',
          'data': User.empty.toJson()
        });
        // throw const DataCodeConnectTimeout();
      }
      if (ex.type == DioErrorType.receiveTimeout) {
        // 403 Forbidden
        token.cancel('Receive timeout');
        return DataCode.fromJson(<String, dynamic>{
          'code': 403,
          'msg': 'Contact HE offices :)',
          'data': User.empty.toJson()
        });
        // throw const ReceiveTimeout();
      }
      if (ex.type == DioErrorType.response) {
        final statusCode = ex.response?.statusCode.toString();
        switch (statusCode) {
          case '403':
            final nonUserExist =
                DataCode.fromJson(ex.response?.data as Map<String, dynamic>);
            return DataCode.fromJson(<String, dynamic>{
              'code': 403,
              'msg': nonUserExist.msg,
              'data': User.empty.toJson()
            });
          case '500':
            return DataCode.fromJson(<String, dynamic>{
              'code': 500,
              'msg': 'Username, Password required',
              'data': User.empty.toJson()
            });
          default:
            return DataCode.fromJson(<String, dynamic>{
              'code': ex.response?.statusCode,
              'msg': ex.error.toString(),
              'data': User.empty.toJson()
            });
        }
      }
      if (ex.type == DioErrorType.other) {
        return DataCode.fromJson(<String, dynamic>{
          'code': 600,
          'msg': 'Invalid argument(s): No host specified in URI /userlogin',
          'data': User.empty.toJson()
        });
      } else {
        return DataCode.fromJson(<String, dynamic>{
          'code': 666,
          'msg': ex.error.toString(),
          'data': User.empty.toJson()
        });
      }
    }
  }
}

// How to run this class
/*
* final client = DataCodeApiClient(); or
* final client = DataCodeApiClient(
    dio: DataCodeApiClient.dioInit(),
  );
  var testNa = await client.userLogin('', '');
* */
