import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:he_api/he_api.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../test_he_api_constants.dart';


void main() async {
  group('Default Dio', () {
    late Dio dio;
    setUp(() {
      dio = Dio(BaseOptions());
    });
    test('login as user default', () async {
      final service = DataCodeApiClient(
        dio: dio,
      );
      final response = await service.userLogin(usernameWrong, passwordWrong);
      expect(
        response,
        DataCode.fromJson(<String, dynamic>{
          'code': 600,
          'msg': 'Invalid argument(s): No host specified in URI /userlogin',
          'data': User.empty.toJson()
        }),
      );
    });
  });

  group('Login STATES', () {
    late DataCodeApiClient service;
    setUp(() {
      service = DataCodeApiClient(
        dio: DataCodeApiClient.dioInit(),
      );
    });
    test('invalid login', () async {
      final response = await service.userLogin(usernameWrong, passwordWrong);
      expect(
        response,
        DataCode.fromJson(<String, dynamic>{
          'code': 403,
          'msg': 'Invalid login, please try again',
          'data': User.empty.toJson()
        }),
      );
      // final nonResponse = await service.userLogin('', '');
      // expect(
      //   () async => nonResponse,
      //   isA<DataCode>(),
      // );
    });

    test('success login', () async {
      final response = await service.userLogin(username, password);
      expect(
        response,
        DataCode.fromJson(<String, dynamic>{
          'code': 200,
          'msg': 'successfully logged in',
          'data': User.fromJson(const <String, dynamic>{
            'token': '0404e892bb10bf68e08e1c2d55b30e3d',
            'id': 3,
            'username': '11206',
            'firstname': 'Aannet',
            'lastname': 'Hanga',
            'fullname': 'Aannet Hanga',
            'email': '11206@healthyentrepreneurs.nl',
            'lang': 'en',
            'country': 'UG',
            'profileimageurlsmall':profileSmall,
            'profileimageurl':profileimageurl,
          }).toJson()
        }),
      );
    });
  });

  group('BaseLoginFunctions', () {
    late DioAdapter dioAdapter;
    setUp(() {
      dioAdapter = DioAdapter(
        dio: DataCodeApiClient.dioInit(),
      );
    });

    test('- Core Post Login Method Success test', () async {
      const route = '/userlogin';
      final token = CancelToken();
      dioAdapter.onPost(
        route,
        (server) => server.reply(
          201,
          null,
          delay: const Duration(seconds: 1),
        ),
        data: loginData,
        // You can dictate pass values and their responses
        // data: <String, dynamic>{
        //   'username': '11206',
        //   'password': 'Newuser123!',
        // },
      );
      final response = await dioAdapter.dio.post(
        route,
        cancelToken: token,
        data: loginData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      expect(response.statusCode, 201);
    });
  });
}
