// ignore_for_file: prefer_const_constructors

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:user_api/user_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('UserApiClient', () {
    late http.Client httpClient;
    late UserApiClient userApiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      userApiClient = UserApiClient(httpClient: httpClient);
    });
    tearDown(() async {
      httpClient.close();
    });
    group('constructor', () {
      test('does not require an httpClient', () {
        expect(UserApiClient(), isNotNull);
      });
    });

    group('customeLogin', () {
      const username = 'username';
      const password = 'password';
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await userApiClient.customeLogin(username, password);
        } catch (_) {}
        verify(
          () => httpClient.post(
            Uri.http(
              baseUrl,
              '/userlogin',
              <String, String>{'username': username, 'password': password},
            ),
          ),
        ).called(1);
      });

      test('throws UserRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(500);
        when(() => httpClient.post(any())).thenAnswer((_) async => response);
        expect(
          () async => userApiClient.customeLogin(username, password),
          throwsA(isA<UserRequestFailure>()),
        );
      });

      test('throws UserNotFoundFailure on empty response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.post(any())).thenAnswer((_) async => response);
        await expectLater(
          userApiClient.customeLogin(username, password),
          throwsA(isA<UserNotFoundFailure>()),
        );
      });

      test('returns User on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
    {
  "code": 200,
  "msg": "successfully logged in",
  "data": {
    "token": "a8400b6d821f54442b9696a03e89e330",
    "id": 3,
    "username": "11206",
    "firstname": "Aannet",
    "lastname": "Hanga",
    "fullname": "Aannet Hanga",
    "email": "11206@healthyentrepreneurs.nl",
    "lang": "en.json",
    "country": "UG",
    "profileimageurlsmall": "/courseresource/localhost/moodle/theme/image.php/_s/boost/core/1641400604/u/f2",
    "profileimageurl": "/courseresource/localhost/moodle/theme/image.php/_s/boost/core/1641400604/u/f1",
    "subscriptions": [
      {
        "id": 3,
        "fullname": "Education and Prevention",
        "categoryid": 2,
        "source": "moodle",
        "summary_custome": "In Luganda .. ",
        "next_link": "3",
        "image_url_small": "/courseresource/localhost/moodle/webservice/pluginfile.php/1691/course/overviewfiles/education.png",
        "image_url": "/courseresource/localhost/moodle/webservice/pluginfile.php/1691/course/overviewfiles/education.png"
      },
      {
        "id": 4,
        "fullname": "Education and Prevention RU",
        "categoryid": 3,
        "source": "moodle",
        "summary_custome": "In Runyankole .. ",
        "next_link": "4",
        "image_url_small": "/courseresource/localhost/moodle/webservice/pluginfile.php/1814/course/overviewfiles/education.png",
        "image_url": "/courseresource/localhost/moodle/webservice/pluginfile.php/1814/course/overviewfiles/education.png"
      },
      {
        "id": 1,
        "fullname": "Workflow: ICCM children under 5 (KE)",
        "categoryid": 2,
        "source": "originalm",
        "summary_custome": "Workflow for ICCM cases. ",
        "next_link": "1",
        "image_url_small": "/surveyicon/localhost/heapp/uploadscustome/50_user_profile_picK6h.png",
        "image_url": "/surveyicon/localhost/heapp/uploadscustome/600_user_profile_picK6h.png"
      },
      {
        "id": 2,
        "fullname": "Workflow: Eye, Ear or Skin problems and PUD",
        "categoryid": 2,
        "source": "originalm",
        "summary_custome": "Use this form to send data to the nurses and doctors of HE.",
        "next_link": "2",
        "image_url_small": "/surveyicon/localhost/heapp/uploadscustome/50_user_profile_picuKP.png",
        "image_url": "/surveyicon/localhost/heapp/uploadscustome/600_user_profile_picuKP.png"
      }
    ]
  }
}
          ''',
        );
        when(() => httpClient.post(any())).thenAnswer((_) async => response);
        final actual = await userApiClient.customeLogin(username, password);
        expect(
          actual,
          isA<User>()
              .having((l) => l.fullname, 'fullname', 'Aannet Hanga')
              .having((l) => l.username, 'username', '11206')
              .having(
                (l) => l.subscriptions?.first,
                'subscriptions',
                isA<Subscription>()
                    .having((c) => c.nextLink, 'nextLink', '3')
                    .having((c) => c.categoryid, 'categoryid', 2),
              ),
        );
      });
    });
  });
}
