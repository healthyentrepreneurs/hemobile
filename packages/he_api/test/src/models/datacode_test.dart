import 'package:flutter_test/flutter_test.dart';
import 'package:he_api/he_api.dart';

import '../test_he_api_constants.dart';


void main() {
  group('DataCode', () {
    group('DataCode fromJson', () {
      test('returns correct DataCode object', () {
        expect(
          DataCode.fromJson(
            const <String, dynamic>{
              'code': 200,
              'msg': 'successfully logged in',
              'data': {
                'token': '0404e892bb10bf68e08e1c2d55b30e3d',
                'id': 3,
                'username': '11206',
                'firstname': 'Annet',
                'lastname': 'Hanga',
                'fullname': 'Aannet Hanga',
                'email': '11206@healthyentrepreneurs.nl',
                'lang': 'en',
                'country': 'UG',
                'profileimageurlsmall': profileSmall,
                'profileimageurl': profileimageurl,
                'subscriptions': [
                  {
                    'id': 3,
                    'fullname': 'Education and Prevention',
                    'categoryid': 2,
                    'source': 'moodle',
                    'summary_custome': 'In Luganda .. ',
                    'next_link': '3',
                    'image_url_small': imageUrlSmall,
                    'image_url': imageUrl
                  },
                  {
                    'id': 4,
                    'fullname': 'Education and Prevention RU',
                    'categoryid': 3,
                    'source': 'moodle',
                    'summary_custome': 'In Runyankole .. ',
                    'next_link': '4',
                    'image_url_small': imageUrlSmall,
                    'image_url': imageUrl
                  },
                ]
              }
            },
          ),
          isA<DataCode>()
              .having((w) => w.code, 'code', 200)
              .having((w) => w.msg, 'name', 'successfully logged in'),
        );
      });
    });
    test('isEmpty returns true for empty datacode', () {
      expect(DataCode.empty.isEmpty, isTrue);
    });
    test('isEmpty returns false for non-empty datacode', () {
      const datacode = DataCode(
        code: 200,
        msg: 'fullname',
        data: User.empty,
      );
      expect(datacode.isEmpty, isFalse);
    });
  });
}
